#!/bin/bash
# browse 데몬 확인 + 서버 헬스체크 + 필요 시 서버 기동
# exit 0: 모두 정상 / exit 1: 실패 / exit 3: browse 데몬 미실행
# Windows Git Bash 호환: pgrep/lsof/nohup에 의존하지 않는다.

BROWSE_BIN="${AUTO_QA_BROWSE_BIN:-$HOME/.claude/skills/gstack/browse/dist/browse}"
HEALTH_URL="${AUTO_QA_HEALTH_URL:-http://localhost:3000}"
SERVER_CMD="${AUTO_QA_SERVER_CMD:-npm run dev}"
TIMEOUT="${AUTO_QA_HEALTH_TIMEOUT:-30}"
LOG_FILE="${TMPDIR:-/tmp}/auto-qa-server.log"
PID_FILE="${TMPDIR:-/tmp}/auto-qa-server.pid"

# 프로세스 확인: pgrep이 있으면 사용, 없으면(Windows Git Bash) ps -W로 대체
browse_running() {
  if command -v pgrep >/dev/null 2>&1; then
    pgrep -f "gstack.*browse" >/dev/null 2>&1
  else
    ps -W 2>/dev/null | grep -i "gstack" | grep -i "browse" | grep -v grep >/dev/null 2>&1
  fi
}

# 1. browse 데몬 확인
if [ ! -f "$BROWSE_BIN" ]; then
  echo "browse 바이너리를 찾을 수 없습니다: $BROWSE_BIN"
  exit 3
fi

if ! browse_running; then
  # 데몬이 안 떠 있으면 시작 시도
  echo "browse 데몬이 실행 중이 아닙니다. 시작을 시도합니다..."
  ("$BROWSE_BIN" >/dev/null 2>&1 &)
  sleep 2
  if ! browse_running; then
    echo "browse 데몬 시작 실패"
    exit 3
  fi
  echo "browse 데몬 시작 완료"
fi

# 2. 헬스체크 (포트 점유 확인 대신 응답 자체를 본다 — lsof 불필요)
if curl -sf --max-time 5 "$HEALTH_URL" >/dev/null 2>&1; then
  echo "서버 정상 동작 중 ($HEALTH_URL)"
  exit 0
fi

# 3. 서버 기동 (bash -c로 감싸 인용된 인자를 보존, 서브셸 백그라운드로 분리)
echo "서버를 기동합니다: $SERVER_CMD"
(bash -c "$SERVER_CMD" > "$LOG_FILE" 2>&1 &
 echo $! > "$PID_FILE")

# 4. 헬스체크 폴링
ELAPSED=0
while [ "$ELAPSED" -lt "$TIMEOUT" ]; do
  if curl -sf --max-time 3 "$HEALTH_URL" >/dev/null 2>&1; then
    echo "서버 기동 완료 (${ELAPSED}초 소요)"
    exit 0
  fi
  sleep 2
  ELAPSED=$((ELAPSED + 2))
done

echo "서버 기동 실패 (${TIMEOUT}초 타임아웃, 로그: $LOG_FILE)"
exit 1
