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
2. **리뷰** — 변경된 리포별 변경사항 분석, 각각 커밋 메시지 초안 작성
3. **제안** — 리포별 커밋 메시지 제시 (복수 리포 변경 시 아래 형식으로 구분)
4. **확인** — 사용자 승인 대기
5. **실행** — 승인 후 각 리포에 커밋

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