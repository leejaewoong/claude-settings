#!/bin/bash
# browse 데몬 확인 + 서버 헬스체크 + 필요 시 서버 기동
# exit 0: 모두 정상 / exit 1: 실패 / exit 3: browse 데몬 미실행

BROWSE_BIN="${AUTO_QA_BROWSE_BIN:-$HOME/.claude/skills/gstack/browse/dist/browse}"
PORT="${AUTO_QA_SERVER_PORT:-3000}"
HEALTH_URL="${AUTO_QA_HEALTH_URL:-http://localhost:3000}"
SERVER_CMD="${AUTO_QA_SERVER_CMD:-npm run dev}"
TIMEOUT="${AUTO_QA_HEALTH_TIMEOUT:-30}"

# 1. browse 데몬 확인
if [ ! -f "$BROWSE_BIN" ]; then
  echo "browse 바이너리를 찾을 수 없습니다: $BROWSE_BIN"
  exit 3
fi

if ! pgrep -f "gstack.*browse" >/dev/null 2>&1; then
  # 데몬이 안 떠 있으면 시작 시도
  echo "browse 데몬이 실행 중이 아닙니다. 시작을 시도합니다..."
  "$BROWSE_BIN" &>/dev/null &
  sleep 2
  if ! pgrep -f "gstack.*browse" >/dev/null 2>&1; then
    echo "browse 데몬 시작 실패"
    exit 3
  fi
  echo "browse 데몬 시작 완료"
fi

# 2. 포트 점유 확인 → 헬스체크
if lsof -i :"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  if curl -sf --max-time 5 "$HEALTH_URL" >/dev/null 2>&1; then
    echo "서버 정상 동작 중 (포트: $PORT)"
    exit 0
  fi
fi

# 3. 서버 기동
echo "서버를 기동합니다: $SERVER_CMD"
nohup $SERVER_CMD > /tmp/auto-qa-server.log 2>&1 &
SERVER_PID=$!
echo "$SERVER_PID" > /tmp/auto-qa-server.pid

# 4. 헬스체크 폴링
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
  if curl -sf --max-time 3 "$HEALTH_URL" >/dev/null 2>&1; then
    echo "서버 기동 완료 (${ELAPSED}초 소요)"
    exit 0
  fi
  sleep 2
  ELAPSED=$((ELAPSED + 2))
done

echo "서버 기동 실패 (${TIMEOUT}초 타임아웃)"
exit 1
