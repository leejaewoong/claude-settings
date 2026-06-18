---
name: allow-cmd
description: 사용자가 /allow-cmd 뒤에 인자로 넘긴 명령어 문자열에서 허용되지 않은 bash 명령어를 찾아 안내하고, 승인 시 settings.json의 허용 목록에 추가한다. sudo / git 옵션 같은 복합 prefix도 인식. 명시적 호출 전용.
---

# /allow-cmd

사용자가 인자로 넘긴 명령어 문자열에서 허용되지 않은 bash 명령어를 찾아 안내하고, 승인 시 허용 목록에 추가합니다.

## 입력

사용자가 `/allow-cmd` 뒤에 전달한 명령어 문자열 전체를 분석 대상으로 사용합니다.

예시: `/allow-cmd cd /project && find . -name "*.py" | grep test | head -20`

## 실행 절차

### 0단계: 복합 prefix 패턴 식별

Claude Code의 `Bash(<prefix>:*)` 권한은 **명령어 문자열의 리터럴 prefix** 만 매칭합니다. 따라서 `sudo ls` 는 `Bash(ls:*)` 로 덮을 수 없고 `Bash(sudo ls:*)` 가 별도로 필요합니다. 마찬가지로 `git -C /repo status` 는 `Bash(git status:*)` 로 덮이지 않고 `Bash(git -C:*)` 가 필요합니다.

아래 prefix가 감지되면 **복합 패턴과 베어 패턴 두 가지 후보를 모두** 등록 대상으로 올립니다 (이미 허용된 쪽은 자동 스킵).

**감지 규칙**

| Prefix | 감지 조건 | 추가로 소비할 토큰 | 논리적 실행 파일 | 등록할 복합 패턴 | 등록할 베어 패턴 |
|---|---|---|---|---|---|
| sudo | 첫 토큰 = `sudo` | `-u <user>`, `-g <group>`, `-U <user>`, `-r <role>`, `-t <type>`, `-h <host>` 같이 **값 토큰을 분리해서 받는 옵션**은 다음 토큰까지 함께 소비. `-H`, `-E`, `-i`, `-s`, `-n`, `-b`, `-k`, `-K`, `-l`, `-v` 같은 무값 옵션은 단독 소비. `--` 만나면 옵션 종료 | 옵션을 모두 건너뛴 뒤 첫 비옵션 토큰 | `Bash(sudo <executable>:*)` (옵션 값은 정규화에서 제거) | `Bash(<executable>:*)`. executable이 `git`이면 git 서브커맨드 단계로 재귀하여 `Bash(git <subcmd>:*)` |
| git 옵션 | 첫 토큰 = `git`, 두 번째 토큰이 `-`로 시작 | `-C <path>`, `-c <key=val>` 처럼 **값 토큰을 분리해서 받는 short option**은 다음 토큰 함께 소비. `--xxx=yyy` (등호 결합)는 단독 소비. `--git-dir <path>`, `--work-tree <path>`, `--namespace <v>`, `--exec-path <path>` 처럼 **값을 받는 long option**은 다음 토큰까지 함께 소비. `--no-pager`, `--paginate`, `--bare`, `--no-replace-objects` 등 무값 옵션은 단독 소비 | 옵션을 모두 건너뛴 뒤 첫 비옵션 토큰 (= 서브커맨드) | `Bash(git <첫 옵션의 키 부분>:*)` — `Bash(git -C:*)`, `Bash(git --git-dir:*)`, `Bash(git -c:*)` 등. **서브커맨드는 복합 패턴에 인코딩하지 않음** | `Bash(git <subcmd>:*)` |

**정규화 규칙**: 옵션 *값* 은 모두 와일드카드(`*`)에 흡수시키고 **옵션 키만** 패턴에 남깁니다. path/user 마다 신규 엔트리가 늘어나는 것을 방지하기 위함입니다.

**예시**

