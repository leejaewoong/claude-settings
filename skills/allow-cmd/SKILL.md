---
name: allow-cmd
description: 사용자가 /allow-cmd 뒤에 인자로 넘긴 명령어 문자열을 분석해 bash-safelist.txt에 빠진 항목을 안내하고, 승인 시 safelist 파일에 추가한다. 분해 로직은 PreToolUse 훅(bashlex 기반)이 담당하므로 스킬은 결과 안내·승인·기록 역할만. 명시적 호출 전용.
---

# /allow-cmd

`~/.claude/hooks/bash_safelist_check.py`가 명령어를 원자 단위로 분해하고, 해당 atoms가 `~/.claude/bash-safelist.txt`에 모두 있으면 PreToolUse 훅이 자동 승인합니다. 이 스킬은 그 매칭에 빠진 atom을 찾아 사용자에게 보여주고 safelist에 추가하는 도구입니다.

## 동작 모델

- **분해의 진실 공급원**: 훅 스크립트 (`hooks/bash_safelist_check.py`)
- **허용 목록**: `bash-safelist.txt` (한 줄당 한 atom, `#` 코멘트 가능)
- **legacy `Bash(...:*)` 패턴 (settings.json)**: 손대지 않음. 백업으로 그대로 유지

스킬은 settings.json/settings-reference.md를 건드리지 않습니다. 안 그래도 됩니다 — 훅이 safelist 매칭으로 승인하니까요.

## 입력

사용자가 `/allow-cmd` 뒤에 전달한 명령어 문자열 전체.

예시: `/allow-cmd cd /project && find . -name "*.py" | grep test | head -20`

인자가 비어 있으면 사용법을 안내하고 종료.

## 실행 절차

### 1단계: 훅 스크립트로 분해 결과 받기

heredoc + stdin으로 명령을 전달해 셸 인용 문제를 회피합니다 (`<<'CMDEOF'` 의 single-quote가 핵심 — `$`, 백틱이 보간되지 않습니다):

```bash
python C:/Users/jaewoong/.claude/hooks/bash_safelist_check.py --explain <<'CMDEOF'
<사용자가 넘긴 명령어를 그대로 — 이스케이프 없이 — 한 줄 또는 여러 줄로>
CMDEOF
```

인자 모드(`--explain "..."`)도 지원하지만 `$`나 `"` 가 포함되면 이스케이프가 번거롭습니다. 기본은 heredoc.

JSON 구조:

```json
{
  "command": "...",
  "parse_ok": true,
  "atoms": ["git ls-files", "echo", "echo"],
  "safelisted": ["echo", "git ls-files"],
  "missing": [],
  "safelist_path": "C:\\Users\\jaewoong\\.claude\\bash-safelist.txt",
  "safelist_exists": true
}
```

### 2단계: 결과 분기

**Case A — `parse_ok: false`** (bashlex 파싱 실패, 예: `[[ -f x ]] && cp x y`)

훅이 분해할 수 없으므로 해당 명령은 **safelist에 무엇을 추가하든 자동 승인되지 않습니다**. 사용자에게 안내:

> "이 명령은 bashlex가 파싱하지 못해(parse_ok: false) safelist 매칭이 불가능합니다. 항상 권한 프롬프트가 뜹니다.
> 대안: `[[ ... ]]` 대신 `[ ... ]` 사용, 또는 매번 수동 승인."

종료. 추가 작업 없음.

**Case B — `missing: []`** (모두 safelist에 있음)

> "입력하신 명령의 모든 atom(`<atom 목록>`)이 이미 safelist에 있습니다. PreToolUse 훅이 자동 승인합니다."

종료. 추가 작업 없음.

**Case C — `missing: [...]`** (일부 atom이 빠짐)

표로 안내한 뒤 승인 절차로 진행 (3단계).

### 3단계: 결과 테이블 + 승인 요청

미허용 atom이 있는 경우 다음 형식의 표:

| atom | 상태 | 추가 시 주의점 |
|---|---|---|
| `git ls-files` | 허용됨 | - |
| `echo` | 허용됨 | - |
| `rg` | **미허용** | ripgrep 검색. 읽기 전용, 위험도 낮음 |
| `sudo systemctl` | **미허용** | sudo systemctl 호출 — 서비스 시작/중지·재시작 가능. 위험도 ★★ |

