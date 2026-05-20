Review all changes in the project and write a commit message following the rules below.

## Critical Language Rule

**ALL commit messages MUST be written in KOREAN.**

* Summary: Korean
* Category titles: Korean
* File descriptions: Korean
* Exception: File names, variable names, function names, class names stay in English

---

## Format
````
{Emoji,Commit Type}({Modified Files}): 한국어 요약

한국어 카테고리 제목
- path/filename: 한국어로 변경 내용 설명
````

---

## Commit Types

* ✨Feat - 새로운 기능 추가
* 🪄Enhance - 기존 기능 개선
* 🛠Fix - 버그 수정
* ♻️Refactor - 코드 리팩토링
* 💄Design - CSS/디자인 변경
* 💡Comment - 주석 추가/수정
* ✏️Docs - 문서 작성/수정
* 💷Chore - 빌드/배포 작업
* 🔨Env - 환경 설정 변경
* 🚚Rename - 파일/폴더 이름 변경
* 🔥Remove - 파일 삭제
* ⏪Revert - 커밋 되돌리기
* 🧪Test - 테스트 코드
* 🎉Tada - 프로젝트 초기 생성

---

## File Notation Rules

* **3 or fewer files:** List all with commas
  - Example: `services/user.ts, utils/auth.ts, middleware/auth.ts`
* **4 or more files:** Use `Many`
* **Path format:** `parent-path/filename.ext` (1 level parent only)

---

## Summary Guidelines

* Recommended within 50 characters
* Use imperative mood
* Be clear and specific

---

## Detailed Description Structure

Organize changes by category:
* Write Korean category title for each group
* Include reason for change if necessary
* File-level details: `- path/filename: 한국어로 변경 내용 설명`

---

## Commit Unit Guidelines

### Principle: One Logical Change per Commit

Each commit should represent **one complete, logical change** that:
* Has a single, clear purpose
* Can be understood independently
* Could be reverted without breaking other features

### ✅ Good Commit Units

* **One complete feature** (auth service + middleware + UI)
* **One bug fix** (specific bug with all necessary files)
* **One refactoring** (one module or concept)
* **Related changes** (changes that must work together)

### ❌ Bad Commit Units

* **Multiple unrelated changes** (Login + Payment + CSS)
* **Incomplete features** (half of authentication logic)
* **Too granular** (single variable name change)

### When to Split

Split when changes:
1. Serve different purposes
2. Could be reverted independently
3. Affect different features/modules

### When to Combine

Combine when changes:
1. Must work together
2. Would break if split
3. Are different aspects of one logical change

---

## 시크릿 스캔 (필수)

커밋 대상 파일에 API 키·토큰·패스워드 등 시크릿이 포함되면 GitHub Push Protection 등 원격이 차단한다. 더 큰 문제는 **잠깐이라도 커밋되면 git 히스토리에 박혀 회전·재작성이 강제된다**는 점이다. 커밋 제안 전에 반드시 스캔한다.

### 스캔 대상

- staged + unstaged + untracked 중 **이번 커밋에 포함될 모든 파일**
- 파일 단위가 아닌 **변경 hunk 단위**로 검사하면 더 정확 (대규모 기존 파일에서 신규 누출만 잡기)

### 스캔 패턴

다음 정규식을 변경 파일/diff에서 검색한다:

```text
# Provider 고유 prefix (강한 시그널 — 거의 100% 시크릿)
AKIA[0-9A-Z]{16}                          # AWS Access Key ID
ASIA[0-9A-Z]{16}                          # AWS 임시 자격증명
AIza[0-9A-Za-z\-_]{35}                    # Google API Key
AQ\.[A-Za-z0-9_\-]{20,}                   # Google Service Account API Key
ghp_[A-Za-z0-9]{36,}                      # GitHub Personal Access Token
ghs_[A-Za-z0-9]{36,}                      # GitHub Server-to-Server Token
github_pat_[A-Za-z0-9_]{50,}              # GitHub fine-grained PAT
xox[baprs]-[A-Za-z0-9\-]{10,}             # Slack token
sk-[A-Za-z0-9]{32,}                       # OpenAI / Anthropic 스타일
sk-ant-[A-Za-z0-9\-_]{20,}                # Anthropic API key
glpat-[A-Za-z0-9\-_]{20,}                 # GitLab Personal Access Token
-----BEGIN [A-Z ]*PRIVATE KEY-----        # 개인 키 / 인증서

# Generic 패턴 (약한 시그널 — 오탐 가능, 화이트리스트 필수)
(API_KEY|APIKEY|SECRET|TOKEN|PASSWORD|PASSWD|ACCESS_KEY|PRIVATE_KEY|CLIENT_SECRET)\s*[=:]\s*["']?[A-Za-z0-9_\-\.+/]{16,}
mongodb(\+srv)?://[^:]+:[^@]+@                # MongoDB connection string with password
postgres(ql)?://[^:]+:[^@]+@                  # Postgres connection string with password
```

