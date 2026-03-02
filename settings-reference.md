# Claude Code settings.json 권한 참조

> `settings.json`의 `permissions.allow` 항목별 설명입니다.

---

## 📁 파일 시스템 조작

| 권한 | 설명 |
|---|---|
| `Edit` | 기존 파일의 내용을 부분 편집 (diff 방식) |
| `Write` | 파일 전체 내용을 작성/덮어쓰기 (새 파일 생성 포함) |
| `Read` | 파일 내용 읽기 |
| `Glob` | 글로브 패턴으로 파일 검색 (예: `**/*.py`) |
| `Grep` | 파일 내용에서 정규표현식 패턴 검색 (내장 도구) |
| `NotebookEdit` | Jupyter 노트북(.ipynb) 셀 편집 |
| `Bash(cat:*)` | `cat` 명령어로 파일 내용 출력 |
| `Bash(ls:*)` | `ls` 명령어로 디렉토리 목록 조회 |
| `Bash(find:*)` | `find` 명령어로 파일/디렉토리 검색 |
| `Bash(mkdir:*)` | `mkdir` 명령어로 디렉토리 생성 |
| `Bash(cp:*)` | `cp` 명령어로 파일/디렉토리 복사 |
| `Bash(mv:*)` | `mv` 명령어로 파일 이동 또는 이름 변경 |
| `Bash(rm:*)` | `rm` 명령어로 파일/디렉토리 삭제 |

## 🔀 Git 버전 관리

| 권한 | 설명 |
|---|---|
| `Bash(git status)` / `Bash(git status:*)` | 작업 트리 상태 확인 |
| `Bash(git log)` / `Bash(git log:*)` | 커밋 히스토리 조회 |
| `Bash(git show)` / `Bash(git show:*)` | 특정 커밋의 변경 내용 확인 |
| `Bash(git diff)` / `Bash(git diff:*)` | 변경사항 비교 (staged/unstaged) |
| `Bash(git branch)` / `Bash(git branch:*)` | 브랜치 목록 조회 및 생성/삭제 |
| `Bash(git clone:*)` | 원격 저장소를 로컬에 복제 |
| `Bash(git fetch)` / `Bash(git fetch:*)` | 원격 저장소 정보를 로컬에 동기화 |
| `Bash(git remote)` / `Bash(git remote:*)` | 원격 저장소 URL 조회 및 관리 |
| `Bash(git add:*)` | 변경된 파일을 스테이징 영역에 추가 |
| `Bash(git commit:*)` | 스테이징된 변경사항을 커밋으로 저장 |
| `Bash(git push)` / `Bash(git push:*)` | 로컬 커밋을 원격 저장소에 푸시 |
| `Bash(git checkout:*)` | 브랜치 전환 또는 특정 파일 복원 |
| `Bash(git restore:*)` | 작업 트리의 파일을 이전 상태로 복원 |
| `Bash(git stash)` / `Bash(git stash:*)` | 변경사항을 임시 저장 및 복원 |
| `Bash(git merge:*)` | 다른 브랜치의 변경사항을 현재 브랜치에 병합 |
| `Bash(git tag)` / `Bash(git tag:*)` | 태그 조회, 생성, 삭제 (릴리스 관리) |
| `Bash(git config:*)` | Git 설정 값 조회 및 변경 |
| `Bash(git read-tree:*)` | 트리 객체 정보를 인덱스로 읽기 |
| `Bash(git worktree)` / `Bash(git worktree:*)` | Git worktree 관리 (생성, 목록, 삭제) |

## 📦 Node.js / NPM

| 권한 | 설명 |
|---|---|
| `Bash(node:*)` | Node.js로 스크립트 실행 |
| `Bash(npm:*)` | npm의 모든 하위 명령어 실행 (install, run, test 등 포함) |
| `Bash(npx:*)` | npm 패키지를 설치 없이 일회성 실행 |

## 🐍 Python

| 권한 | 설명 |
|---|---|
| `Bash(python:*)` | Python 스크립트 실행 |
| `Bash(PYTHONIOENCODING=utf-8 python:*)` | UTF-8 인코딩 환경변수와 함께 Python 실행 |
| `Bash(pip:*)` | pip의 모든 하위 명령어 실행 (install, list, show 등 포함) |

## 🐙 GitHub CLI

| 권한 | 설명 |
|---|---|
| `Bash(gh:*)` | GitHub CLI로 PR, 이슈, CI 상태 등 관리 |

## 🔧 시스템 유틸리티

| 권한 | 설명 |
|---|---|
| `Bash(pwd)` | 현재 작업 디렉토리 경로 출력 |
| `Bash(which:*)` | 실행 파일의 경로 확인 (Linux/Mac) |
| `Bash(where:*)` | 실행 파일의 경로 확인 (Windows) |
| `Bash(start:*)` | Windows에서 파일/URL을 기본 프로그램으로 열기 |
| `Bash(sleep:*)` | 지정한 시간(초) 동안 대기 |
| `Bash(netstat:*)` | 네트워크 연결 상태 및 포트 사용 현황 조회 |
| `Bash(grep:*)` | 파일 내용 또는 파이프 입력에서 정규표현식으로 패턴 검색 |
| `Bash(head:*)` | 파일 또는 파이프 입력의 처음 N줄만 출력 |
| `Bash(tail:*)` | 파일 또는 파이프 입력의 마지막 N줄만 출력 |
| `Bash(wc:*)` | 파일의 줄/단어/바이트 수 카운트 |

## 🌐 웹 / 네트워크

| 권한 | 설명 |
|---|---|
| `Bash(curl:*)` | HTTP 요청 전송 (GET, POST 등 모든 메서드) |
| `WebFetch` | 지정한 URL에서 웹 콘텐츠를 가져와 분석 |

---

## 권한 패턴 규칙

- `Tool` — 해당 도구를 인자 제한 없이 허용
- `Bash(command:*)` — 해당 명령어를 **모든 인자**와 함께 허용
- `Bash(command)` — 해당 명령어를 **인자 없이**만 허용 (예: `git status`)
