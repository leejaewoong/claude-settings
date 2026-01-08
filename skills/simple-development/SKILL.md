---
name: simple-development
description: Quick workflow for simple tasks like bug fixes, style changes, or documentation updates. Use when task is straightforward and doesn't require feature-dev plugin.
---

# Simple Development Skill

## Overview

**Note:** This skill uses the `communication` skill for consistent Korean responses and `/commit` command for standardized commit format.

## When to Use This Skill

**✅ Use for:**
- Single-line bug fixes
- Simple style changes
- Typo corrections
- Documentation updates
- Simple refactoring
- Well-defined, simple tasks
- Urgent hotfixes

**❌ Don't use for (use feature-dev plugin instead):**
- Features touching multiple files
- Features requiring architectural decisions
- Complex integrations
- Unclear requirements

---

## Workflow

### Step 1: Understand the Task
- Clarify requirements with user if needed
- Ask specific questions in Korean
- Confirm understanding before proceeding

### Step 2: Implement Changes
- Follow codebase conventions
- Use established patterns
- Keep changes focused and minimal

**Technology Stack:**
- Backend: Python with FastAPI
- Frontend: React or Next.js with TypeScript

### Step 3: Verify Changes
- Test functionality
- Check for obvious issues
- Ensure no regressions

### Step 4: Propose Commit
- Use `/commit` command for standardized format
- Present in Korean
- Wait for user approval

### Step 5: Execute Commit
- Commit after approval
- Confirm completion

---

## Example Workflows

### Bug Fix Example
```
User: 로그인 버튼이 작동하지 않아

Process:
1. 코드 분석
2. 문제 파악: onClick 핸들러에 null 체크 누락
3. 수정 구현
4. 커밋 제안:

🛠Fix(components/LoginButton.tsx): 버튼 클릭 핸들러 버그 수정

버그 수정
- components/LoginButton.tsx: onClick 핸들러 호출 전 null 체크 추가

5. 승인 대기
6. 커밋 실행
```

### Style Change Example
```
User: 헤더 색상을 파란색에서 틸색으로 변경해줘

Process:
1. 스타일 파일 확인
2. 색상 값 업데이트
3. 커밋 제안:

💄Design(components/Header.tsx, styles/global.css): 헤더 색상 테마 업데이트

UI 스타일 개선
- components/Header.tsx: 헤더 배경에 틸색 적용
- styles/global.css: 주요 색상 변수를 틸색으로 변경

4. 승인 대기
5. 커밋 실행
```

### Documentation Update Example
```
User: README에 설치 방법 추가해줘

Process:
1. README.md 확인
2. 설치 섹션 추가
3. 커밋 제안:

✏️Docs(README.md): 설치 가이드 추가

문서 개선
- README.md: npm install 명령어와 환경 설정 가이드 추가

4. 승인 대기
5. 커밋 실행
```

### Refactoring Example
```
User: 중복된 validation 로직을 utils로 분리해줘

Process:
1. 중복 코드 식별
2. 유틸리티 함수로 추출
3. 기존 코드를 유틸리티 함수 호출로 변경
4. 커밋 제안:

♻️Refactor(utils/validation.ts, components/LoginForm.tsx, components/SignupForm.tsx): Validation 로직 공통화

코드 개선
- utils/validation.ts: 이메일 및 비밀번호 검증 유틸리티 함수 추가
- components/LoginForm.tsx: 공통 validation 함수 사용
- components/SignupForm.tsx: 공통 validation 함수 사용

5. 승인 대기
6. 커밋 실행
```

### Comment Addition Example
```
User: authenticateUser 함수에 주석 추가해줘

Process:
1. 함수 로직 분석
2. 명확한 한국어 주석 추가
3. 커밋 제안:

💡Comment(services/auth.ts): authenticateUser 함수 주석 추가

코드 가독성 개선
- services/auth.ts: 인증 프로세스 각 단계에 대한 설명 주석 추가

4. 승인 대기
5. 커밋 실행
```

### Environment Configuration Example
```
User: .env에 새 API 키 변수 추가해줘

Process:
1. .env.example 확인
2. 새 환경 변수 추가
3. 커밋 제안:

🔨Env(.env.example): 외부 API 키 환경 변수 추가

환경 설정 업데이트
- .env.example: EXTERNAL_API_KEY 변수 추가 및 설명 주석 포함

4. 승인 대기
5. 커밋 실행
```

---

## Guidelines

* **Always use communication skill** (Korean responses)
* **Always use `/commit` command** for commits
* **Keep changes focused** and simple
* **If task becomes complex**, suggest using feature-dev plugin:
```
  이 작업은 여러 파일 수정과 아키텍처 결정이 필요해 보입니다.
  Feature Development Plugin(/feature-dev)을 사용하는 게 더 적합할 것 같습니다.
  
  /feature-dev [task description]
```

---

## Complexity Assessment

Before starting implementation, assess task complexity:

**Simple (use this skill):**
- Changes to 1-3 files
- Clear requirements
- No architectural decisions needed
- Estimated time: < 30 minutes

**Complex (use feature-dev plugin):**
- Changes to 4+ files
- Requires design decisions
- Unclear requirements need clarification
- Integration with multiple systems
- Estimated time: > 30 minutes

**When in doubt:**
Ask user: 
```
이 작업이 복잡해 보입니다. 다음 중 어떻게 진행할까요?

1. 간단히 진행 (현재 방식)
2. Feature Development Plugin 사용 (체계적 접근)

어떤 방식을 선호하시나요?
```
```

---

## 주요 특징

### 1. **명확한 워크플로우**
5단계로 구성된 간단하고 직관적인 프로세스

### 2. **다양한 예시**
- 버그 수정
- 스타일 변경
- 문서 업데이트
- 리팩토링
- 주석 추가
- 환경 설정

각 예시마다 실제 커밋 메시지 포맷 제시

### 3. **복잡도 평가 가이드**
작업이 simple-development에 적합한지 판단하는 기준:
- 파일 개수
- 요구사항 명확성
- 아키텍처 결정 필요 여부
- 예상 소요 시간

### 4. **Feature-dev로의 전환 안내**
작업이 복잡해질 경우 명확한 안내 메시지:
```
이 작업은 여러 파일 수정과 아키텍처 결정이 필요해 보입니다.
Feature Development Plugin(/feature-dev)을 사용하는 게 더 적합할 것 같습니다.

/feature-dev [task description]