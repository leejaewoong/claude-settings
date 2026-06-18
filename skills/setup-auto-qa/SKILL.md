---
name: setup-auto-qa
description: |
  프로젝트에 auto-qa 스킬을 설치하고 설정하는 스킬. 프로젝트의 기술 스택을 감지하여
  서버 기동 명령, 포트, 헬스체크 URL, 소스코드 경로 등을 자동 세팅하고,
  Stop Hook을 .claude/settings.json에 등록한다.
  'auto-qa 설치', 'auto-qa 설정', 'QA 자동화 설정', 'setup auto qa' 등의 요청에서 사용하라.
---

# Setup Auto QA

전역의 auto-qa 원본 템플릿을 프로젝트에 복사하고, 프로젝트 환경에 맞게 설정하는 스킬.

---

## 전제 조건

- gstack 전역 설치: `~/.claude/skills/gstack/` (최소 `browse`, `qa-only`, `setup-browser-cookies`)
- browse 바이너리 빌드 완료: `~/.claude/skills/gstack/browse/dist/browse` 존재
- auto-qa 원본 전역 설치: `~/.claude/skills/auto-qa/`
- 프로젝트가 git으로 관리되고 있을 것

---

## 실행 흐름

### 1단계: 프로젝트 감지

프로젝트 루트에서 아래 파일들을 확인하여 기술 스택을 자동 감지한다.

```
감지 대상:
├── package.json        → Node.js (scripts.dev에서 명령 추출)
├── next.config.*       → Next.js
├── vite.config.*       → Vite
├── nuxt.config.*       → Nuxt
├── angular.json        → Angular
├── docker-compose.yml  → Docker Compose
├── pyproject.toml      → Python (FastAPI, Django 등)
├── manage.py           → Django
├── Cargo.toml          → Rust
└── go.mod              → Go
```

#### 프레임워크별 기본값

| 프레임워크 | SERVER_CMD | PORT | SOURCE_PATTERNS |
|-----------|------------|------|-----------------|
| Next.js | `npm run dev` | 3000 | `src/,app/,pages/,components/,lib/` |
| Vite | `npm run dev` | 5173 | `src/,components/,lib/` |
| Nuxt | `npm run dev` | 3000 | `app/,components/,pages/,composables/,server/` |
| Angular | `npm start` | 4200 | `src/app/,src/assets/` |
| Django | `python manage.py runserver` | 8000 | `*/views.py,*/models.py,*/urls.py,*/templates/` |
| FastAPI | `uvicorn main:app --reload` | 8000 | `app/,src/,routers/,models/` |
| Docker Compose | `docker-compose up -d` | (ports에서 추출) | `src/,app/` |
| 기본값 | `npm run dev` | 3000 | `src/,app/` |

공통 IGNORE_PATTERNS: `*.test.*,*.spec.*,*.md,*.json`

### 2단계: 사용자 확인

감지 결과를 보여주고 확인을 받는다.

```
📋 Auto QA 설정 감지 결과

프레임워크: Next.js (감지됨: next.config.ts)
서버 명령:  npm run dev
포트:       3000
헬스체크:   http://localhost:3000
소스 경로:  src/, app/, pages/, components/, lib/
무시 패턴:  *.test.*, *.spec.*, *.md, *.json
최대 재시도: 5회

이 설정으로 진행할까요? 수정이 필요하면 말씀해 주세요.
```

수정 요청 시 해당 값만 변경한다.

### 3단계: 파일 설치

확인 완료 후 아래를 순서대로 실행한다.

**3-1. auto-qa 스킬 복사**
```bash
mkdir -p .claude/skills
cp -r ~/.claude/skills/auto-qa .claude/skills/auto-qa
chmod +x .claude/skills/auto-qa/scripts/*.sh
```

**3-2. SKILL.md 설정값 업데이트**

복사된 `.claude/skills/auto-qa/SKILL.md`의 프로젝트 설정 섹션을 감지된 값으로 교체한다.

**3-3. Stop Hook 등록**

`.claude/settings.json`에 Stop Hook을 추가한다.
파일이 없으면 새로 생성, 이미 있으면 기존 설정을 보존하며 hooks만 병합한다.

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/skills/auto-qa/scripts/auto_qa_trigger.sh"
          }
        ]
      }
    ]
  }
}
```

> 기존 Stop Hook이 있으면 배열에 추가. 덮어쓰지 않는다.

**3-4. .gitignore 업데이트**

`.gitignore`에 `.auto-qa-retries`와 `.auto-qa-handoff`를 추가한다 (이미 있으면 스킵).

```
# Auto QA
.auto-qa-retries
.auto-qa-handoff
```

### 4단계: 검증

설치 완료 후 아래를 확인한다:

1. `.claude/skills/auto-qa/SKILL.md` 존재
2. `.claude/skills/auto-qa/scripts/*.sh` 실행 권한
3. `.claude/settings.json`에 Stop Hook 등록
4. `.gitignore`에 `.auto-qa-retries` 포함

```
✅ Auto QA 설치 완료

설치된 파일:
  .claude/skills/auto-qa/SKILL.md
  .claude/skills/auto-qa/scripts/auto_qa_trigger.sh
  .claude/skills/auto-qa/scripts/check_diff.sh
  .claude/skills/auto-qa/scripts/health_check.sh

Hook 등록:
  .claude/settings.json → Stop Hook 등록됨

설정:
  서버: {SERVER_CMD} (포트 {PORT})
  QA 대상: {SOURCE_PATTERNS}
  최대 재시도: 5회

사용법:
  - 자동: 코드 변경 후 Claude 응답 완료 시 자동 실행
  - 수동: /auto-qa 입력
```

---

## 에러 처리

| 상황 | 대응 |
|------|------|
| gstack 미설치 | 설치 가이드 안내 후 중단 |
| auto-qa 원본 없음 | 전역 설치 가이드 안내 |
| .claude/ 디렉토리 없음 | `mkdir -p .claude/skills` 후 진행 |
| settings.json 파싱 실패 | 백업 생성 후 새로 작성 |
| 프레임워크 감지 실패 | 수동 설정 모드로 전환 |

---

## 수동 설정 모드

프레임워크를 감지할 수 없는 경우:

```
프로젝트의 기술 스택을 감지할 수 없습니다. 직접 설정해 주세요.

1. 서버 기동 명령은 무엇인가요? (예: npm run dev, docker-compose up -d)
2. 서버 포트는 몇 번인가요? (예: 3000)
3. 소스코드가 위치한 경로는 어디인가요? (예: src/, app/)
```

---

## 의존성

- auto-qa 원본: `~/.claude/skills/auto-qa/`
- gstack (`/browse`, `/qa-only`): `~/.claude/skills/gstack/`
- communication 스킬 (한국어 응답)
