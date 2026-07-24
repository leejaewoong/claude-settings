---
name: auto-qa
description: |
  코드 변경 후 자동 QA를 실행하는 스킬. Stop Hook과 연동하여 에이전트 응답 완료 시점에
  git diff → browse 데몬 확인 → 서버 헬스체크 → /qa-only 실행 → 실패 시 재구현 루프(최대 5회)를 자동 수행한다.
  /auto-qa로 수동 실행도 가능하다.
  코드 변경, QA, 테스트, 자동화, 브라우저 테스트 관련 작업에서 이 스킬을 참조하라.
---

# Auto QA

코드 변경 후 자동으로 브라우저 기반 QA를 실행하는 스킬.
gstack의 `/browse`, `/qa-only` 스킬에 의존한다.

> **이 스킬은 전역 원본 템플릿이다.**
> 프로젝트에 설치할 때는 `/setup-auto-qa` 스킬을 사용하라.
> 직접 수정하지 말 것 — setup-auto-qa가 프로젝트로 복사 후 설정값을 자동 세팅한다.

---

## 프로젝트 설정

setup-auto-qa가 프로젝트 환경에 맞게 아래 값을 자동으로 세팅한다.

```yaml
# === 프로젝트 설정 (setup-auto-qa가 자동 세팅) ===
AUTO_QA_SOURCE_PATTERNS: "src/,app/,pages/,components/"  # QA 트리거 대상 경로
AUTO_QA_IGNORE_PATTERNS: "*.test.*,*.spec.*,*.md,*.json" # 무시할 파일 패턴
AUTO_QA_SERVER_CMD: "npm run dev"                         # 서버 기동 명령
AUTO_QA_SERVER_PORT: 3000                                 # 서버 포트
AUTO_QA_HEALTH_URL: "http://localhost:3000"               # 헬스체크 URL
AUTO_QA_HEALTH_TIMEOUT: 30                                # 헬스체크 대기 시간(초)
AUTO_QA_MAX_RETRIES: 5                                    # QA 실패 시 최대 재시도 횟수
AUTO_QA_BASE_URL: "http://localhost:3000"                 # /qa-only에 전달할 base URL
AUTO_QA_BROWSE_BIN: "$HOME/.claude/skills/gstack/browse/dist/browse"  # browse 바이너리 경로
```

---

## /qa 대신 /qa-only를 사용하는 이유

gstack의 `/qa`는 버그 발견 시 **자체적으로 코드를 수정하고 atomic commit**을 만든다.
auto-qa의 재시도 루프(에이전트가 수정 → Stop Hook 재트리거 → 재검증)와 충돌할 수 있다.

따라서 auto-qa는 **`/qa-only`(리포트만 생성)**를 사용하고,
코드 수정은 에이전트에게 위임하여 역할을 명확히 분리한다.

```
/qa      = 테스트 + 직접 코드 수정 + commit (자체 완결형)
/qa-only = 테스트 + 리포트만 (수정은 에이전트가 별도로)
```

---

## 실행 흐름

```
에이전트 응답 완료 (Stop Hook 트리거)
  │
  ├─ 1. git diff 확인
  │     소스코드 변경 없음 → exit 0 (종료)
  │     소스코드 변경 있음 ↓
  │
  ├─ 2. browse 데몬 상태 확인
  │     browse 바이너리 존재 여부 확인
  │     데몬 미실행 → systemMessage + exit 0 (사람에게 위임)
  │
  ├─ 3. 서버 상태 확인
  │     헬스체크 URL 응답 확인 (curl)
  │     ├─ 응답 있음 → 정상
  │     └─ 응답 없음 → 서버 기동 → 헬스체크 폴링
  │     헬스체크 실패 → systemMessage + exit 0 (사람에게 위임)
  │
  ├─ 4. /qa-only 실행 (리포트만)
  │     통과 → 결과 안내 + exit 0
  │     미통과 ↓
  │
  ├─ 5. 핸드오프 감지
  │     CAPTCHA/MFA 등으로 핸드오프 발생 → exit 0 (사람에게 위임)
  │     핸드오프 아님 → 에이전트에게 수정 요청 ↓
  │
  ├─ 6. 재시도 루프 (최대 5회)
  │     decision:block + reason으로 에이전트에게 QA 리포트 + 수정 지시 전달
  │     → 에이전트가 수정 → Stop Hook 재트리거 → /qa-only 재실행
  │
  └─ 7. 5회 초과
        마지막 1회 block으로 실패 요약 보고 지시 → 이후 침묵 (사람에게 위임)
```

