#!/bin/bash
# Auto QA 메인 트리거 (Stop Hook에서 호출)
# exit 0: 정상 종료 (Claude 멈춤)
# exit 2: Claude 계속 작업 (재구현 또는 QA 실행 요청)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

RETRY_FILE="$PROJECT_ROOT/.auto-qa-retries"
HANDOFF_FILE="$PROJECT_ROOT/.auto-qa-handoff"
MAX_RETRIES="${AUTO_QA_MAX_RETRIES:-5}"
BASE_URL="${AUTO_QA_BASE_URL:-http://localhost:3000}"

# --- 핸드오프 상태 확인 ---
# 이전 QA에서 핸드오프가 발생했으면 자동 루프 중단
if [ -f "$HANDOFF_FILE" ]; then
  rm -f "$HANDOFF_FILE"
  rm -f "$RETRY_FILE"
  echo '{"additionalContext": "🤚 Auto QA: 이전 실행에서 핸드오프(CAPTCHA/MFA)가 감지되었습니다. $B handoff로 문제를 해결한 뒤 /auto-qa를 수동 실행하세요. 자동 루프를 중단합니다."}'
  exit 0
fi

# --- 재시도 카운터 ---
CURRENT_RETRIES=0
if [ -f "$RETRY_FILE" ]; then
  CURRENT_RETRIES=$(cat "$RETRY_FILE" 2>/dev/null || echo 0)
fi

# --- 최대 재시도 초과 ---
if [ "$CURRENT_RETRIES" -ge "$MAX_RETRIES" ]; then
  rm -f "$RETRY_FILE"
  echo '{"additionalContext": "⚠️ Auto QA: '"$MAX_RETRIES"'회 재시도 모두 실패했습니다. QA를 통과하지 못한 문제를 사용자에게 보고하세요. 자동 재시도를 중단합니다."}'
  exit 0
fi

# --- git diff 확인 ---
if ! "$SCRIPT_DIR/check_diff.sh"; then
  rm -f "$RETRY_FILE"
  exit 0
fi

# --- browse 데몬 + 서버 헬스체크 ---
HEALTH_RESULT=$("$SCRIPT_DIR/health_check.sh" 2>&1)
HEALTH_EXIT=$?

if [ "$HEALTH_EXIT" -eq 3 ]; then
  # browse 데몬 문제
  echo '{"additionalContext": "⚠️ Auto QA: browse 데몬($B)이 실행되지 않습니다. gstack browse를 먼저 설정하세요. '"$HEALTH_RESULT"'"}'
  exit 0
fi

if [ "$HEALTH_EXIT" -ne 0 ]; then
  # 서버 기동 실패
  echo '{"additionalContext": "⚠️ Auto QA: 서버를 기동할 수 없습니다. 서버 설정을 확인하고 수동으로 서버를 시작한 뒤 /auto-qa를 실행하세요."}'
  exit 0
fi

# --- QA 실행 요청 (/qa-only 사용) ---
if [ "$CURRENT_RETRIES" -eq 0 ]; then
  echo '{"additionalContext": "🔍 Auto QA: 소스코드 변경이 감지되었습니다. /qa-only '"$BASE_URL"'를 실행하여 변경 사항을 검증하세요. 리포트 결과에 따라: 통과 시 결과를 안내하고, 실패 시 리포트의 문제를 직접 수정하세요. 핸드오프(CAPTCHA/MFA)가 발생하면 touch '"$HANDOFF_FILE"' 후 사용자에게 알리세요. 현재 재시도: 0/'"$MAX_RETRIES"'"}'
else
  echo '{"additionalContext": "🔄 Auto QA: 이전 /qa-only에서 문제가 발견되어 수정 후 재검증합니다. /qa-only '"$BASE_URL"'를 실행하세요. 핸드오프 발생 시 touch '"$HANDOFF_FILE"' 후 사용자에게 알리세요. 현재 재시도: '"$CURRENT_RETRIES"'/'"$MAX_RETRIES"'"}'
fi

# 재시도 카운터 증가
echo $((CURRENT_RETRIES + 1)) > "$RETRY_FILE"

exit 2