### 화이트리스트 (오탐 제외)

다음은 시크릿 패턴이라도 통과시킨다:

- **예시·샘플 파일**: `*.example.*`, `*.sample.*`, `.env.example`, `__tests__/fixtures/`, `__mocks__/`
- **명백한 더미값**: `your-api-key-here`, `xxxxxx`, `EXAMPLE_TOKEN`, `<your-token>`, `change-me`, 모두 `0`/`x`로만 구성된 값
- **문서 내 패턴 설명**: `*.md` 코드 블록 안의 정규식·예시 (단, 진짜 값처럼 보이면 의심)

### 시크릿 발견 시 절차

1. **커밋 제안 즉시 중단** — 시크릿이 포함된 파일을 staging하지 않는다.
2. 사용자에게 보고 (한글):
   - 발견 위치: `path/file.ext:line`
   - 매칭 패턴: 어떤 유형의 시크릿으로 보이는지
   - 시크릿 값 일부만 마스킹하여 표시 (예: `AKIA****1234`)
3. 권장 조치 안내:
   - 해당 파일을 `.gitignore`에 추가 (이미 추적 중이면 `git rm --cached <file>`로 인덱스에서 제거)
   - 시크릿은 환경변수 / 비밀 저장소(1Password, Vault, GitHub Secrets, AWS Secrets Manager 등)로 이동
   - 노출된 키는 **즉시 폐기·재발급(rotate)** — 로컬에서만 잠시 존재했어도 회전 권장
4. **명시적 override만 허용**: 사용자가 "그럼에도 진행"을 분명히 지시한 경우에만 커밋. 단순 묵인이나 "괜찮아"는 불충분.

### 빠른 스캔 예시

```bash
# 변경된 파일에서 강한 시그널 패턴 검색
git diff --cached --name-only -z | xargs -0 grep -nE "AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|ghp_[A-Za-z0-9]{36,}|sk-ant-|-----BEGIN [A-Z ]*PRIVATE KEY-----"

# 또는 diff 자체에서 직접
git diff --cached | grep -nE "(API_KEY|TOKEN|SECRET|PASSWORD)\s*[=:]"
```

> **이 사고가 일어난 이유 (2026-05 commit `e94aa26`)**: `settings.local.json`에 `STITCH_API_KEY="AQ.Ab..."` 가 포함돼 있었고, 스캔 없이 그대로 staged → push에서 GitHub이 차단. 결국 filter-branch로 히스토리 재작성 + force push가 필요했다. 사전 스캔 한 번이면 막을 수 있었던 사고다.

---

## Nested 리포지토리 감지

프로젝트 하위에 독립된 git 리포지토리가 존재할 수 있다 (서브모듈 아님, .gitignore로 제외됨).

### 탐색 절차

커밋 시작 시 다음 명령으로 nested repo를 자동 탐색한다:

```bash
# parent 레포에서 gitignore된 디렉토리 중 .git이 있는 것을 탐색
for dir in $(git ls-files --others --ignored --exclude-standard --directory | grep '/$'); do
  [ -d "$dir.git" ] && echo "$dir"
done
```

탐색된 각 nested repo에 대해 `git -C {경로} status`로 변경사항을 확인한다.

### 분기 처리

* **parent만 변경** → parent만 커밋
* **nested repo만 변경** → 해당 repo만 커밋
* **여러 repo에 변경** → 각 repo별로 분리 커밋 제안
* **모두 변경 없음** → "커밋할 변경사항이 없습니다"

### nested repo git 명령어

모든 git 명령에 `-C {경로}` 접두사를 붙인다:

```bash
git -C {경로} status
git -C {경로} add <files>
git -C {경로} commit -m "..."
git -C {경로} push    # ⚠️ 각 repo의 기본 브랜치가 다를 수 있음 — 확인 후 push
```

> **주의:** nested repo마다 리모트·브랜치가 다를 수 있다. push 전 `git -C {경로} branch --show-current`로 브랜치명을 확인할 것.

---

## Commit Process

