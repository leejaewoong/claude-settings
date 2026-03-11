# MissionList (미션 리스트)

## 용도
미션/퀘스트 전용 목록. 데일리/위클리 미션, 업적 목록, 진행도가 있는 목표 표시.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Type | Daily | 데일리 미션 |
| | Weekly | 위클리 미션 |
| | Achievement | 업적/도전 과제 |
| State | Active | 진행 중 |
| | Completed | 완료 |
| | Locked | 잠김 |

## 추천 사이즈

| 항목 | 값 |
|------|-----|
| 너비 | 400~800 |
| 항목 높이 | 60~80 |
| 진행바 높이 | 4~6 |

## 색상 정보

```yaml
색상:
  배경: "#1e1e24"
  항목_배경: "#222228"
  항목_배경_완료: "#1e2a1e"
  항목_배경_잠김: "#1a1a1a"
  미션명: "#eaeaea"
  미션_설명: "#8b8b8b"
  진행_텍스트: "#8b8b8b"
  진행바_배경: "#2a2a32"
  진행바_채움: "#f2a900"
  진행바_완료: "#5a9a6a"
  보상_금액: "#f2a900"
  잠김_오버레이: "fill=#000000, opacity=0.4"
  항목_cornerRadius: 4
  항목_padding: "좌우 16px, 상하 12px"
  항목_gap: 8
  fontSize:
    미션명: 14
    설명: 12
    진행: 11
```

## 규칙 (위키 사양서)

### 구성
- 미션명 + 설명 + 진행바 + 보상 정보
- 완료된 미션은 체크 표시 + 딤 처리
- 잠긴 미션은 자물쇠 + 딤 처리

### 진행바
- 가로 진행바로 진행 상태 시각화
- 완료 시 색상 변경 (골드 → 녹색)

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 패스 > 미션 | 데일리/위클리 미션 목록 |
| 업적 | 도전 과제 목록 |
| 이벤트 | 이벤트 미션 목록 |

## 모사 패턴 (customNodes)

```json
// 미션 항목 (진행 중, 진행바 포함)
[
  {
    "name": "미션 항목 배경",
    "type": "rect",
    "x": 100, "y": 200,
    "width": 600, "height": 72,
    "fill": "#222228",
    "cornerRadius": 4
  },
  {
    "name": "미션명",
    "type": "text",
    "x": 116, "y": 212,
    "width": 400, "height": 20,
    "characters": "적 10명 처치",
    "fontSize": 14,
    "fontFamily": "Inter",
    "fontStyle": "Bold",
    "fill": "#eaeaea"
  },
  {
    "name": "미션 설명",
    "type": "text",
    "x": 116, "y": 234,
    "width": 400, "height": 16,
    "characters": "매치에서 적 10명을 처치하세요",
    "fontSize": 12,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#8b8b8b"
  },
  {
    "name": "진행바 배경",
    "type": "rect",
    "x": 116, "y": 256,
    "width": 400, "height": 4,
    "fill": "#2a2a32",
    "cornerRadius": 2
  },
  {
    "name": "진행바 채움 (60%)",
    "type": "rect",
    "x": 116, "y": 256,
    "width": 240, "height": 4,
    "fill": "#f2a900",
    "cornerRadius": 2
  },
  {
    "name": "진행 텍스트",
    "type": "text",
    "x": 530, "y": 248,
    "width": 60, "height": 14,
    "characters": "6/10",
    "fontSize": 11,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#8b8b8b",
    "textAlignHorizontal": "RIGHT"
  },
  {
    "name": "보상 금액",
    "type": "text",
    "x": 620, "y": 220,
    "width": 60, "height": 20,
    "characters": "+50",
    "fontSize": 14,
    "fontFamily": "Inter",
    "fontStyle": "Bold",
    "fill": "#f2a900",
    "textAlignHorizontal": "RIGHT"
  }
]
```
