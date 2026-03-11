# Scroller (스크롤러)

## 용도
컨텐츠 리스트가 화면에 완전히 보이지 않을 때 사용하는 스크롤 인디케이터.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Orientation | Vertical | 세로형 (컨텐츠 우측 배치) |
| | Horizontal | 가로형 (컨텐츠 하단 배치) |
| Interaction | Normal | 스크롤 위치 표시 (기본) |
| | Hover | 마우스 호버/스크롤 시 밝은색 변경 |

## 규칙 (위키 사양서)

### 공통
- Normal 상태 기본 제공
- 세로형은 컨텐츠 우측, 가로형은 하단에 배치
- 스크롤 길이 및 마진값은 디자이너가 자유롭게 설정

### PC 조작
- 컨텐츠 영역에서 마우스 휠로 스크롤 컨트롤
- Scroll Bar를 클릭-드래그하여 컨트롤

### Console 조작
- 단순 스크롤: R-Stick으로 컨트롤
- 포커싱 스크롤: L-Stick으로 컨텐츠 포커싱 이동
- R-Stick 아이콘은 스크롤러 상단 또는 하단에 표시 (컴포넌트에 미포함, 별도 구현 필요)
- 중복 사용 불가: L-Stick 포커싱 시 R-Stick 아이콘 표시/사용 안 함

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 리스트형 UI | 세로 스크롤러 기본 적용 |
| 가로 나열형 UI | 가로 스크롤러 적용 |

## 자주 쓰는 조합

```json
// 세로 스크롤러
{
  "type": "component",
  "component": "Scroller",
  "variant": "Orientation=Vertical, Interaction=Normal",
  "x": 780, "y": 100,
  "width": 4, "height": 400
}

// 가로 스크롤러
{
  "type": "component",
  "component": "Scroller",
  "variant": "Orientation=Horizontal, Interaction=Normal",
  "x": 100, "y": 580,
  "width": 400, "height": 4
}
```
