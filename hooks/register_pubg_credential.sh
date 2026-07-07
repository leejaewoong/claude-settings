#!/usr/bin/env bash
# SessionStart hook: pubg 마켓플레이스 git credential helper 등록 (머신마다 한 번).
# settings.json의 마켓플레이스 URL에서 API 키를 분리(.env)했으므로, 해당 호스트의
# git 인증은 hooks/git-credential-pubg.sh가 담당한다. 첫 항목의 빈 문자열은 상위
# helper(예: Windows credential manager)를 이 호스트에 한해 무시시키는 표준 리셋.
# 이미 등록돼 있으면 아무것도 하지 않는다(멱등).
set -u
CRED_KEY='credential.https://claude-marketplace.pubg.io.helper'
CRED_VAL='!bash ~/.claude/hooks/git-credential-pubg.sh'
if [ "$(git config --global --get-all "$CRED_KEY" 2>/dev/null | tail -n 1)" != "$CRED_VAL" ]; then
  git config --global --replace-all "$CRED_KEY" '' &&
    git config --global --add "$CRED_KEY" "$CRED_VAL" &&
    echo "[.claude cred] pubg 마켓플레이스 git credential helper 등록 완료."
fi
exit 0
