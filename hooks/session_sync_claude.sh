#!/usr/bin/env bash
# SessionStart hook: keep the ~/.claude config repo in sync across machines.
# Detects local working-tree changes and remote commits, then fast-forwards
# ONLY when it is safe (clean tree, behind, not ahead). Never blocks, never
# discards work. Output goes to stdout and is injected as session context.
set -u

REPO="$HOME/.claude"

# Bail quietly if it's not a git repo or has no upstream tracking branch.
git -C "$REPO" rev-parse --git-dir >/dev/null 2>&1 || exit 0
UPSTREAM="$(git -C "$REPO" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)" || exit 0
[ -n "$UPSTREAM" ] || exit 0

# Fetch without ever hanging: hard timeout + never prompt for credentials.
GIT_TERMINAL_PROMPT=0 timeout 10 git -C "$REPO" fetch --quiet 2>/dev/null
FETCH_RC=$?

# Working-tree dirty? (uncommitted or untracked changes)
DIRTY=""
[ -n "$(git -C "$REPO" status --porcelain 2>/dev/null)" ] && DIRTY=1

# Commits behind / ahead of upstream.
read -r BEHIND AHEAD < <(git -C "$REPO" rev-list --left-right --count "HEAD...$UPSTREAM" 2>/dev/null)
BEHIND=${BEHIND:-0}; AHEAD=${AHEAD:-0}

prefix="[.claude sync]"

# Remote unreachable -> report cached state only.
if [ "$FETCH_RC" -ne 0 ]; then
  echo "$prefix 원격 확인 실패(오프라인?). 로컬 기준 behind=$BEHIND ahead=$AHEAD${DIRTY:+, 로컬 변경 있음}."
  exit 0
fi

# Already current with remote.
if [ "$BEHIND" -eq 0 ]; then
  if [ "$AHEAD" -gt 0 ]; then
    echo "$prefix 최신(원격보다 $AHEAD 커밋 앞섬, 푸시 대기)${DIRTY:+ · 커밋 안 된 변경 있음}."
  else
    echo "$prefix 최신 상태${DIRTY:+ (단, 커밋 안 된 로컬 변경 있음)}."
  fi
  exit 0
fi

# Behind remote, but not safe to touch -> report only, leave the tree alone.
if [ -n "$DIRTY" ] || [ "$AHEAD" -gt 0 ]; then
  reason=""
  [ -n "$DIRTY" ] && reason="로컬 변경"
  [ "$AHEAD" -gt 0 ] && reason="${reason:+$reason·}로컬 커밋 ${AHEAD}개"
  echo "$prefix 원격이 $BEHIND 커밋 앞서나 ${reason} 때문에 자동 갱신 보류. 수동 처리 필요(stash 후 git pull --ff-only 등)."
  exit 0
fi

# Safe: clean tree, behind, not ahead -> fast-forward.
if git -C "$REPO" merge --ff-only --quiet "$UPSTREAM" 2>/dev/null; then
  echo "$prefix 원격 $BEHIND 커밋을 자동 반영(fast-forward) 완료."
else
  echo "$prefix 원격이 $BEHIND 커밋 앞서나 fast-forward 실패. 수동 확인 필요."
fi
exit 0
