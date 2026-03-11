# PUBGID (PUBG ID)

## 용도
플레이어의 프로필 및 온/오프라인 상태 등 플레이어 정보를 표시하는 아웃게임 컴포넌트.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Size | Small | 소형 |
| | Medium | 중형 |
| | Large | 대형 |

## 규칙 (위키 사양서)

### 일반 규칙
- 내부 구성 요소는 모두 Property On/Off로 조정하여 사용 가능
- 세 가지 사이즈 (Small/Medium/Large) 중 선택 사용
- 높이 기준으로 사이즈를 나누고 가로폭은 최소/최대 사이즈 규정
- 인게임과 별개의 컴포넌트 (아웃게임 전용)

### Property 목록

| 속성 | 값 | 설명 |
|------|-----|------|
| nameplateId | string | 네임플레이트 배경 (항상 장착 상태, 해제 없음) |
| enableAnimation | true/false | 네임플레이트/엠블럼 애니메이션 재생 여부 |
| nickname | string | 플레이어 닉네임 (좌상단, 최대 W 16자) |
| OriginType | xbox/playstation/… | 콘솔 유저 시 닉네임 옆 플랫폼 아이콘 |
| favoriteMedals | - | 메달 (우측 끝단, 최대 2개) |
| userConnectionStatus | no-status/offline/online/playing | 좌측 끝단 연결 상태 표시 |
| showNotiBadge | On/Off | 좌상단 노티 마커 (친구 요청 시) |
| emblemId | string | 좌측 엠블럼 (미소유/미설정 시 PUBG 로고 대체) |
| clan | - | 엠블럼 하단 클랜 정보 (미가입 시 미노출) |
| reputationLevel | 1~5/null | 닉네임 우측 평판 레벨 |
| clanRoleIcon | Master/Admin/null | 평판 우측 클랜 직급 아이콘 |
| showMuteIcon | true/false | 콘솔 음소거 아이콘 |
| survivalMastery | - | 닉네임 하단 서바이벌 마스터리 (티어+레벨) |
| onlineStatus | string key | 닉네임 하단 온라인 상태 텍스트 |
| showAccountMemo | true/false | 플레이어 상태 우측 메모 |
| elapsedLastPlayWithTime | - | 함께 플레이 시간 표시 |
| elapsedRequestTime | - | 초대 요청 시간 표시 |

### 소셜형 예외
- 오프라인 시 기본 회색 배경 제공

### UI 인터랙션
- 일반: 기본 상태
- 호버: 상단 화이트 그라데이션 이미지 출력

### 온라인 상태 표시
- 접속 중: 온라인, 매치메이킹, 본인, 우리 팀, 다른 팀
- 게임 플레이 중: 플레이 중 (파티원 수 표시 가능)
- 오프라인: 마지막 접속 시간 표시 (분 단위 버림)

### 활용 지양
- 프로퍼티 On/Off 조작은 가능하나, 과도한 커스텀 사용은 지양

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 소셜 친구 목록 | 온/오프라인 상태 + 닉네임 + 메달 표시 |
| 파티 | 파티원 PUBG ID 표시 |
| 클랜 | 클랜원 목록에서 직급 아이콘 포함 |
| 프로필 | Large 사이즈로 상세 정보 표시 |

## 자주 쓰는 조합

```json
// Medium 사이즈 기본 PUBG ID
{
  "type": "component",
  "component": "PUBGID",
  "variant": "Size=Medium",
  "x": 100, "y": 200,
  "width": 300, "height": 56
}

// Large 사이즈 프로필용
{
  "type": "component",
  "component": "PUBGID",
  "variant": "Size=Large",
  "x": 100, "y": 100,
  "width": 400, "height": 80
}
```
