# Loading (로딩 UI)

## 용도
화면 로딩 중 사용자에게 대기 상태를 알려주는 피드백 UI. 서버 연결, 데이터 로드 시 사용.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Type | Spinner + Symbol | 스피너 + 심볼 애니메이션 (아웃게임 기본) |
| | Spinner | 스피너만 (심볼 부하 시 사용) |
| | Text | 텍스트("LOADING") 표시 (콘솔 기본) |

## textOverrides

| 키 | 설명 |
|----|------|
| LoadingText | 로딩 텍스트 (Text 타입 시 사용, 기본: "LOADING") |

## 규칙 (위키 사양서)

### 타입별 사용 기준
- Spinner + Symbol: 아웃게임에서 기본적으로 사용
- Spinner: 심볼 애니메이션 부하가 있을 경우 사용
- Text: 콘솔에서 기본 사용 (스트링키: `COMMON:LOADING_FLOAT`)

### 플랫폼별 기본 타입
- PC: Spinner + Symbol (기본), 일부 화면에서 Spinner
- Console: Text (기본), 로비 진입/플레이 버튼은 예외적으로 Spinner + Symbol

## 적용 케이스 (위키 사양서)

| 화면 | PC 타입 | Console 타입 |
|------|---------|-------------|
| 로비 진입 (게임 첫 실행/재시작) | Spinner + Symbol | Spinner + Symbol (예외) |
| 플레이 버튼/하단 배너 | Spinner + Symbol | Spinner + Symbol (예외) |
| 소셜, 클랜 (PUBG ID 피쳐) | Spinner + Symbol | Text |
| 커스텀 매치 리스트 | Spinner | Text |
| 경쟁전 순위표 | Spinner | Text |
| 전적 (매치 히스토리/무기/다시보기) | Spinner | Text |
| 뉴스 패치 노트 | Spinner | Text |
| 전적 매치 리포트 | Spinner + Symbol | Text |
| 상점 상품 구매 요청 | Spinner + Symbol | Text |
| 모달 (클랜 아이템/패스 레벨업) | Spinner + Symbol | Text |
| 클랜/소셜 검색 | Spinner + Symbol | Text |
| 모달 아이템 확률 | Spinner + Symbol | Text |
| 최초 캐릭터 생성 스킨 데이터 | Spinner + Symbol | Text |
| OES 빙고 티켓 | Spinner + Symbol | Text |