작성 규칙:
- atom은 훅이 정규화한 형태 그대로 (예: `git -C`, `sudo cat`, `git ls-files`). 임의로 다듬지 말 것
- 주의점은 한국어로 간결하게. 위험도가 보일 때만 명시
- 허용됨 행은 `-`로 주의점 생략

**주의점 가이드** (atom 종류별 휴리스틱):

| Atom 패턴 | 위험도 / 메모 |
|---|---|
| `rm`, `mv` | 와일드카드·재귀 옵션 결합 시 의도치 않은 손실 가능 |
| `curl`, `wget` | 외부 네트워크 요청·민감 정보 유출 가능 |
| `sed`, `awk` | `-i`(in-place) 옵션은 원본 직접 수정 |
| `kill`, `taskkill` | 잘못된 PID/이름으로 시스템 프로세스 종료 위험 |
| `chmod`, `chown` | 권한·소유권 변경 — 보안 영향 |
| `docker`, `podman` | 컨테이너 통해 호스트 접근 가능 |
| `eval` | 임의 코드 실행 — **추가 비권장** |
| `sudo <cmd>` | root 권한 상승. NOPASSWD 환경에선 무인 실행 위험 |
| `git -C`, `git --git-dir`, `git --work-tree` | 임의 경로의 저장소 접근/조작 가능 |
| `git -c <key>=<val>` | `core.sshCommand`, `core.editor` 등 일부 키로 **임의 명령 실행** — 위험도 최상 |
| 기타 읽기 전용 (`ls`, `cat`, `find`, `grep`, `head`, `tail`, `wc`, `file`, `stat` 등) | 위험도 낮음 |

AskUserQuestion으로 추가 여부 확인:
- 옵션: "모두 추가", "선택적 추가", "취소"
- "선택적 추가" 선택 시 multiSelect로 atom 단위 개별 선택

### 4단계: safelist 파일 업데이트

승인된 atom을 `bash-safelist.txt`에 추가합니다.

추가 방식:
1. 파일 끝에 `## /allow-cmd로 추가된 항목` 섹션이 없으면 한 번만 생성
2. 그 아래에 atom을 한 줄씩 추가
3. 중복은 자동 스킵 (파일을 먼저 읽어 이미 있는지 확인)

예시:

```
# (기존 카테고리들…)

## /allow-cmd로 추가된 항목
rg
sudo systemctl
```

원자명 그대로 (정규화된 형태 그대로) 한 줄에 하나. `Bash(...)` 같은 패턴 문법 사용 금지 — safelist는 atom 문자열 그대로 비교합니다.

### 5단계: 동작 검증

추가 직후 다시 `--explain`을 실행해 `missing: []`이 되는지 확인 (1단계와 동일한 heredoc 형식):

```bash
python C:/Users/jaewoong/.claude/hooks/bash_safelist_check.py --explain <<'CMDEOF'
<원래 명령>
CMDEOF
```

`missing`이 비어 있지 않으면 정규화 차이가 의심되니 사용자에게 보고하고 중단합니다.

### 6단계: 커밋 및 푸시

`~/.claude` 디렉토리에서:

1. `git add bash-safelist.txt`
2. 커밋 메시지는 `/commit` 컨벤션을 따름:
   - 단일 atom: `🔨Env(bash-safelist.txt): rg safelist 추가`
   - 복수 atom: `🔨Env(bash-safelist.txt): rg / sudo systemctl safelist 추가`
3. `git push`

## 주의사항

- **atom 표기는 훅 출력 그대로 사용**. `git -C`를 `git`으로 줄이거나, `sudo cat`을 `sudo`로 줄이면 매칭 안 됨
- **safelist는 prefix 매칭이 아닌 exact 매칭**. `git` 한 줄로 `git status`, `git log` 전부를 허용할 수 없음. 각 서브커맨드를 별도 줄로 추가
- **legacy settings.json 패턴은 건드리지 않음**. 사용자가 별도로 정리하길 원하면 그때 진행
- **위험 atom은 권장하지 않음**. `eval`, `bash`, `sh`는 임의 명령 실행 게이트라서 safelist 의미를 무력화. 사용자가 명시적으로 요청해도 한 번 더 확인
- **시크릿 위험**: safelist 파일 자체에 시크릿은 없지만, atom 이름이 길어지면(`sudo systemctl` 같은 multi-word) 오타로 매칭 안 될 수 있음. 추가 후 5단계 검증 필수
