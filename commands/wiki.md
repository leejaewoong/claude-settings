# /wiki — Confluence 위키 작업

Confluence 위키 페이지를 검색, 조회, 생성, 수정하는 커맨드.

---

## 인증 설정

```yaml
인증_파일: ".env"
필수_변수:
  CONFLUENCE_API_TOKEN: "API 토큰 (https://id.atlassian.com/manage-profile/security/api-tokens)"
  CONFLUENCE_CLOUD_ID: "Atlassian Cloud ID"
  CONFLUENCE_BASE_URL: "Atlassian 인스턴스 URL (예: https://your-domain.atlassian.net/)"
  CONFLUENCE_EMAIL: "Atlassian 계정 이메일"
인증_방식: "Basic Auth (email:token → base64)"
```

---

## 사전 확인

커맨드 실행 시 아래를 먼저 수행한다.

```yaml
Step_1_env_로드:
  방법: "프로젝트 루트의 .env 파일 읽기"
  검증:
    - CONFLUENCE_BASE_URL이 비어있거나 placeholder인지 확인
    - CONFLUENCE_API_TOKEN이 비어있거나 placeholder인지 확인
  실패시: |
    .env 파일이 설정되지 않았습니다.
    1. .env.example을 .env로 복사하세요
    2. 실제 Confluence 인증 정보를 입력하세요
    3. API 토큰: https://id.atlassian.com/manage-profile/security/api-tokens

Step_2_연결_테스트:
  호출: "curl -s -o /dev/null -w '%{http_code}' -u {email}:{token} {base_url}wiki/rest/api/space?limit=1"
  성공: "HTTP 200 → 연결 확인 완료"
  실패: "인증 정보 또는 URL 재확인 안내"
```

---

## API 호출 공통 패턴

```bash
# .env에서 변수 로드 (프로젝트 루트: C:\Users\jaewoong\.claude\.env)
source .env

# API 호출 공통 — curl -u 방식 사용 (base64 헤더보다 안정적)
curl -s \
  -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  "${CONFLUENCE_BASE_URL}wiki/rest/api/{endpoint}"
```

> **검증 완료**: `curl -u` + `wiki/rest/api/` (v1) 경로가 KRAFTON Atlassian 인스턴스에서 정상 동작 확인됨. v2 API(`wiki/api/v2/`)는 이 인스턴스에서 404를 반환하므로 v1 REST API를 사용한다.

---

## 실행 절차

`/wiki`가 호출되면 사용자에게 작업을 묻는다.

### Q1 — 작업 선택

```
어떤 작업을 하시겠습니까?

1. 검색 — 키워드로 페이지 검색
2. 조회 — 특정 페이지 내용 보기
3. 생성 — 새 페이지 작성
4. 수정 — 기존 페이지 편집
5. 스페이스 목록 — 접근 가능한 스페이스 확인
```

---

### 1. 검색

```yaml
입력: "검색할 키워드를 입력하세요"
API: "GET /wiki/rest/api/content/search?cql=title~\"{keyword}\" OR text~\"{keyword}\"&limit=10"
출력_형식: |
  검색 결과 ({N}건):

  | # | 제목 | 스페이스 | 최종 수정 | ID |
  |---|------|---------|----------|-----|
  | 1 | {title} | {space} | {date} | {id} |

  → 번호를 선택하면 해당 페이지를 조회합니다.
```

### 2. 조회

```yaml
입력: "페이지 ID 또는 검색 결과 번호"
API: "GET /wiki/rest/api/content/{id}?expand=body.storage,version,space,ancestors"
처리:
  - Confluence storage format (XHTML)을 읽기 좋은 형태로 변환
  - 제목, 본문, 작성자, 최종 수정일 표시
  - 하위 페이지가 있으면 목록으로 표시
출력_형식: |
  ## {페이지 제목}

  - 스페이스: {space_name}
  - 작성자: {author}
  - 최종 수정: {last_modified}
  - URL: {base_url}/wiki/spaces/{space_key}/pages/{id}

  ---
  {본문 내용 (마크다운 변환)}
```

### 3. 생성

