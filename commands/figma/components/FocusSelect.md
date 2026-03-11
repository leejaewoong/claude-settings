# FocusSelect (포커스 셀렉트)

## 용도
포커스 기반 셀렉트. 콘솔 환경의 옵션 선택, 키보드 네비게이션 셀렉트 등.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| State | Default | 기본 |
| | Focused | 포커스됨 |
| | Selected | 선택됨 |
| | Disabled | 비활성 |
| Size | Default | 기본 (높이 44px) |
| | Small | 소형 (높이 36px) |

## 추천 사이즈

| Size | 너비 | 높이 |
|------|------|------|
| Default | 200~400 | 44 |
| Small | 160~300 | 36 |

## 색상 정보

```yaml
색상:
  배경_기본: "#222228"
  배경_포커스: "#2a2a35"
  배경_선택: "#2a2a35"
  border_기본: "#333340"
  border_포커스: "#f2a900"
  border_선택: "#f2a900"
  텍스트: "#eaeaea"
  텍스트_비활성: "#555555"
  cornerRadius: 4
  화살표: "#8b8b8b"
  padding: "좌우 16px"
  fontSize: 14
```

## 규칙 (위키 사양서)

### 용도
- 콘솔 환경에서 포커스 이동으로 옵션 탐색
- 선택 시 골드 border로 강조

### 인터랙션
- D-Pad/L-Stick으로 포커스 이동
- A 버튼으로 선택/확인

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 설정 | 콘솔 환경 옵션 선택 |
| 사용자 지정 매치 | 맵/모드 선택 |

## 모사 패턴 (customNodes)

```json
// 포커스 셀렉트 (Focused 상태)
[
  {
    "name": "FocusSelect 배경",
    "type": "rect",
    "x": 100, "y": 200,
    "width": 280, "height": 44,
    "fill": "#2a2a35",
    "cornerRadius": 4,
    "stroke": "#f2a900"
  },
  {
    "name": "선택된 값",
    "type": "text",
    "x": 116, "y": 214,
    "width": 220, "height": 16,
    "characters": "옵션 A",
    "fontSize": 14,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#eaeaea"
  },
  {
    "name": "화살표",
    "type": "text",
    "x": 348, "y": 214,
    "width": 16, "height": 16,
    "characters": "▼",
    "fontSize": 10,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#8b8b8b"
  }
]
```
