# PageControl (페이지 컨트롤)

## 용도
페이지네이션. 그리드/리스트 하단 페이지 표시, 슬라이드 인디케이터.

## 구성 요소

| 요소 | 설명 |
|------|------|
| Page indicator | 점(dot) 형태 인디케이터 |
| Pagination | 숫자 페이지네이션 |
| Page stepper | 좌/우 화살표 + 페이지 번호 |

### Page stepper 사이즈

| Size | 최소 너비 | 높이 | 간격 |
|------|-----------|------|------|
| Small | 108 | 24 | 6px |
| Default | 140 | 32 | 8px |
| Large | 176 | 44 | 10px |

### Page stepper buttons

| 속성 | 값 | 설명 |
|------|-----|------|
| State | Normal | 기본 |
| | Hover | 호버 |
| | Console | 콘솔 모드 |

### Disabled 규칙

- 첫 페이지: 좌측 화살표 Disabled
- 마지막 페이지: 우측 화살표 Disabled
- 1페이지 이하: 양쪽 모두 Disabled

## 추천 사이즈

| 요소 | 너비 | 높이 |
|------|------|------|
| Page indicator (Dot) | 페이지 수 x 20 | 20 |
| Pagination (Number) | 80~120 | 28~32 |
| Page stepper (Arrow) | 140~176 | 32~44 |

## 적용 장면

- 보상 그리드 하단 (3/10 페이지)
- 배너 슬라이드 인디케이터
- 테이블 하단 페이지네이션

## 자주 쓰는 조합

```json
// Page stepper (Default)
{
  "type": "component",
  "component": "PageControl",
  "variant": "Default",
  "x": 800, "y": 940,
  "width": 160, "height": 32
}
```

## 규칙 (위키 사양서)

### Page Button (페이지 인디케이터)
- 한 페이지만 있으면 미표시
- 2개 이상 콘텐츠를 순차 표시할 때 사용
- 콘텐츠 영역 내부 상하좌우 모서리에 자유 배치
- 가능한 8개 이상 초과하지 않음
- 자동 롤링 적용 가능
- **PC**: 버튼 클릭으로 페이지 교체
- **Console**: R스틱 바인딩으로 조작

### Pagination (숫자 페이지네이션)
- 한 페이지만 있으면 미표시
- 최대 10개 페이지를 한 화면에 표시
- 첫/마지막 페이지에서 해당 방향 화살표 Disabled
- **Previous & Next**: Normal, Hover, Disabled
- **Page Number**: Normal, Hover, Selected
- 숫자 가로 너비에 맞게 전체 길이 가변
- **PC**: 클릭으로 페이지 전환
- **Console**: L/R 스틱 좌우로 이동

### Page Stepper (화살표 스테퍼)
- 상하/좌우 조작 2종류
- 숫자 표시/생략 가능
- 첫/마지막 페이지 첨단에서 해당 방향 화살표 Disabled
- 페이지 1개일 때 전체 Disabled
- **PC**: 화살표 Click, Disabled 상태는 Hover 불가
- **Console**: R Stick 또는 L/R Trigger로 조작

## 적용 케이스 (위키 사양서)

### Page Button
| 화면 | 설명 |
|------|------|
| 뉴스 | Hero/Promotion 캐러셀 |
| 스토어 | Featured 페이지 캐러셀 |
| 이미지 모달 | 로비 진입 모달 |

### Pagination
| 화면 | 설명 |
|------|------|
| 전적 > 통계 > 순위표 | |
| 플레이 > 사용자 지정 | |

### Page Stepper
| 화면 | 설명 |
|------|------|
| 플레이 | 게임 유형 탐색 |
| 소셜 | 친구 리스트 탐색 |
| 패스 | 보상 탭 탐색 |
