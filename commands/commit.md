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

## Commit Process

1. **Review** all changes in the project
2. **Draft** commit message following the Format
3. **Self-validate** against Checklist before presenting to user
   - If ANY item fails: revise the message and re-validate
   - Do NOT present to user until ALL items pass
4. **Present** validated commit message to user
5. **Wait** for user confirmation
6. **Execute** commit after approval

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
- [ ] Commit unit properly divided?
- [ ] No undefined content added? (e.g. "Generated by Claude")