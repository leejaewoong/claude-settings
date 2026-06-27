---
name: setup-project
description: |
  새 프로젝트(또는 기존 프로젝트)의 초기 환경을 정비하는 스킬.
  .gitignore 정비, 워크트리용 .worktreeinclude 생성, auto-qa 설치(setup-auto-qa 위임)를
  순서대로 안내한다.
  '프로젝트 생성', '프로젝트 초기화', '프로젝트 셋업', '프로젝트 세팅', '초기 설정',
  'setup project', 'init project', '워크트리인클루드 만들어', '깃이그노어 정비' 등의
  요청에서 사용하라.
---

# Setup Project

프로젝트의 기본 개발 환경을 한 번에 정비하는 오케스트레이터 스킬.
세 가지 단계를 순서대로 수행하며, 각 단계는 독립적으로 건너뛸 수 있다.

1. `.gitignore` 정비
2. `.worktreeinclude` 생성 (Claude Code 워크트리용)
3. auto-qa 설치 (`setup-auto-qa` 스킬에 위임)

> **전제**: 프로젝트가 git으로 관리되고 있을 것. 아니면 먼저 `git init`을 제안한다.

---

## 핵심 원리: .gitignore와 .worktreeinclude는 짝이다

Claude Code가 워크트리를 만들 때(`claude -w`, `EnterWorktree`), 워크트리는 **새 체크아웃**이라
`.env` 같은 **gitignore된 로컬 파일이 없다**. `.worktreeinclude`에 적힌 파일을 자동 복사하는데,
**규칙상 gitignore된 파일만 복사된다** (추적 중인 파일은 중복되지 않음).

따라서 `.env`류 파일은 **반드시 두 곳에 모두** 있어야 한다:
- `.gitignore` → 커밋에서 제외
- `.worktreeinclude` → 워크트리로 복사

한쪽만 있으면 동작하지 않으므로, 이 스킬은 두 파일을 함께 다룬다.

---

## 1단계: .gitignore 정비

프로젝트 루트의 `.gitignore`를 확인하고, 없으면 생성한다. 이미 있는 항목은 건너뛴다.

**기술 스택 감지 후 해당 항목만 추가** (package.json / pyproject.toml / Cargo.toml / go.mod 등):

```gitignore
# Dependencies / build
node_modules/
dist/
build/
.next/
__pycache__/
*.pyc
target/

# Env & secrets (로컬 전용)
.env
.env.local
.env.*.local
!.env.example

# Claude Code 워크트리 (메인 체크아웃 오염 방지)
.claude/worktrees/

# OS / editor
.DS_Store
```

> `.env.example`은 추적 대상으로 남기기 위해 `!.env.example` 예외를 넣는다.
> 스택과 무관한 항목은 넣지 않는다(KISS).

---

## 2단계: .worktreeinclude 생성

프로젝트 루트에 `.worktreeinclude`를 생성한다 (`.gitignore` 문법).
**1단계에서 gitignore에 넣은 로컬 설정 파일 중**, 워크트리에서도 필요한 것만 나열한다.

```text
# .worktreeinclude — 워크트리 생성 시 복사할 gitignore된 파일
.env
.env.local
```

프로젝트에 다른 로컬 설정 파일이 있으면 사용자에게 확인 후 추가한다
(예: `config/secrets.json`, `.env.test`, 인증서 파일 등).

> 여기 적은 파일이 `.gitignore`에 없으면 복사되지 않는다 — 1단계와 교차 확인할 것.

---

## 3단계: auto-qa 설치 (setup-auto-qa 위임)

QA 자동화가 필요한지 사용자에게 확인한다. 필요하면 **직접 구현하지 말고**
`setup-auto-qa` 스킬을 호출한다 — 해당 스킬이 기술 스택 감지, 서버 명령/포트 설정,
Stop Hook 등록, `.auto-qa-*` gitignore 추가까지 모두 처리한다.

```
QA 자동화(auto-qa)도 설치할까요?
→ 예: setup-auto-qa 스킬 실행
→ 아니오: 이 단계 건너뜀
```

> auto-qa 관련 `.gitignore` 항목(`.auto-qa-retries`, `.auto-qa-handoff`)은
> `setup-auto-qa`가 추가하므로 1단계에서 중복으로 넣지 않는다.

---

## 완료 요약

설치 후 아래 형식으로 결과를 보고한다.

```
✅ 프로젝트 셋업 완료

.gitignore       → 정비됨 (N개 항목 추가)
.worktreeinclude → 생성됨 (.env, .env.local)
auto-qa          → 설치됨 / 건너뜀

확인:
  - 워크트리 생성 시 .env가 자동 복사됩니다 (claude -w <name>)
  - .claude/worktrees/ 는 커밋에서 제외됩니다
```

---

## 의존성

- `setup-auto-qa` 스킬 (3단계, 선택)
- communication 스킬 (한국어 응답)
