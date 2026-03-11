# SubCategory (서브 카테고리)

## 용도
하위 카테고리 선택을 위한 태그 형태의 버튼 UI. 카테고리 탐색 보조 필터 역할.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| State | Normal | 기본 상태 (배경 강조 없음) |
| | Hover | 마우스 호버 (회색 배경, 텍스트 검정 반전) |
| | Active | 선택 활성화 (그라데이션 배경) |
| | Inactive | 비활성화 (Opacity 50%, 인터랙션 불가) |
| Content | Text | 텍스트만 표시 |
| | IconText | 아이콘 + 텍스트 (아이콘은 텍스트 앞) |
| | Icon | 아이콘만 표시 |

## textOverrides

| 키 | 설명 |
|----|------|
| Label | 카테고리 텍스트 |

## 규칙 (위키 사양서)

### 수량 규칙
- 최소 2개 이상 노출 필수
- 최대 수량 제한 없음, 디자인 width에 따라 줄바꿈 처리

### 선택 규칙
- 단일 선택만 가능 (복수 선택 불가)

### Divider 규칙
- 태그형 버튼 사이에 구분자 역할
- Active 시 해당 컴포넌트 양쪽의 Divider(라인)는 사라짐

### 너비 설정
- 피쳐 디자인에 따라 가로 길이 유동적으로 조절 가능

### 내부 정보 표기
- 텍스트: 텍스트만 표시
- 아이콘+텍스트: 아이콘은 텍스트 앞 위치, 아이콘 종류 제한 없음
- 아이콘: 아이콘만 표시

## 적용 케이스 (위키 사양서)

| 화면 | 설명 |
|------|------|
| 상점 > 아이템 | |
| 커스터마이즈 > 무기 | |
| 커스터마이즈 > 옷장 | |
| 커스터마이즈 > 이모트 | |
| 커스터마이즈 > 로비 > 스킨편집 | |
| 커스터마이즈 > 탈 것 | |
| 제작소 > 특수제작 | |
| 커스터마이즈 > 무기 > 참 | Inactive 상태 사용 |

## 자주 쓰는 조합

```json
// 텍스트 서브 카테고리 (활성)
{
  "type": "component",
  "component": "SubCategory",
  "variant": "State=Active, Content=Text",
  "x": 100, "y": 120,
  "width": 80, "height": 32,
  "textOverrides": { "Label": "전체" }
}

// 텍스트 서브 카테고리 (일반)
{
  "type": "component",
  "component": "SubCategory",
  "variant": "State=Normal, Content=Text",
  "x": 184, "y": 120,
  "width": 80, "height": 32,
  "textOverrides": { "Label": "상의" }
}

// 아이콘+텍스트 서브 카테고리
{
  "type": "component",
  "component": "SubCategory",
  "variant": "State=Normal, Content=IconText",
  "x": 268, "y": 120,
  "width": 100, "height": 32,
  "textOverrides": { "Label": "돌격소총" }
}
```
