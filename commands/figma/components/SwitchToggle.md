# SwitchToggle (스위치 토글)

## 용도
두 상태(켜기/끄기) 사이를 빠르게 전환하는 스위치 컴포넌트.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Status | Active | 활성 상태 (조작 가능) |
| | Disabled | 비활성 상태 (조작 불가) |
| Toggle | On | 토글 켜짐 |
| | Off | 토글 꺼짐 |
| Size | Small | 소형 |
| | Medium | 중형 |
| | Large | 대형 |

## 규칙 (위키 사양서)

### 일반 규칙
- PC/Console 모두 동일한 형태로 토글 출력
- 기본값은 각 피쳐마다 다르게 설정 가능
- 세 가지 사이즈 (Small/Medium/Large) 중 선택 사용

### 유형 조합
- Active/OFF: 토글 OFF + 조작 가능
- Active/ON: 토글 ON + 조작 가능
- Disabled/OFF: 토글 OFF + 조작 불가
- Disabled/ON: 토글 ON + 조작 불가

## 적용 케이스 (위키 사양서)

| 화면/기능 | 사이즈 | 기본 상태 | 설명 |
|-----------|--------|----------|------|
| 동일 언어 매칭 (로비) | Small | Disabled/ON | 좌측 하단 텍스트 옆 |
| 아케이드 팀 자동 매칭 | Small | Disabled/ON | 좌측 하단 텍스트 옆 |
| 커스터마이즈 로비 편집 | Medium | Active/ON | 로비 커스텀 이미지 좌측 아래 |
| 상점 로비 구매 | Medium | Disabled/ON | 로비 커스텀 이미지 좌측 아래 |
| 장착스킨 | Large | Disabled/OFF | 밀수품 우측 상단 무기 미리보기 |
| 경쟁전 티어 보상 | Medium | Active/ON | 좌측 하단 텍스트 좌측 |
| 커스터마이즈 외형/은신처 밀수품 | Large | Disabled/ON | 상점 우측 상단 |
| 클랜 받은 초대 | Large | Active/ON | 우측 상단 |

## 자주 쓰는 조합

```json
// Medium 토글 (활성/ON)
{
  "type": "component",
  "component": "SwitchToggle",
  "variant": "Status=Active, Toggle=On, Size=Medium",
  "x": 300, "y": 500,
  "width": 44, "height": 24
}

// Small 토글 (비활성/ON)
{
  "type": "component",
  "component": "SwitchToggle",
  "variant": "Status=Disabled, Toggle=On, Size=Small",
  "x": 300, "y": 540,
  "width": 36, "height": 20
}
```
