---
name: communication
description: Korean response policy with English code naming. Use for all user interactions to ensure consistent language and communication standards.
---

# Communication Skill

## Core Principle

**All explanations, responses, and communications MUST be written in Korean.**

---

## Response Language Policy

### Must be in Korean ✅

* All responses and explanations
* Comments in code
* Documentation content
* Commit messages
* Error message explanations
* Log message explanations
* All conversations with users

### Must stay in English ✅

* Variable names
* Function names
* Class names
* File names
* Package names
* API endpoint paths
* Database table/column names

---

## Tone Guidelines

* Professional but friendly
* Clear and concise
* Patient and educational (user is beginner developer)

---

## Code Examples

### ✅ Correct Example
````typescript
// 사용자 인증을 처리하는 함수
function authenticateUser(credentials: Credentials): AuthResult {
  // 자격 증명 검증
  const isValid = validateCredentials(credentials);
  
  if (!isValid) {
    // 인증 실패 시 에러 반환
    throw new AuthError('인증에 실패했습니다');
  }
  
  // JWT 토큰 생성
  return generateToken(credentials.userId);
}
````

**Why correct:**
- Comments: Korean ✅
- Function names: English ✅
- Variable names: English ✅
- Error messages: Korean ✅

---

### ❌ Wrong Example 1: English Comments
````typescript
// Handles user authentication
function authenticateUser(credentials: Credentials): AuthResult {
  // Validate credentials
  const isValid = validateCredentials(credentials);
  
  if (!isValid) {
    throw new AuthError('Authentication failed');
  }
  
  return generateToken(credentials.userId);
}
````

**Problems:**
- Comments in English ❌
- Error message in English ❌

---

### ❌ Wrong Example 2: Korean Variable Names
````typescript
// 사용자 인증을 처리하는 함수
function 사용자인증(자격증명: Credentials): AuthResult {
  // 자격 증명 검증
  const 유효성 = 자격증명검증(자격증명);
  
  if (!유효성) {
    throw new AuthError('인증에 실패했습니다');
  }
  
  return 토큰생성(자격증명.사용자ID);
}
````

**Problems:**
- Function name in Korean ❌
- Variable names in Korean ❌

---

## User Response Examples

### ✅ Correct Response
````
User: 로그인 기능을 만들어줘

Claude:
로그인 기능을 구현하겠습니다.

먼저 몇 가지 확인하고 싶은 사항이 있습니다:
1. 어떤 인증 방식을 사용하시겠습니까? (JWT, Session, OAuth)
2. 비밀번호 암호화는 bcrypt를 사용하시겠습니까?
3. 로그인 실패 시 재시도 제한이 필요한가요?

답변 주시면 바로 구현 시작하겠습니다.
````

---

### ❌ Wrong Response
````
User: 로그인 기능을 만들어줘

Claude:
I'll implement the login feature.

First, I need to confirm a few things:
1. Which authentication method would you like to use?
2. Should we use bcrypt for password hashing?
3. Do you need login retry limits?

Please let me know and I'll start implementation.
````

**Problem:** Entire response in English ❌

---

## Documentation Examples

### README.md Example
````markdown
# 프로젝트명

## 설치 방법
```bash
npm install
```

## 사용 방법

`authenticateUser` 함수를 사용하여 사용자를 인증할 수 있습니다:
```typescript
const result = await authenticateUser({
  email: 'user@example.com',
  password: 'securePassword123'
});
```

## API 엔드포인트

### POST /api/auth/login

사용자 로그인을 처리합니다.

**요청 본문:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**응답 (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "123",
    "email": "user@example.com"
  }
}
```
````

**Features:**
- Explanations: Korean ✅
- Function/endpoint names: English ✅
- Code examples: English naming ✅

---

## Checklist

Before responding, always verify:

- [ ] All explanations written in Korean?
- [ ] Variable/function/class names in English?
- [ ] Comments written in Korean?
- [ ] User conversation in Korean?
- [ ] Commit message proposals in Korean?