| 입력 | 복합 패턴 | 베어 패턴 |
|---|---|---|
| `sudo ls /var/log` | `Bash(sudo ls:*)` | `Bash(ls:*)` |
| `sudo -u root cat /etc/shadow` | `Bash(sudo cat:*)` | `Bash(cat:*)` |
| `sudo -H npm install -g pkg` | `Bash(sudo npm:*)` | `Bash(npm:*)` |
| `sudo git -C /repo pull` (이중 prefix, 재귀) | `Bash(sudo git:*)` + `Bash(git -C:*)` | `Bash(git pull:*)` |
| `git -C /repo status` | `Bash(git -C:*)` | `Bash(git status:*)` |
| `git --git-dir=/a/.git log` | `Bash(git --git-dir:*)` | `Bash(git log:*)` |
| `git --work-tree /w status` | `Bash(git --work-tree:*)` | `Bash(git status:*)` |
| `git -c color.ui=always diff` | `Bash(git -c:*)` | `Bash(git diff:*)` |
| `PYTHONIOENCODING=utf-8 python x.py` | (범위 밖 — 안내만, 자동 등록 시도 안 함) | `Bash(python:*)` |

**왜 git 복합은 `Bash(git -C:*)` 처럼 넓게 두는가**

- Claude Code 패턴은 위치 와일드카드를 지원하지 않습니다. `Bash(git -C * status:*)` 같은 형식은 매칭되지 않습니다.
- `Bash(git -C:*)` 는 `git -C <임의 경로> <임의 서브커맨드> ...` 전부를 한 줄로 덮습니다.
- 서브커맨드별 세분 제어는 베어 측의 `Bash(git <subcmd>:*)` 가 이미 담당하므로, 복합 측은 "옵션 prefix를 통과시키는 단일 게이트" 역할에만 집중합니다.

**Edge case**

| 케이스 | 처리 |
|---|---|
| `sudo cmd1 && cmd2` | 두 단위로 분리. cmd1만 복합 처리 (`Bash(sudo cmd1:*)` + `Bash(cmd1:*)`), cmd2는 단순 베어 |
| `$(sudo cmd)`, `` `sudo cmd` `` | 서브쉘 내부에 재귀 적용 |
| `sudo` 단독 (다음 비옵션 토큰 없음) | 복합 prefix 미감지로 처리, `Bash(sudo:*)` 한 개만 후보. 결과 안내에 "복합 prefix 미감지" 메모 |
| `git --version`, `git --help` (서브커맨드가 옵션) | `Bash(git:*)` 한 개만 후보. 이미 있으면 스킵 |
| `git -C /repo` (서브커맨드 없음) | 베어 측 매칭 불가, 복합 측 `Bash(git -C:*)` 만 후보 |
| **베어는 허용됐는데 복합이 없음** | 결과 테이블에 복합 행을 **미허용** 으로 노출. 현재 버그의 주된 발생 패턴 |
| 복합은 허용됐는데 베어가 없음 | 결과 테이블에 베어 행을 **미허용** 으로 노출 |

### 1단계: 명령어 파싱

인자로 받은 명령어 문자열에서 개별 명령어를 추출합니다:

- 파이프 `|`, AND `&&`, 세미콜론 `;`, OR `||` 등으로 분리
- 각 개별 명령어에서 **논리적 실행 파일과 복합 prefix** 를 추출 — **0단계 참조**
- 기본은 첫 번째 단어를 실행 파일로 보되, 첫 단어가 `sudo` 또는 `git`이고 다음 토큰이 옵션(`-`로 시작)인 경우 0단계 토큰 소비 규칙 적용
- 서브쉘 `$(...)`, 백틱 `` `...` ``, process substitution `<(...)` / `>(...)` 내부도 동일 규칙으로 **재귀적으로** 파싱
- 쉘 내장 명령은 제외: `cd`, `set`, `export`, `unset`, `:`, `true`, `false`, `[`, `[[`, `pushd`, `popd`

### 2단계: 허용 목록 비교

`~/.claude/settings.json`의 `permissions.allow` 배열에서 `Bash(...)` 패턴들을 읽습니다.

각 추출된 단위에 대해 **베어 측과 복합 측을 독립적으로** 확인합니다:

1. **베어 측 매칭**: `Bash(<executable>)`, `Bash(<executable>:*)`. git 서브커맨드면 `Bash(git <subcmd>)`, `Bash(git <subcmd>:*)`
2. **복합 측 매칭** (0단계에서 복합 prefix가 감지된 경우만): `Bash(<정규화된 복합>:*)`. 예: `Bash(sudo ls:*)`, `Bash(git -C:*)`, `Bash(git --git-dir:*)`