```yaml
순서:
  Q3_1: "어떤 스페이스에 생성하시겠습니까? (스페이스 키 또는 이름)"
  Q3_2: "상위 페이지가 있나요? (페이지 ID 또는 제목, 없으면 엔터)"
  Q3_3: "페이지 제목을 입력하세요"
  Q3_4: "페이지 내용을 입력하세요 (마크다운으로 작성하면 자동 변환)"

API: "POST /wiki/rest/api/content"
Body: |
  {
    "type": "page",
    "title": "{title}",
    "space": { "key": "{space_key}" },
    "ancestors": [{ "id": "{parent_id}" }],
    "body": {
      "storage": {
        "value": "{content_as_storage_format}",
        "representation": "storage"
      }
    }
  }

마크다운_변환:
  - "# heading" → "<h1>heading</h1>"
  - "**bold**" → "<strong>bold</strong>"
  - "- item" → "<ul><li>item</li></ul>"
  - "`code`" → "<code>code</code>"
  - "```block```" → "<ac:structured-macro ac:name=\"code\"><ac:plain-text-body><![CDATA[block]]></ac:plain-text-body></ac:structured-macro>"
  - "| table |" → "<table><tr><td>table</td></tr></table>"

성공시: "페이지 URL과 ID 출력"
```

### 4. 수정

```yaml
순서:
  Q4_1: "수정할 페이지 ID 또는 제목 (검색)"
  Q4_2: "현재 내용을 표시하고 수정 방식 선택"
    선택지:
      - "전체 교체 — 새 내용으로 덮어쓰기"
      - "부분 수정 — 변경할 부분 지정"
      - "추가 — 기존 내용 뒤에 추가"

API_조회: "GET /wiki/rest/api/content/{id}?expand=body.storage,version,space"
API_수정: "PUT /wiki/rest/api/content/{id}"
Body: |
  {
    "id": "{page_id}",
    "type": "page",
    "title": "{title}",
    "body": {
      "storage": {
        "value": "{updated_content}",
        "representation": "storage"
      }
    },
    "version": {
      "number": {current_version + 1},
      "message": "{변경 사유}"
    }
  }

주의: "version.number는 현재 버전 + 1이어야 함 (충돌 방지)"
```

### 5. 스페이스 목록

```yaml
API: "GET /wiki/rest/api/space?limit=25"
출력_형식: |
  접근 가능한 스페이스:

  | # | 이름 | 키 | 타입 | ID |
  |---|------|-----|------|-----|
  | 1 | {name} | {key} | {type} | {id} |
```

---

## 에러 처리

```yaml
401_Unauthorized:
  메시지: "인증에 실패했습니다. .env의 이메일/토큰을 확인해주세요."
  안내: "https://id.atlassian.com/manage-profile/security/api-tokens"

403_Forbidden:
  메시지: "해당 리소스에 접근 권한이 없습니다."
  안내: "Confluence 관리자에게 스페이스 권한을 요청하세요."

404_Not_Found:
  메시지: "페이지를 찾을 수 없습니다. ID를 확인해주세요."

429_Rate_Limited:
  메시지: "API 호출 한도에 도달했습니다. 잠시 후 재시도합니다."
  대응: "5초 대기 후 1회 재시도"

Connection_Error:
  메시지: "Confluence에 연결할 수 없습니다. URL과 네트워크를 확인해주세요."
```

---

## 인자 지원

커맨드 호출 시 인자를 전달하면 Q1을 건너뛸 수 있다.

```yaml
사용법:
  "/wiki 검색 {키워드}": "바로 검색 실행"
  "/wiki 조회 {페이지ID}": "바로 페이지 조회"
  "/wiki 스페이스": "바로 스페이스 목록"
  "/wiki": "대화형 모드 (Q1부터 시작)"
```

---

## 보안 주의사항

```yaml
필수:
  - ".env 파일은 절대 git에 커밋하지 않는다 (.gitignore에 등록됨)"
  - "API 토큰을 채팅, 로그, 출력에 노출하지 않는다"
  - "curl 명령 실행 시 토큰이 포함된 전체 명령을 출력하지 않는다"
  - "에러 발생 시에도 인증 헤더 값을 마스킹한다"
```
