# Claude Code settings.json 권한 참조

> `settings.json`의 `permissions.allow` 항목별 설명입니다.
>
> **Bash 명령어 자동 승인은 이 파일이 아니라 `bash-safelist.txt`가 담당합니다.**
> PreToolUse 훅(`hooks/bash_safelist_check.py`)이 명령어를 원자 단위로 분해해
> safelist와 대조하고, 전부 매칭되면 자동 승인합니다. 빠진 명령은 `/allow-cmd`로
> 추가합니다. (settings.json의 `Bash(...:*)` 규칙은 2026-07 safelist로 일원화하며 제거)

---

## 📁 파일 시스템 / 내장 도구

| 권한 | 설명 |
|---|---|
| `Edit` | 기존 파일의 내용을 부분 편집 (diff 방식) |
| `Write` | 파일 전체 내용을 작성/덮어쓰기 (새 파일 생성 포함) |
| `Read` | 파일 내용 읽기 |
| `Glob` | 글로브 패턴으로 파일 검색 (예: `**/*.py`) |
| `Grep` | 파일 내용에서 정규표현식 패턴 검색 (내장 도구) |
| `NotebookEdit` | Jupyter 노트북(.ipynb) 셀 편집 |

## 🌐 웹

| 권한 | 설명 |
|---|---|
| `WebFetch` | 지정한 URL에서 웹 콘텐츠를 가져와 분석 |

## 🎨 Figma MCP (`mcp__figma__*`)

| 권한 | 설명 |
|---|---|
| `mcp__figma__get_screenshot` | Figma 노드 스크린샷 캡처 |
| `mcp__figma__get_metadata` | Figma 노드 메타데이터 (XML 구조) 조회 |
| `mcp__figma__get_design_context` | Figma 노드 디자인 컨텍스트 (코드 + 스크린샷) 추출 |
| `mcp__figma__get_variable_defs` | Figma 변수(토큰) 정의 조회 |
| `mcp__figma__get_code_connect_map` | Code Connect 매핑 조회 |
| `mcp__figma__get_code_connect_suggestions` | Code Connect AI 매핑 제안 |
| `mcp__figma__create_design_system_rules` | 디자인 시스템 규칙 프롬프트 생성 |
| `mcp__figma__generate_figma_design` | HTML → Figma 캡처 (newFile / existingFile / clipboard) |
| `mcp__figma__generate_diagram` | FigJam 다이어그램 생성 (Mermaid.js) |
| `mcp__figma__whoami` | Figma MCP 인증 사용자 정보 확인 |
| `mcp__figma__get_figjam` | FigJam 노드 코드 생성 |
| `mcp__figma__add_code_connect_map` | Code Connect 매핑 추가 |
| `mcp__figma__send_code_connect_mappings` | Code Connect 매핑 일괄 저장 |

## 🎨 Figma Dev Mode MCP (`mcp__figma-dev-mode-mcp-server__*`)

로컬 Figma 데스크톱 앱의 Dev Mode MCP 서버용 읽기 권한. 기능은 위 Figma MCP와 동일.

| 권한 | 설명 |
|---|---|
| `mcp__figma-dev-mode-mcp-server__get_screenshot` | 노드 스크린샷 캡처 |
| `mcp__figma-dev-mode-mcp-server__get_metadata` | 노드 메타데이터 조회 |
| `mcp__figma-dev-mode-mcp-server__get_design_context` | 디자인 컨텍스트 추출 |
| `mcp__figma-dev-mode-mcp-server__get_variable_defs` | 변수(토큰) 정의 조회 |
| `mcp__figma-dev-mode-mcp-server__get_code_connect_map` | Code Connect 매핑 조회 |
| `mcp__figma-dev-mode-mcp-server__create_design_system_rules` | 디자인 시스템 규칙 프롬프트 생성 |

## 🎨 claude.ai Figma 커넥터 (`mcp__claude_ai_Figma__*`)

| 권한 | 설명 |
|---|---|
| `mcp__claude_ai_Figma__create_new_file` | 새 Figma/FigJam/Slides 파일 생성 |
| `mcp__claude_ai_Figma__use_figma` | Figma Plugin API 실행 (노드 생성·편집 등 쓰기 작업) |

---

## 권한 패턴 규칙

- `Tool` — 해당 도구를 인자 제한 없이 허용
- `Bash(command:*)` — 해당 명령어를 모든 인자와 함께 허용 (현재 미사용 — safelist로 대체)
- `Bash(command)` — 해당 명령어를 인자 없이만 허용 (현재 미사용 — safelist로 대체)

## settings.json의 다른 섹션 (요약)

| 섹션 | 역할 |
|---|---|
| `hooks` | SessionStart(레포 동기화 / pubg credential helper 등록), PreToolUse(Bash safelist 자동 승인), PreCompact(CLAUDE.md 개정 트리거) |
| `enabledPlugins` / `extraKnownMarketplaces` | 플러그인 활성화 및 마켓플레이스 소스 (pubg 마켓플레이스 인증은 `.env` + credential helper) |
| `model` | 기본 모델 지정 |
