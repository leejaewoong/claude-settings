# SideTab (사이드 탭)

## 용도
좌측 수직 사이드 탭. 패널 네비게이션, 카테고리 사이드 메뉴 등.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| State | Normal | 미선택 |
| | Hover | 호버 |
| | Selected | 선택됨 |
| | Disabled | 비활성 |
| Icon | True | 아이콘 표시 |
| | False | 텍스트만 |

## 추천 사이즈

| 항목 | 값 |
|------|-----|
| 탭 너비 | 200~280 |
| 탭 높이 | 40~48 |
| 패널 전체 높이 | 콘텐츠 영역 높이 |

## 색상 정보

```yaml
색상:
  패널_배경: "#1a1a22"
  탭_배경_기본: "transparent"
  탭_배경_호버: "#222228"
  탭_배경_선택: "#2a2a35"
  선택_인디케이터: "#f2a900"  # 좌측 3px 세로 바
  선택_인디케이터_width: 3
  텍스트_기본: "#8b8b8b"
  텍스트_선택: "#eaeaea"
  텍스트_비활성: "#555555"
  구분선: "#2a2a35"
  padding: "좌 16px, 우 12px"
  fontSize: 14
```

## 규칙 (위키 사양서)

### 구성
- 세로 방향 탭 목록
- 선택 상태는 좌측 골드 인디케이터 바로 표시
- 아이콘 + 텍스트 또는 텍스트만

### 배치
- 콘텐츠 영역 좌측에 고정
- 너비 고정, 높이는 콘텐츠에 따라

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 커스터마이즈 | 장비 카테고리 (상의/하의/모자 등) |
| 설정 | 설정 카테고리 (그래픽/사운드/조작 등) |
| 상점 | 상품 카테고리 |

## 모사 패턴 (customNodes)

```json
// 사이드 탭 (3항목, 첫 번째 선택)
[
  {
    "name": "사이드 탭 패널",
    "type": "frame",
    "x": 0, "y": 168,
    "width": 240, "height": 856,
    "fill": "#1a1a22"
  },
  {
    "name": "선택 인디케이터",
    "type": "rect",
    "x": 0, "y": 168,
    "width": 3, "height": 44,
    "fill": "#f2a900"
  },
  {
    "name": "탭1 배경 (선택)",
    "type": "rect",
    "x": 0, "y": 168,
    "width": 240, "height": 44,
    "fill": "#2a2a35"
  },
  {
    "name": "탭1 텍스트",
    "type": "text",
    "x": 20, "y": 180,
    "width": 200, "height": 20,
    "characters": "전체",
    "fontSize": 14,
    "fontFamily": "Inter",
    "fontStyle": "Bold",
    "fill": "#eaeaea"
  },
  {
    "name": "탭2 텍스트",
    "type": "text",
    "x": 20, "y": 224,
    "width": 200, "height": 20,
    "characters": "스킨",
    "fontSize": 14,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#8b8b8b"
  },
  {
    "name": "탭3 텍스트",
    "type": "text",
    "x": 20, "y": 268,
    "width": 200, "height": 20,
    "characters": "재화",
    "fontSize": 14,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#8b8b8b"
  }
]
```
