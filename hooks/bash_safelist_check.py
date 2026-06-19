#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""PreToolUse hook for Claude Code's Bash tool.

Reads JSON from stdin. If every atomic executable inside the bash command
appears in ~/.claude/bash-safelist.txt, prints an "allow" decision. Otherwise
exits silently so Claude Code falls through to the normal permission flow.

Design rule: this hook NEVER denies. Worst case = same prompt the user would
have seen without the hook. Any internal failure (bad input, parse error,
missing safelist, unknown atom) falls through.

Atom resolution mirrors the allow-cmd skill convention:
  - `git status`           -> "git status"
  - `git -C /repo status`  -> "git -C"
  - `sudo -u root cat ...` -> "sudo cat"
  - `FOO=bar python x.py`  -> "python"   (env assignments stripped)
  - `for x in $(git ls-files); do echo y | grep z; done`
      -> ["git ls-files", "echo", "grep"]   (control keywords transparent,
                                             subshells and pipelines walked)
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

SAFELIST_PATH = Path.home() / ".claude" / "bash-safelist.txt"

GIT_VALUE_OPTS = {
    "-C", "-c", "--git-dir", "--work-tree", "--namespace",
    "--exec-path", "--super-prefix",
}
SUDO_VALUE_OPTS = {"-u", "-g", "-U", "-r", "-t", "-h", "-C", "-D", "-p", "-T"}

# Pure shell-syntax helpers with no external execution. Skipped from atoms
# so users don't need to list them in the safelist.
TRANSPARENT_BUILTINS = {":", "true", "false", "[", "[[", "test"}


def load_safelist():
    if not SAFELIST_PATH.exists():
        return None
    items = set()
    for raw in SAFELIST_PATH.read_text(encoding="utf-8").splitlines():
        line = raw.split("#", 1)[0].strip()
        if line:
            items.add(line)
    return items


def extract_atoms(command_str):
    try:
        import bashlex
        trees = bashlex.parse(command_str)
    except Exception:
        return None
    atoms = []
    for tree in trees:
        _walk(tree, atoms)
    return atoms


def _walk(node, atoms):
    if not hasattr(node, "kind"):
        return
    kind = node.kind

    if kind == "command":
        atom = _extract_command_atom(node)
        if atom:
            atoms.append(atom)
        for part in getattr(node, "parts", []) or []:
            _walk_substitutions(part, atoms)
        return

    if kind in ("list", "pipeline"):
        for part in getattr(node, "parts", []) or []:
            _walk(part, atoms)
        return

    if kind == "compound":
        for part in getattr(node, "list", []) or []:
            _walk(part, atoms)
        for redir in getattr(node, "redirects", []) or []:
            _walk(redir, atoms)
        return

    if kind in ("operator", "reservedword"):
        return

    if kind == "function":
        body = getattr(node, "body", None)
        if body is not None:
            _walk(body, atoms)
        return

    for attr in ("parts", "list"):
        children = getattr(node, attr, None)
        if isinstance(children, list):
            for c in children:
                _walk(c, atoms)
    inner_cmd = getattr(node, "command", None)
    if inner_cmd is not None and hasattr(inner_cmd, "kind"):
        _walk(inner_cmd, atoms)


def _walk_substitutions(part, atoms):
    if not hasattr(part, "kind"):
        return
    if part.kind in ("commandsubstitution", "processsubstitution"):
        cmd = getattr(part, "command", None)
        if cmd is not None:
            _walk(cmd, atoms)
    for child in getattr(part, "parts", []) or []:
        _walk_substitutions(child, atoms)


def _extract_command_atom(command_node):
    words = []
    for part in getattr(command_node, "parts", []) or []:
        if not hasattr(part, "kind"):
            continue
        if part.kind in ("assignment", "redirect"):
            continue
        if part.kind == "word":
            w = getattr(part, "word", None)
            if w is not None:
                words.append(w)

    if not words:
        return None

    exe = words[0]
    if exe in TRANSPARENT_BUILTINS:
        return None
    if exe == "git":
        return _resolve_git(words)
    if exe == "sudo":
        return _resolve_sudo(words)
    return exe


def _resolve_git(words):
    if len(words) == 1:
        return "git"
    i = 1
    first_opt_key = None
    while i < len(words):
        w = words[i]
        if not w.startswith("-"):
            return f"git {first_opt_key}" if first_opt_key else f"git {w}"
        key = w.split("=", 1)[0]
        if first_opt_key is None:
            first_opt_key = key
        if w in GIT_VALUE_OPTS and "=" not in w:
            i += 2
        else:
            i += 1
    return "git"


def _resolve_sudo(words):
    i = 1
    while i < len(words):
        w = words[i]
        if w == "--":
            i += 1
            break
        if not w.startswith("-"):
            break
        if w in SUDO_VALUE_OPTS:
            i += 2
        else:
            i += 1
    if i < len(words):
        return f"sudo {words[i]}"
    return "sudo"


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0

    if payload.get("tool_name") != "Bash":
        return 0

    command = (payload.get("tool_input") or {}).get("command") or ""
    if not command.strip():
        return 0

    safelist = load_safelist()
    if safelist is None:
        return 0

    atoms = extract_atoms(command)
    if not atoms:
        return 0

    missing = [a for a in atoms if a not in safelist]
    if missing:
        return 0

    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "allow",
            "permissionDecisionReason": "bash-safelist: " + ", ".join(sorted(set(atoms))),
        }
    }))
    return 0


def explain(command_str):
    """Inspection mode used by the /allow-cmd skill.

    Returns a dict describing how this command would be resolved against the
    current safelist. The hook auto-approves only when `missing` is empty
    and `parse_ok` is true.
    """
    safelist = load_safelist()
    atoms = extract_atoms(command_str)
    parse_ok = atoms is not None
    atoms = atoms or []
    if safelist is None:
        # No safelist file exists yet — every atom is "missing".
        missing = sorted(set(atoms))
        safelisted = []
    else:
        safelisted = sorted({a for a in atoms if a in safelist})
        missing = sorted({a for a in atoms if a not in safelist})
    return {
        "command": command_str,
        "parse_ok": parse_ok,
        "atoms": atoms,
        "safelisted": safelisted,
        "missing": missing,
        "safelist_path": str(SAFELIST_PATH),
        "safelist_exists": safelist is not None,
    }


if __name__ == "__main__":
    if len(sys.argv) >= 2 and sys.argv[1] == "--explain":
        if len(sys.argv) >= 3:
            cmd = sys.argv[2]
        else:
            cmd = sys.stdin.read()
        print(json.dumps(explain(cmd), ensure_ascii=False, indent=2))
        sys.exit(0)
    sys.exit(main())