1. **감지** — parent `git status` + nested repo 탐색으로 변경된 리포 전체 파악
2. **시크릿 스캔** — 변경 파일/diff에서 API 키·토큰·패스워드 등 시크릿 패턴 검사. 발견 시 즉시 중단하고 보고
3. **리뷰** — 변경된 리포별 변경사항 분석, 각각 커밋 메시지 초안 작성
4. **제안** — 리포별 커밋 메시지 제시 (복수 리포 변경 시 아래 형식으로 구분)
5. **확인** — 사용자 승인 대기
6. **실행** — 승인 후 각 리포에 커밋

복수 리포 변경 시 제안 형식:
````
### [parent] {리모트명} ({브랜치})
{커밋 메시지}

### [{폴더명}] {리모트명} ({브랜치})
{커밋 메시지}
````

---

## Correct Examples ✅

### Feature Addition
````
✨Feat(services/user.ts, utils/auth.ts): 사용자 인증 기능 추가

인증 시스템 구현 (보안 강화를 위해 JWT 도입)
- services/user.ts: User 모델에 password 필드 추가
- utils/auth.ts: JWT 기반 로그인 로직 구현
- middleware/auth.ts: 인증 미들웨어 추가
````

### Bug Fix
````
🛠Fix(components/Button.tsx): 버튼 클릭 핸들러 버그 수정

버그 수정
- components/Button.tsx: onClick 핸들러 호출 전 null 체크 추가
````

### Design Change
````
💄Design(styles/global.css, components/Header.tsx): 주요 색상 테마 업데이트

UI 디자인 개선
- styles/global.css: 주요 색상을 파란색에서 틸색으로 변경
- components/Header.tsx: 헤더 배경에 새 색상 적용
````

### Many Files Changed
````
♻️Refactor(Many): 인증 모듈 구조 개선

코드 재구성
- 인증 로직을 전용 서비스 레이어로 이동
- JWT 유틸리티를 메인 auth 서비스에서 분리
- 8개 파일의 모든 import 문 업데이트
- auth 인터페이스 타입 정의 추가
````

### Feature Enhancement
````
🪄Enhance(components/SearchBar.tsx, hooks/useSearch.ts): 검색 성능 최적화

검색 기능 개선
- components/SearchBar.tsx: 디바운스 적용으로 불필요한 API 호출 감소
- hooks/useSearch.ts: 검색 결과 캐싱 로직 추가
````

### Documentation
````
✏️Docs(README.md, docs/api-spec.md): API 문서 업데이트

문서 개선
- README.md: 설치 가이드 최신화
- docs/api-spec.md: 인증 엔드포인트 예시 추가
````

### Environment Setup
````
🔨Env(.env.example, docker-compose.yml): 개발 환경 설정 추가

환경 구성 업데이트
- .env.example: 데이터베이스 연결 변수 추가
- docker-compose.yml: Redis 컨테이너 설정 추가
````

### Test Code
````
🧪Test(tests/auth.test.ts, tests/user.test.ts): 인증 관련 테스트 추가

테스트 커버리지 확대
- tests/auth.test.ts: JWT 토큰 검증 테스트 추가
- tests/user.test.ts: 사용자 생성 및 로그인 통합 테스트 추가
````

---

## Wrong Examples ❌

### ❌ English commit message
````
✨Feat(services/user.ts): Add user authentication

Authentication Implementation
- services/user.ts: Add password field to User model
````

**Problem:** Summary and descriptions in English

---

### ❌ Korean variable names
````
✨Feat(services/사용자.ts): 사용자 인증 기능 추가

인증 시스템 구현
- services/사용자.ts: 사용자모델에 비밀번호 필드 추가
````

**Problem:** File names and model names in Korean

---

### ❌ Missing Emoji
````
Feat(services/user.ts): 사용자 인증 기능 추가

인증 시스템 구현
- services/user.ts: User 모델에 password 필드 추가
````

**Problem:** Emoji missing from commit type

---

## Checklist

Before proposing commit, verify:

- [ ] Summary in Korean?
- [ ] Category titles in Korean?
- [ ] File descriptions in Korean?
- [ ] File/variable/function names in English?
- [ ] Emoji + Commit Type included?
- [ ] Correct file notation used?
- [ ] Nested 리포: 하위 독립 리포지토리 변경사항도 점검했는가?
- [ ] 시크릿 스캔 완료? (API 키·토큰·패스워드·개인 키 미포함 확인, 화이트리스트 외 모든 매치 사용자에게 보고)