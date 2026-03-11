# Dropdowns (드롭다운)

## 용도
드롭다운 셀렉트. 옵션 선택, 정렬 기준, 서버/지역 선택 등.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| State | Default | 닫힌 상태 |
| | Hover | 호버 |
| | Open | 펼쳐진 상태 |
| | Disabled | 비활성 |
| Size | Default | 기본 (높이 40px) |
| | Small | 소형 (높이 32px) |

## 추천 사이즈

| 항목 | 값 |
|------|-----|
| 너비 | 160~320 |
| 높이 (닫힘) | 32~40 |
| 드롭다운 항목 높이 | 36 |

## 색상 정보

```yaml
색상:
  트리거_배경: "#222228"
  트리거_border: "#333340"
  트리거_텍스트: "#eaeaea"
  트리거_placeholder: "#8b8b8b"
  트리거_cornerRadius: 4
  드롭다운_배경: "#1e1e24"
  드롭다운_border: "#2a2a35"
  드롭다운_cornerRadius: 4
  항목_배경_호버: "#2a2a35"
  항목_텍스트: "#eaeaea"
  항목_텍스트_선택: "#f2a900"
  화살표_아이콘: "#8b8b8b"
  fontSize: 13
```

## 규칙 (위키 사양서)

### 구성
- 트리거(선택된 값 표시) + 드롭다운 패널(옵션 목록)
- 우측에 화살표 아이콘 (▼)
- 선택된 옵션은 골드 색상으로 표시

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 전적 | 시즌/모드 필터 |
| 설정 | 해상도, 언어 선택 |
| 사용자 지정 매치 | 맵, 모드 선택 |

## 모사 패턴 (customNodes)

```json
// 닫힌 드롭다운
[
  {
    "name": "드롭다운 트리거",
    "type": "rect",
    "x": 100, "y": 200,
    "width": 200, "height": 40,
    "fill": "#222228",
    "cornerRadius": 4,
    "stroke": "#333340"
  },
  {
    "name": "선택된 값",
    "type": "text",
    "x": 116, "y": 212,
    "width": 152, "height": 16,
    "characters": "시즌 42",
    "fontSize": 13,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#eaeaea"
  },
  {
    "name": "화살표",
    "type": "text",
    "x": 272, "y": 212,
    "width": 16, "height": 16,
    "characters": "▼",
    "fontSize": 10,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#8b8b8b"
  }
]
```
