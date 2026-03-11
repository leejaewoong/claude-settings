# List (리스트)

## 용도
세로 나열 목록. 알림 목록, 설정 항목, 채팅 메시지, 친구 목록 등.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Type | Default | 기본 리스트 |
| | Selectable | 선택 가능한 리스트 |
| Divider | True | 항목 간 구분선 |
| | False | 구분선 없음 |
| Icon | True | 좌측 아이콘 |
| | False | 아이콘 없음 |

## 추천 사이즈

| 항목 | 값 |
|------|-----|
| 너비 | 300~600 |
| 항목 높이 | 44~64 |

## 색상 정보

```yaml
색상:
  배경: "#1e1e24"
  항목_배경_기본: "transparent"
  항목_배경_호버: "#2a2a35"
  항목_배경_선택: "#2a2a35"
  주_텍스트: "#eaeaea"
  보조_텍스트: "#8b8b8b"
  구분선: "#2a2a35"
  항목_padding: "좌우 16px, 상하 12px"
  fontSize:
    주_텍스트: 14
    보조: 12
```

## 규칙 (위키 사양서)

### 구성
- 단일 열 세로 나열
- 항목 간 구분선 선택적
- 스크롤 가능 (항목 많을 때)

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 알림 목록 | 시스템/이벤트 알림 |
| 설정 항목 | 각종 설정 메뉴 |
| 소셜 > 친구 | 친구 목록 |

## 모사 패턴 (customNodes)

```json
// 리스트 (구분선 포함, 3항목)
[
  {
    "name": "리스트 배경",
    "type": "frame",
    "x": 100, "y": 200,
    "width": 400, "height": 180,
    "fill": "#1e1e24",
    "cornerRadius": 4
  },
  {
    "name": "항목1 텍스트",
    "type": "text",
    "x": 116, "y": 216,
    "width": 368, "height": 20,
    "characters": "알림 항목 1",
    "fontSize": 14,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#eaeaea"
  },
  {
    "name": "구분선1",
    "type": "line",
    "x": 116, "y": 256,
    "width": 368, "height": 0,
    "stroke": "#2a2a35"
  },
  {
    "name": "항목2 텍스트",
    "type": "text",
    "x": 116, "y": 272,
    "width": 368, "height": 20,
    "characters": "알림 항목 2",
    "fontSize": 14,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#eaeaea"
  }
]
```
