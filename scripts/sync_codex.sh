#!/usr/bin/env bash
# SessionStart hook: ~/.claude 저장소 → Codex 파생물 동기화.
#  ⓪ Codex 미설치 머신이면 전체 생략 (Claude 전용 머신 지원)
#  ① CLAUDE.md → ~/.codex/AGENTS.md 생성 (해시 가드: 직접 수정 시 덮어쓰지 않고 안내)
#  ② codex/hooks.json → ~/.codex/hooks.json 설치 (동일한 해시 가드)
#  ③ 스킬별 정션 멱등 생성/정리 (sync_codex_junctions.ps1 위임, 제외 목록 적용)
#  ④ 비정션 폴더 감지 → 새 스킬 입양 안내(옵트인) / import 재발 경고
# 원칙: 파생물은 "우리가 마지막으로 생성한 상태 그대로"일 때만 덮어쓴다.
# 조용한 no-op: 변화가 없으면 아무것도 출력하지 않는다.
set -u

REPO="$HOME/.claude"
CODEX_HOME="$HOME/.codex"
STATE="$REPO/.codex-sync-state.json"
prefix="[codex sync]"

# ── ⓪ Codex 미설치 → 조용히 생략 ─────────────────────────────────────────
if ! command -v codex >/dev/null 2>&1 && [ ! -d "$CODEX_HOME" ]; then
  exit 0
fi
mkdir -p "$CODEX_HOME"

hash_file() { if [ -f "$1" ]; then sha256sum "$1" | cut -d' ' -f1; else echo absent; fi; }
state_get() { grep -o "\"$1\": *\"[^\"]*\"" "$STATE" 2>/dev/null | sed 's/.*: *"//;s/"$//'; }

# 생성 규칙: 생성 헤더 + CLAUDE.md 본문(제목만 치환)
gen_agents() {
  printf '%s\n' \
    '<!-- AUTO-GENERATED from ~/.claude/CLAUDE.md — 직접 수정하지 마세요.' \
    '     수정은 CLAUDE.md에 하세요. 세션 시작 시 이 파일이 재생성됩니다.' \
    '     직접 수정된 경우 동기화가 덮어쓰지 않고 안내합니다. -->'
  sed '1s/^# CLAUDE\.md$/# AGENTS.md/' "$REPO/CLAUDE.md"
}

# 파생물 하나를 해시 가드로 갱신한다.
#   $1: 파생물 경로  $2: state 키  $3: 기대 내용을 담은 임시 파일  $4: 표시 이름
# 반환(전역): NEW_HASH — 저장할 현재 해시
sync_derived() {
  local dest="$1" key="$2" gen_file="$3" label="$4"
  local gen_hash cur_hash st_hash
  gen_hash="$(hash_file "$gen_file")"
  cur_hash="$(hash_file "$dest")"
  st_hash="$(state_get "$key")"

  if [ "$cur_hash" = "$gen_hash" ]; then
    NEW_HASH="$cur_hash"                     # 이미 최신 (첫 실행이면 상태만 채택)
  elif [ "$cur_hash" = "absent" ] || [ "$cur_hash" = "$st_hash" ]; then
    cp "$gen_file" "$dest"                   # 없거나, 마지막 생성 상태 그대로 → 갱신
    NEW_HASH="$gen_hash"
    echo "$prefix $label 갱신 완료."
  else
    # 직접 수정 감지 → 보존. state는 갱신하지 않는다(갱신하면 다음 세션이
    # "마지막 생성 상태"로 오판해 조용히 덮어씀 → 해소될 때까지 매 세션 경고).
    NEW_HASH="$st_hash"
    echo "$prefix ⚠ $label 이(가) 직접 수정되어 덮어쓰지 않음. 원본(CLAUDE.md 또는 codex/)에 반영 후 다음 세션에서 해소하세요. (diff: $dest vs 저장소 원본)"
  fi
}

# ── ① AGENTS.md ──────────────────────────────────────────────────────────
TMP_AGENTS="$(mktemp)"; gen_agents > "$TMP_AGENTS"
sync_derived "$CODEX_HOME/AGENTS.md" agents_md_hash "$TMP_AGENTS" "~/.codex/AGENTS.md"
AGENTS_HASH="$NEW_HASH"; rm -f "$TMP_AGENTS"

# ── ② hooks.json ─────────────────────────────────────────────────────────
sync_derived "$CODEX_HOME/hooks.json" hooks_json_hash "$REPO/codex/hooks.json" "~/.codex/hooks.json"
HOOKS_HASH="$NEW_HASH"

printf '{\n  "agents_md_hash": "%s",\n  "hooks_json_hash": "%s"\n}\n' \
  "$AGENTS_HASH" "$HOOKS_HASH" > "$STATE"

# ── ③④ 정션 관리 (PowerShell 위임) ───────────────────────────────────────
PS_OUT="$(powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$REPO/scripts/sync_codex_junctions.ps1")" 2>/dev/null | tr -d '\r')"
while IFS= read -r line; do
  case "$line" in
    junction-created:*) echo "$prefix 스킬 정션 생성: ${line#junction-created: }" ;;
    junction-removed:*) echo "$prefix 스킬 정션 정리(원본 삭제/제외됨): ${line#junction-removed: }" ;;
    warn-copy:*)        echo "$prefix ⚠ ~/.agents/skills/${line#warn-copy: } 이(가) 정션이 아닌 사본임 — Codex import 재실행 의심. 원본은 ~/.claude/skills에 있으니 사본을 지우면 다음 세션에서 자동 정션됩니다." ;;
    new-skill:*)        echo "$prefix 새 스킬 발견: ${line#new-skill: } — 입양(옵트인)하려면 ~/.claude/skills/로 이동 후 커밋하세요. 다음 세션에서 자동 정션됩니다." ;;
  esac
done <<< "$PS_OUT"

exit 0
