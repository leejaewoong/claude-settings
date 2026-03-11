# ItemSlot (아이템 슬롯)

## 용도
아이템/보상/인벤토리 카드 슬롯. 보상 그리드, 상점 아이템, 장비 슬롯 등.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| 등급 | Classic | 일반 등급 (회색) |
| | Rare | 희귀 등급 (파랑) |
| | Epic | 영웅 등급 (보라) |
| | Legendary | 전설 등급 (골드) |
| | Mythic | 신화 등급 |
| Type | Default | 기본 상태 (획득 가능) |
| | Select | 선택됨 (강조 표시) |
| | Acquired | 획득 완료 (딤 처리) |
| | Locked | 잠김 (접근 불가) |
| Size (변경 금지) | Small (40-89) | 소형 슬롯 |
| | Middle (90-200) | 중형 슬롯 |
| | Large (201-350) | 대형 슬롯 |

## 등급별 색상

```yaml
등급_색상:
  Classic:
    stroke: "#8b8b8b"
    text: "#8b8b8b"
    fill: "#1e1e24"
  Rare:
    stroke: "#4fc3f7"
    text: "#4fc3f7"
    fill: "#1e1e24"
  Epic:
    stroke: "#ab47bc"
    text: "#ab47bc"
    fill: "#1e1e24"
  Legendary:
    stroke: "#f2a900"
    text: "#f2a900"
    fill: "#1e1e24"
  Mythic:
    stroke: "#ff5252"
    text: "#ff5252"
    fill: "#1e1e24"
```

## 상태별 스타일

```yaml
상태_스타일:
  Default:
    strokeWidth: 1
    overlay: 없음
  Select:
    strokeWidth: 2
    overlay: 없음
    참고: "선택된 슬롯은 더 굵은 border로 강조"
  Acquired:
    strokeWidth: 1
    overlay: "fill=#000000, opacity=0.4"
    체크마크: "✓ 텍스트, fill=#5a9a6a, fontSize=20~24"
  Locked:
    strokeWidth: 1
    overlay: "fill=#000000, opacity=0.6"
    잠금: "🔒 또는 자물쇠 아이콘"
```

## 규칙 (위키 사양서)

### 그리드 배치
- 아이템 슬롯 간 간격: 12~16px
- 행 간 간격: 12~16px
- 5열 그리드 기준 Middle 사이즈: 174×210px (12px gap)

### 아이템 이미지
- 슬롯 내부에 아이템 이미지가 차지하는 영역은 padding 8px 적용

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 커스터마이즈 인벤토리 | 장비 슬롯 그리드 |
| 제작소 | 재료/결과 아이템 표시 |
| 상점 아이템 목록 | 구매 가능 아이템 |
| 패스 보상 | 보상 그리드 (구간별) |
| 은신처 | 인벤토리 슬롯 |

## 모사 패턴 (customNodes)

```json
// 아이템 슬롯 (Acquired, Classic) — 획득 완료
[
  {
    "name": "ItemSlot — Classic, Acquired",
    "type": "frame",
    "x": 100, "y": 100,    
    "fill": "#1e1e24",
    "cornerRadius": 4,
    "stroke": "#8b8b8b"
  },
  {
    "name": "ItemSlot — Acquired 오버레이",
    "type": "rect",
    "x": 100, "y": 100,    
    "fill": "#000000",
    "opacity": 0.4,
    "cornerRadius": 4
  },
  {
    "name": "ItemSlot — 체크",
    "type": "text",
    "x": 166, "y": 178,
    "width": 40, "height": 40,
    "characters": "✓",
    "fontSize": 24,
    "fontFamily": "Inter",
    "fontStyle": "Bold",
    "fill": "#5a9a6a",
    "textAlignHorizontal": "CENTER"
  }
]
```