---

## Stop Hook 동작 원리

- **출력 없이 exit 0**: 에이전트가 정상 종료 (멈춤)
- **`{"decision":"block","reason":"..."}` + exit 0**: 에이전트가 계속 작업 (reason이 지시로 전달됨)
- **`{"systemMessage":"..."}` + exit 0**: 사용자에게만 알림 표시 (에이전트는 멈춤)

이를 활용해 QA 리포트 → 수정 → 재검증 루프를 자동화한다.
재시도 카운터(.auto-qa-retries)는 MAX 초과 시 "보고 완료" 상태로 유지되고,
소스 변경이 정리되어 check_diff가 실패하는 시점에 리셋된다.

---

## 스크립트 설명

| 스크립트 | 역할 |
|----------|------|
| `scripts/auto_qa_trigger.sh` | Stop Hook 진입점. 재시도 관리 + browse 데몬 확인 + 전체 흐름 제어 |
| `scripts/check_diff.sh` | git diff에서 소스코드 변경만 필터링 |
| `scripts/health_check.sh` | browse 데몬 확인 + 서버 헬스체크 + 필요 시 자동 기동 |

각 스크립트의 상세 구현은 `scripts/` 디렉토리 참조.

---

## 수동 실행

```
사용자: /auto-qa
```

Stop Hook 외에 수동으로도 실행 가능하다.
수동 실행 시 재시도 카운터를 0으로 초기화한 뒤 시작한다.

---

## QA 결과 출력 형식

### 통과
```
✅ Auto QA 통과
- 변경 파일: src/components/Login.tsx, src/api/auth.ts
- QA 결과: 모든 페이지 정상, 콘솔 에러 없음
```

### 실패 (재시도 중)
```
❌ Auto QA 실패 (재시도 2/5)
- 발견된 문제: 로그인 폼 validation 누락
- 에이전트가 수정 후 재검증합니다
```

### 핸드오프 발생
```
🤚 Auto QA: 핸드오프 필요
- 원인: CAPTCHA / MFA / 인증 벽 감지
- 자동 루프를 중단합니다
- browse handoff로 문제를 해결한 뒤 /auto-qa를 수동 실행하세요
```

### 실패 (재시도 소진)
```
⚠️ Auto QA: 5회 재시도 모두 실패
- 해결되지 않은 문제 목록
- 사용자의 판단이 필요합니다
```

---

## 주의사항

- gstack의 `/browse`와 `/qa-only`가 전역 설치되어 있어야 한다
- browse 데몬이 실행 중이어야 한다
- 서버 기동 명령은 백그라운드 실행 가능해야 한다 (포그라운드 블로킹 명령 사용 금지)
- `.auto-qa-retries` 파일을 `.gitignore`에 추가하라
- 인증 필요 페이지는 `/setup-browser-cookies`로 쿠키를 먼저 임포트하라
- CAPTCHA/MFA 등 핸드오프가 필요한 상황에서는 자동 루프가 중단된다
- `/plan-eng-review`로 테스트 플랜을 먼저 생성하면 `/qa-only`의 테스트 범위가 넓어진다

---

## gstack 부분 설치 (필요한 스킬만)

전체 gstack을 설치하지 않고 필요한 스킬만 받으려면 sparse-checkout을 사용한다:

```bash
git clone --filter=blob:none --sparse https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack
git sparse-checkout set browse qa qa-only setup-browser-cookies bin lib scripts
bun install && bun run build
```

---

## 의존성

- gstack (`/browse`, `/qa-only`) — `~/.claude/skills/gstack/`
- browse 데몬 (browse 바이너리)
- git, curl
