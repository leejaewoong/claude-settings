# Table (테이블)

## 용도
구조화된 데이터 테이블. 랭킹, 통계 비교, 매치 히스토리, 설정 항목 등.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Type | Default | 기본 테이블 |
| | Ranking | 랭킹 테이블 |
| | Stats | 통계 테이블 |
| Header | True | 헤더 행 표시 |
| | False | 헤더 없음 |
| Zebra | True | 줄무늬 (홀짝 색 구분) |
| | False | 단색 배경 |

## 추천 사이즈

| 항목 | 값 |
|------|-----|
| 너비 | 400~1200 |
| 행 높이 | 40~52 |
| 헤더 높이 | 44~52 |

## 색상 정보

```yaml
색상:
  헤더_배경: "#222228"
  헤더_텍스트: "#8b8b8b"
  행_배경_홀: "#1a1a22"
  행_배경_짝: "#1e1e24"
  행_텍스트: "#eaeaea"
  보조_텍스트: "#8b8b8b"
  구분선: "#2a2a35"
  하이라이트_행: "#2a2a35"
  셀_padding: "좌우 16px"
  fontSize:
    헤더: 12
    본문: 13
```

## 규칙 (위키 사양서)

### 구성
- 헤더 + 데이터 행으로 구성
- 셀 간 구분선은 세로 기준
- 정렬: 텍스트=좌측, 숫자=우측

### 스크롤
- 행이 많을 경우 세로 스크롤
- 헤더는 고정(sticky)

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 전적 > 매치 히스토리 | 매치 결과 목록 |
| 전적 > 무기 통계 | 무기별 킬/명중률 |
| 랭킹 | 시즌/전체 랭킹 |

## 모사 패턴 (customNodes)

```json
// 3열 테이블 (헤더 + 데이터 3행)
[
  {
    "name": "테이블 헤더 배경",
    "type": "rect",
    "x": 100, "y": 200,
    "width": 800, "height": 44,
    "fill": "#222228"
  },
  {
    "name": "헤더 Col1",
    "type": "text",
    "x": 116, "y": 214,
    "width": 200, "height": 16,
    "characters": "이름",
    "fontSize": 12,
    "fontFamily": "Inter",
    "fontStyle": "Bold",
    "fill": "#8b8b8b"
  },
  {
    "name": "헤더 Col2",
    "type": "text",
    "x": 400, "y": 214,
    "width": 200, "height": 16,
    "characters": "킬",
    "fontSize": 12,
    "fontFamily": "Inter",
    "fontStyle": "Bold",
    "fill": "#8b8b8b",
    "textAlignHorizontal": "RIGHT"
  },
  {
    "name": "행1 배경",
    "type": "rect",
    "x": 100, "y": 244,
    "width": 800, "height": 44,
    "fill": "#1a1a22"
  },
  {
    "name": "행1 Col1",
    "type": "text",
    "x": 116, "y": 258,
    "width": 200, "height": 16,
    "characters": "Player1",
    "fontSize": 13,
    "fontFamily": "Inter",
    "fontStyle": "Regular",
    "fill": "#eaeaea"
  }
]
```
