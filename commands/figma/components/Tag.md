# Tag (태그)

## 용도
라벨, 뱃지, 카테고리 표시. 아이템 등급, 상태 표시, 필터 칩 등.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Type | Yellow | 골드/프리미엄/전설 등급 |
| | Red | 긴급/HOT/NEW |
| | Purple | 에픽/영웅 등급 |
| | Blue | 정보/희귀 등급 |
| | Black | 다크/기본 |
| | White | 밝은/일반 |
| | Bonus | 보너스 표시 |
| | Premium | 프리미엄 전용 |
| | beta | 베타 표시 |
| Size | Xsmall | 초소형 |
| | Small | 소형 |
| | Default (medium) | 기본 |
| | Large | 대형 |
| | Xlarge | 초대형 |
| Icon | True | 아이콘 표시 |
| | False | 텍스트만 |

## 추천 사이즈

| Size | 너비 | 높이 |
|------|------|------|
| Xsmall | 32~48 | 16~18 |
| Small | 48~60 | 18~20 |
| Default (medium) | 60~100 | 20~24 |
| Large | 80~120 | 24~28 |
| Xlarge | 100~160 | 28~32 |

## textOverrides

| 키 | 설명 |
|----|------|
| Label | 태그 텍스트 |

## 등급 매핑

```yaml
아이템_등급:
  일반: "Type=White"
  희귀: "Type=Blue"
  영웅/에픽: "Type=Purple"
  전설/레전더리: "Type=Yellow"
  한정: "Type=Red"

상태_표시:
  NEW: "Type=Red"
  HOT: "Type=Red"
  PREMIUM: "Type=Premium"
  BONUS: "Type=Bonus"
  FREE: "Type=Black"
  완료: "Type=Blue"
  BETA: "Type=beta"
```

## 규칙 (위키 사양서)

### 텍스트
- 최대 두 단어까지 노출 권장

### 사이즈
- 높이: 텍스트 높이에 따라 가변
- 너비: 텍스트 길이에 따라 가변

### 아이콘
- Icon=True 시 기존에 생성된 아이콘 모두 사용 가능

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 커스터마이즈 - 로비 | |
| 제작소 - 일반제작 - 열기 결과 | |
| Lobby 패스 배너 | X Small / Premium 컬러 |
| Pass - Survivor | 오버뷰/리워드/미션 HUD 영역, Default/Premium 컬러 |
| Pass - Crafter | 리워드/미션 HUD 영역, 시즌/업적 미션 프리미엄 태그 |

## 자주 쓰는 조합

```json
// PREMIUM 태그
{
  "type": "component",
  "component": "Tag",
  "variant": "Type=Premium, Size=Default (medium), Icon=False",
  "x": 360, "y": 430,
  "width": 80, "height": 24,
  "textOverrides": { "Label": "PREMIUM" }
}

// NEW 뱃지
{
  "type": "component",
  "component": "Tag",
  "variant": "Type=Red, Size=Small, Icon=False",
  "x": 520, "y": 300,
  "width": 48, "height": 20,
  "textOverrides": { "Label": "NEW" }
}
```
