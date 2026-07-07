#!/usr/bin/env bash
# revise_claude_trigger.sh
#
# Triggered on PreCompact via ~/.claude/settings.json hooks. (SessionEnd에는
# 걸지 않는다 — 세션 종료 시점엔 additionalContext를 소비할 모델 턴이 없다.)
# Emits hookSpecificOutput.additionalContext to nudge Claude into reviewing
# session learnings and proposing CLAUDE.md updates via the
# /claude-md-management:revise-claude-md slash command — only when there is
# durable, non-trivial learning worth preserving.

# Drain hook input JSON from stdin; not parsed here.
cat >/dev/null 2>&1

cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreCompact",
    "additionalContext": "[revise-claude trigger] Before this session's context gets compacted, review what was actually learned during the conversation and decide if any of it deserves to be preserved in CLAUDE.md. Look specifically for: commands or invocation patterns that worked and would be useful again, project-specific conventions you discovered, environment quirks or gotchas (paths, shells, OS), testing or build patterns, naming or style rules the user reinforced, and pitfalls worth warning future-you about. If — and ONLY IF — there is a clear, durable learning worth keeping, invoke the /claude-md-management:revise-claude-md slash command so the user can approve the proposed edit. If the session was trivial, short, exploratory-only, or had no real learning, say nothing and do not invoke the command. Be highly selective: noise defeats the purpose. One concise line per learning is the bar; vague generalities are not."
  }
}
EOF