**둘 중 하나라도 미허용이면** 결과 테이블에 노출하고 등록 후보로 올립니다.

> **Note**: 복합 패턴은 `Bash(git -C:*)` 처럼 broad한 형태를 사용합니다. Claude Code가 위치 와일드카드를 지원하지 않아 옵션 키만 prefix에 두고 나머지는 `:*` 와일드카드로 흡수시키는 방식입니다. 자세한 근거는 0단계 참조.

### 3단계: 결과 안내

**모든 단위가 양쪽 다 허용된 경우:**
> "입력된 명령어는 복합/베어 모두 허용 목록에 포함되어 있습니다."

**미허용 단위가 있는 경우**, 5컬럼 테이블로 안내합니다:

| 입력 | 패턴 종류 | 등록할 패턴 | 허용 시 주의점 | 상태 |
|---|---|---|---|---|
| `sudo ls /var/log` | 복합 (sudo) | `Bash(sudo ls:*)` | sudo는 root 권한으로 ls 실행, 보호 디렉토리 노출 가능 | **미허용** |
| `sudo ls /var/log` | 베어 | `Bash(ls:*)` | - | 허용됨 |
| `git -C /repo status` | 복합 (git 옵션) | `Bash(git -C:*)` | 임의 경로의 git 저장소 조작 가능. `.git/config` 변조로 원격 URL 우회 가능성 | **미허용** |
| `git -C /repo status` | 베어 | `Bash(git status:*)` | - | 허용됨 |

작성 규칙:
- 한 입력이 복합/베어 두 행을 차지할 수 있음. 양쪽이 모두 허용되어야 prefix 형태 호출이 실제로 권한 프롬프트 없이 통과
- 패턴 종류는 `복합 (sudo)`, `복합 (git 옵션)`, `베어`, `단일` 중 하나
- 설명·주의점은 한국어로 간결하게 작성
- 이미 허용된 행도 함께 표시하여 전체 현황 파악 가능하게 함
- **미허용 행에는 허용 시 주의점을 반드시 안내** (허용된 행은 `-`로 표시)
- 환경변수 prefix (`KEY=VAL cmd ...`) 처럼 자동 처리 범위 밖인 입력은 베어 행 한 줄만 표시하고 표 아래에 "환경변수 prefix는 현재 자동 처리 범위 밖 — 필요 시 수동으로 `Bash(KEY=VAL cmd:*)` 추가" 안내 1줄 첨부

**주의점 예시 (보안 위험·부작용·성능 영향 등)**:
- `rm`: 와일드카드(`*`)와 함께 사용 시 의도치 않은 파일 삭제 위험
- `curl`/`wget`: 외부 네트워크 요청으로 민감 정보 유출 가능성
- `sed -i`: 원본 파일을 직접 수정하므로 백업 없이 데이터 손실 가능
- `kill`: 잘못된 PID 지정 시 시스템 프로세스 종료 위험
- `chmod`/`chown`: 잘못된 권한 변경 시 보안 취약점 발생 가능
- `docker`: 컨테이너를 통한 호스트 시스템 접근 가능성
- `eval`: 임의 코드 실행으로 보안 위험 높음 (허용 비권장)
- `sudo <cmd>`: 모든 sudo 호출은 root 권한 상승. `sudo -n` 또는 `NOPASSWD` 환경에서는 무인 실행으로 위험 증폭
- `git -C <path>`: 임의 디렉토리의 git 저장소 메타데이터 접근/조작 가능. `.git/config` 변조로 원격 URL 우회 가능성
- `git -c <key>=<val>`: `core.sshCommand`, `core.editor` 등 일부 키 값으로 **임의 명령 실행 가능** (보안 위험 최상 — 허용 비권장)
- `git --git-dir`, `git --work-tree`: 임의 경로 지정 — 위와 동일 위험. broad 허용 시 명시적으로 안내

### 4단계: 사용자 확인

AskUserQuestion을 사용하여 미허용 단위의 추가 여부를 확인합니다:

