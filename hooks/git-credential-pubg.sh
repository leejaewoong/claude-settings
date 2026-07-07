#!/usr/bin/env bash
# git credential helper: claude-marketplace.pubg.io 인증 정보를 ~/.claude/.env에서 읽는다.
# settings.json의 마켓플레이스 URL에 API 키를 평문으로 넣지 않기 위한 분리 장치.
# 등록은 register_pubg_credential.sh(SessionStart 훅)가 머신마다 한 번 자동 수행:
#   git config --global credential."https://claude-marketplace.pubg.io".helper '!bash ~/.claude/hooks/git-credential-pubg.sh'
[ "${1:-}" = "get" ] || exit 0
ENV_FILE="$HOME/.claude/.env"
[ -f "$ENV_FILE" ] || exit 0
KEY="$(sed -n 's/^PUBG_MARKETPLACE_API_KEY=//p' "$ENV_FILE" | tail -n 1 | tr -d '\r')"
[ -n "$KEY" ] || exit 0
printf 'username=api-key\npassword=%s\n' "$KEY"
