# TextInput (텍스트 인풋)

## 용도
텍스트 입력 필드. 검색 바, 닉네임 입력, 채팅 입력.

## Variant 속성

| 속성 | 값 | 설명 |
|------|-----|------|
| Size | Default | 기본 (높이 44px) |
| | Large | 대형 (높이 54px) |
| State | Normal | 기본 |
| | Hover | 호버 |
| | Focus | 포커스 (콘솔 대응) |
| | Click(입력 중) | 입력 중 상태 |

## 추천 사이즈

| Size | 너비 | 높이 |
|------|------|------|
| Default | 200~344 | 44 |
| Large | 400~600 | 54 |

## textOverrides

| 키 | 설명 |
|----|------|
| Placeholder | 플레이스홀더 텍스트 |
| Value | 입력된 값 |

## 규칙 (위키 사양서)

### 타입
- **일반 입력**: 쿠폰 번호, 닉네임 변경, 패스워드, 세션명 입력
- **검색 입력**: 닉네임 검색, 세션명 검색

### 구성 요소
- 텍스트 입력 영역 + 리셋 아이콘 + Placeholder 기본 구성
- 타입에 따라 검색 아이콘 추가

### 인터랙션
- **PC**: Hover → UI 피드백 표시, Click → 커서 활성화, 리셋 아이콘 클릭으로 초기화
- **Console**: Focusing 후 플랫폼 텍스트 입력창 호출, 키 바인딩 가능

### 다국어 대응
- 긴 텍스트 입력 시 입력창 우측 정렬

### 추가 Property (위키)
| 속성 | 값 | 기본값 | 설명 |
|------|-----|--------|------|
| 입력글 | True/False | False | 입력창 내 선명한 문구 유무 |
| 플레이스홀더 | True/False | False | 입력창 내 흐릿한 문구 유무 |
| 리셋 아이콘 | True/False | True | 입력 텍스트 제거 버튼 유무 |
| 서치 아이콘 | True/False | True | 입력창 내 검색 아이콘 유무 |

### 사운드
- Hover/Focusing: UI_Common_Hover_Medium
- Click: UI_Common_Click_Confirm