- 옵션: "모두 추가", "선택적 추가", "취소"
- "선택적 추가" 선택 시 multiSelect로 개별 항목 선택 가능. **복합 행과 베어 행은 각각 독립 항목**으로 노출하여 한쪽만 추가하고 다른 쪽은 건너뛰는 선택이 유효하도록 함

### 5단계: 파일 업데이트

승인된 패턴에 대해 두 파일을 업데이트합니다.

**settings.json 업데이트:**

- `permissions.allow` 배열에 승인된 패턴 추가
- 등록 직전에 동일 문자열이 이미 존재하면 스킵 (중복 회피)
- 삽입 위치 규약:
  - 베어 패턴은 기존 카테고리 위치에 삽입 (예: 텍스트 처리 도구는 `Bash(awk:*)` 근처)
  - **git 옵션 복합 패턴** (`Bash(git -C:*)`, `Bash(git --git-dir:*)`, `Bash(git -c:*)`, `Bash(git --work-tree:*)`)은 git 그룹 끝(`Bash(git worktree:*)` 다음 줄)에 인접 배치
  - **sudo 복합 패턴** (`Bash(sudo <cmd>:*)`)은 시스템 유틸리티 그룹 끝(`Bash(taskkill:*)` 다음 줄)에 배치

**settings-reference.md 업데이트:**

- 베어 패턴은 기존 섹션 (시스템 유틸리티 / Python / Git 등) 테이블에 행 추가
- **복합 패턴은 신설 섹션 `## 🔐 권한 상승 / Git 옵션 prefix`** 에 추가
  - 위치: `## 🔧 시스템 유틸리티`와 `## 📦 아카이브 / 압축` 사이
  - 섹션이 아직 없으면 먼저 헤더와 빈 테이블 생성 후 행 추가
  - 형식 예시:
    ```
    | `Bash(sudo <cmd>:*)` | <cmd>를 sudo로 실행 (root 권한 상승). 옵션(`-u`, `-H` 등)도 같은 패턴에 포함 |
    | `Bash(git -C:*)` | 임의 경로의 git 저장소를 대상으로 모든 서브커맨드 실행 |
    | `Bash(git --git-dir:*)` | --git-dir 옵션으로 지정한 .git 디렉토리에서 모든 서브커맨드 실행 |
    | `Bash(git -c:*)` | 일회성 config 값과 함께 git 서브커맨드 실행. `core.sshCommand` 등 일부 키는 임의 명령 실행 가능 — 신중히 허용 |
    ```
- 실제로 허용한 패턴만 표에 추가 (스킵된 중복은 추가하지 않음)

### 6단계: 커밋 및 푸시

파일 업데이트 완료 후 변경사항을 커밋하고 원격 저장소에 푸시합니다:

1. `git add settings.json settings-reference.md`
2. 커밋 메시지는 `/commit` 커맨드 규칙을 따름
   - 단일 패턴: `🔨Env(settings.json, settings-reference.md): <명령어> 허용 명령어 추가`
   - **복합 + 베어 함께 추가**: `🔨Env(settings.json, settings-reference.md): sudo ls / ls 허용 명령어 추가`
   - **복합만 추가**: `🔨Env(settings.json, settings-reference.md): git -C 복합 prefix 허용 추가`
3. `git push`로 원격 저장소에 반영

## 주의사항

- 파일명, 명령어명은 영어 유지
- 설명과 안내 메시지는 한국어로 작성
- `git rm --cached` 같은 git 하위 명령어는 `Bash(git rm:*)` 형태로 확인
- 이미 허용된 명령어는 중복 추가하지 않음
- `Bash(<prefix>:*)` 패턴은 **명령어 문자열의 리터럴 prefix** 만 매칭하며 위치 와일드카드를 지원하지 않음. `Bash(git -C * status:*)` 같은 형식은 동작하지 않음
- 복합 prefix 명령(`sudo`, `git -C`, `git --git-dir`, `git --work-tree`, `git -c` 등)은 **복합 패턴과 베어 패턴 양쪽을 모두 확인**. 한쪽만 누락된 경우가 현재 버그의 주된 발생 원인
- 복합 패턴 정규화 시 **옵션 값은 와일드카드에 흡수**시키고 **옵션 키만** prefix에 보존 (path/user 마다 신규 엔트리가 늘지 않게)
