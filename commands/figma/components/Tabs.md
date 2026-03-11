# Tabs (탭)

## 용도
상단 수평 탭 전환. 콘텐츠 영역 내 카테고리/필터 전환에 사용.

## Variant 속성

### Tab (탭 바 전체)

| 속성 | 값 | 설명 |
|------|-----|------|
| 너비 유형 | Hug width (텍스트 맞춤) | 텍스트 길이에 맞춰 순차 정렬 |
| | Fill Width (너비 분할) | 전체 너비를 탭 수로 균등 분할 |
| 타입 | PC | PC 환경 |
| | Console - Focusing | 콘솔 포커싱 모드 |
| | Console - Key | 콘솔 키 모드 |

### Tab Buttons (개별 탭 버튼)

| 속성 | 값 | 설명 |
|------|-----|------|
| State | Normal | 미선택 |
| | Hover | 호버 |
| | Selected | 선택됨 (하이라이트) |

## 추천 사이즈

| 너비 유형 | 너비 | 높이 |
|-----------|------|------|
| Hug width | 탭 수에 따라 가변 | 44 |
| Fill Width | 콘텐츠 영역 전체 | 44 |

## textOverrides

| 키 | 설명 |
|----|------|
| Tab1, Tab2, Tab3... | 각 탭 텍스트 |

## 적용 장면

- 콘텐츠 영역 상단 필터 (전체/스킨/재화/기타)
- 서브 카테고리 전환 (데일리/위클리/시즌)
- 통계 유형 전환 (솔로/듀오/스쿼드)

## 규칙 (위키 사양서)

### 배치
- 탭 메뉴는 하위 콘텐츠 영역 바로 위에 위치
- 하나의 탭이 항상 선택되어 있어야 함

### 너비 규칙
- **텍스트 너비 맞춤**: 콘텐츠 영역에 크게 적용, 탭 8개 이하 권장 (L10N 고려 유연 조절)
- **가로 너비 맞춤**: 좁은 탭에 적용, L10N 텍스트를 고려하여 버튼 수 지정

### 상태
- Normal, Hover, Selected, Focusing

### 인터랙션
- **PC**: 마우스 호버 + 클릭으로 하위 콘텐츠 교체
- **Console**: LB/RB 또는 LT/RT 키바인딩, L-Stick/D-Pad 포커싱 이동

### 다국어 대응
- 탭 버튼은 텍스트 길이에 대응
- Fill Width 사용 시 L10N 텍스트 길이 검수 필요

### 사운드
- Hover: UI_Common_Hover_Medium
- Click: UI_Common_Click_Confirm

## 적용 케이스 (위키 사양서)

| 피처 | 페이지 | 설명 |
|------|--------|------|
| 제작소 | 오버뷰 | 장인 제작, 제작소 소식, 더 보기 탭 구성 |

## 자주 쓰는 조합

```json
// PC Hug width 탭
{
  "type": "component",
  "component": "Tabs",
  "variant": "너비 유형=Hug width (텍스트 맞춤), 타입=PC",
  "x": 360, "y": 280,
  "width": 480, "height": 44,
  "textOverrides": {
    "Tab1": "전체",
    "Tab2": "스킨",
    "Tab3": "재화",
    "Tab4": "기타"
  }
}

// Fill Width 탭 (균등 분할)
{
  "type": "component",
  "component": "Tabs",
  "variant": "너비 유형=Fill Width (너비 분할), 타입=PC",
  "x": 360, "y": 280,
  "width": 1200, "height": 44,
  "textOverrides": {
    "Tab1": "보상",
    "Tab2": "미션"
  }
}
```
