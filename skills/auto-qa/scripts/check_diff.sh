#!/bin/bash
# 소스코드 변경 감지
# exit 0: 소스코드 변경 있음 / exit 1: 변경 없음

SOURCE_PATTERNS="${AUTO_QA_SOURCE_PATTERNS:-src/,app/,pages/,components/}"
IGNORE_PATTERNS="${AUTO_QA_IGNORE_PATTERNS:-*.test.*,*.spec.*,*.md,*.json}"

# diff 대상 파일 목록 (커밋되지 않은 변경 포함)
CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null)

if [ -z "$CHANGED_FILES" ]; then
  CHANGED_FILES=$(git diff --name-only 2>/dev/null)
fi

if [ -z "$CHANGED_FILES" ]; then
  exit 1
fi

# 소스 패턴 매칭
IFS=',' read -ra PATTERNS <<< "$SOURCE_PATTERNS"
IFS=',' read -ra IGNORES <<< "$IGNORE_PATTERNS"

MATCHED=false
while IFS= read -r file; do
  SKIP=false
  for ignore in "${IGNORES[@]}"; do
    if [[ "$file" == $ignore ]]; then
      SKIP=true
      break
    fi
  done
  [ "$SKIP" = true ] && continue

  for pattern in "${PATTERNS[@]}"; do
    if [[ "$file" == ${pattern}* ]]; then
      MATCHED=true
      break 2
    fi
  done
done <<< "$CHANGED_FILES"

if [ "$MATCHED" = true ]; then
  exit 0
else
  exit 1
fi
