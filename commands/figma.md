# /figma — BETTERGROUND Figma 시안 자동 생성

BETTERGROUND 프로덕트 스타일에 맞는 Figma 시안을 자동으로 생성하는 커맨드.
ORDO Design System + 기존 화면 스크린샷을 조합하여 HTML을 생성하고 Figma 파일로 캡처한다.

---

## 고정 설정값

```yaml
SCREENSHOTS_DIR: "C:\Users\jaewoong\Desktop\PUBG 스크린샷"
DS_FILE: "ORDO Design System"
OUTPUT_WIDTH: "1920px"
OUTPUT_HIGHT: "1080px"
THEME: "dark"
FIGMA_DELAY: 3000
```

## Figma DS URL 설정

```yaml
DS_FILE_KEY: "c8Qux8CARpdsaKg1KsUwMm"
DS_URL: "https://figma.com/design/c8Qux8CARpdsaKg1KsUwMm/-공통--ORDO-Design-system"

DS_PAGES:

  # ── Foundation ──
  Color:
    페이지명: "✦ Color"
    한글: "컬러"
    node-id: "172:643"
    용도: "컬러 토큰, 시맨틱 컬러, 팔레트"
  Effect:
    페이지명: "✦ Effect"
    한글: "이펙트"
    node-id: "6137:12494"
    용도: "그림자, 블러, 그래디언트"
  Iconography:
    페이지명: "✦ Iconnography"
    한글: "아이콘"
    node-id: "386:446"
    용도: "아이콘 세트, 키 아이콘"
  Typography:
    페이지명: "✦ Typography"
    한글: "타이포그래피"
    node-id: "2057:4459"
    용도: "폰트 스타일, 사이즈 체계"

  # ── Components ──
  CoachMark:
    페이지명: "✦ Coach mark"
    한글: "코치 마크"
    node-id: "386:1063"
  ContentSwitch:
    페이지명: "✦ Content switch"
    한글: "콘텐츠 스위치"
    node-id: "386:443"
  ContextMenu:
    페이지명: "✦ Context menu"
    한글: "컨텍스트 메뉴"
    node-id: "5567:11260"
  Dropdowns:
    페이지명: "✦ Dropdowns"
    한글: "드롭다운"
    node-id: "386:673"
  FilterPopup:
    페이지명: "✦ Filter Popup"
    한글: "필터팝업"
    node-id: "49564:7895"
  Flag:
    페이지명: "✦ Flag"
    한글: "플래그"
    node-id: "2594:24"
  HoverButton:
    페이지명: "✦ Hover Button"
    한글: "호버 버튼"
    node-id: "35881:13527"
  ItemSlot:
    페이지명: "✦ Item slot"
    한글: "아이템 슬롯 V2"
    node-id: "48549:17288"
  List:
    페이지명: "✦ List"
    한글: "리스트"
    node-id: "5607:11867"
  Loading:
    페이지명: "✦ Loading"
    한글: "로딩"
    node-id: "15970:42268"
  MissionList:
    페이지명: "✦ Mission List"
    한글: "미션 리스트"
    node-id: "44429:57242"
  Modals:
    페이지명: "✦ Modals"
    한글: "모달 (템플릿)"
    node-id: "386:1064"
  NotiMarker:
    페이지명: "✦ Noti marker"
    한글: "노티 마커"
    node-id: "386:1058"
  PageControl:
    페이지명: "✦ Page control"
    한글: "페이지 컨트롤"
    node-id: "2698:4659"
  PUBGID:
    페이지명: "✦ PUBG ID"
    한글: "펍지 아이디"
    node-id: "49066:597"
  Scroller:
    페이지명: "✦ Scroller"
    한글: "스크롤러"
    node-id: "386:1060"
  SideTab:
    페이지명: "✦ Side tab"
    한글: "사이드 탭"
    node-id: "2849:5445"
  SquareButton:
    페이지명: "✦ Square Button"
    한글: "스퀘어 버튼 V2"
    node-id: "50011:1002"
  SystemMessage:
    페이지명: "✦ System Message"
    한글: "시스템 메세지"
    node-id: "386:1061"
  Table:
    페이지명: "✦ Table"
    한글: "테이블 V2"
    node-id: "50457:10258"
  Tabs:
    페이지명: "✦ Tabs"
    한글: "탭"
    node-id: "386:674"
  Tag:
    페이지명: "✦ Tag"
    한글: "태그"
    node-id: "10474:20195"
  TextInput:
    페이지명: "✦ Text input"
    한글: "텍스트 인풋"
    node-id: "2838:5442"
  TimeIndicator:
    페이지명: "✦ Time indicator"
    한글: "타임 인디케이터 V2"
    node-id: "48986:4736"
  Toggle:
    페이지명: "✦ Toggle"
    한글: "토글"
    node-id: "51130:18900"
  Tooltip:
    페이지명: "✦ Tooltips"
    한글: "툴팁"
    node-id: "386:1059"
```

> **팀 공유 전환 시**: SCREENSHOTS_DIR을 프로젝트 폴더 내 경로로 변경
> 예: `./assets/screenshots` 또는 `../../design-references/screenshots`

## 레이아웃 컴포넌트 (GNB / LNB / FOOTER)

```yaml
LAYOUT_COMPONENTS:

  GNB:
    설명: "글로벌 헤더 (로고 + GNB 탭 + 글로벌 아이콘 + 재화)"
    fileKey: "c8Qux8CARpdsaKg1KsUwMm"
    node-id: "50478:11684"
    크기: "1920px x 72px (+ Currency 바 52px)"
    포함요소:
      - PUBG 로고 (좌측)
      - GNB 탭 (중앙): 플레이, 패스, 전적, 커스터마이즈, 은신처, 제작소, 상점 등
      - 글로벌 아이콘 (우측): OES, 뉴스, 알림센터, 설정
      - 재화 표시: G-COIN, BP, Plus 상태
    캐시_경로: "./figma-mockups/_shared/gnb.html"
    가이드: "https://ordo.pubg.com/6becdc2a4/p/19c570-global-header"

  LNB:
    설명: "로컬 네비게이션 바 (메뉴별 하위 탭)"
    fileKey: "c8Qux8CARpdsaKg1KsUwMm"
    node-id: "50478:11706"
    크기: "가변 너비, 탭 개수에 따라"
    포함요소:
      - 탭 버튼 (Normal/Selected 상태)
      - 키보드 단축키 표시 (A/D)
    캐시_경로: "./figma-mockups/_shared/lnb.html"
    참고: "탭 텍스트는 Phase 1에서 확정된 메뉴의 2뎁스 항목으로 동적 교체"

  FOOTER:
    설명: "하단 푸터 (액션 버튼 + 소셜 그룹)"
    fileKey: "IbLDVPfcTP8KedJzt5olZw"
    node-id: "5647:1007"
    크기: "1920px x 56px"
    포함요소:
      좌측_버튼그룹:
        - ESC (닫기)
        - Primary 버튼 (최대 1개)
        - Secondary 버튼 (최대 4개)
      우측_소셜그룹:
        - 클랜
        - 소셜 (친구 수)
        - 팀 슬롯 (최대 4인)
        - 팀 파인더
        - 채팅 위젯
    캐시_경로: "./figma-mockups/_shared/footer.html"
    가이드: "https://ordo.pubg.com/6becdc2a4/p/12c87d-footer"

  캐시_관리:
    최초_생성: |
      1. mcp__figma__get_design_context로 각 컴포넌트 추출
      2. React+Tailwind 코드를 순수 HTML+CSS로 변환
      3. ./figma-mockups/_shared/ 에 저장
    갱신_시점:
      - DS 업데이트 후 사용자가 요청할 때
      - 캐시 파일이 없을 때 (최초 실행)
    갱신_방법: "사용자가 '레이아웃 갱신' 요청 시 MCP 재추출 → 캐시 덮어쓰기"
```

---

## 스크린샷 파일명 컨벤션

```yaml
형식: "{1뎁스}_{2뎁스}_{3뎁스}.png"
구분자: "_" (언더스코어)
문자: 한글 메뉴명, 공백/특수문자 제거
확장자: ".png"
```

**예시:**
```
전적_개요.png
전적_매치히스토리_개요.png
전적_매치히스토리_무기.png
플레이_경쟁_솔로.png
커스터마이즈_캐릭터_옷장.png
기타_팝업_구매.png
```

---

## 메뉴 구조 (스크린샷 기반)

```yaml
메뉴_트리:
  플레이:
    - 일반 (하위: 연승 도전 → 규칙/매치 결과)
    - 경쟁 (하위: 솔로/듀오)
    - 경쟁전 (하위: 경쟁전 보상 → 티어 보상/플레이 포인트 보상/경쟁전에 대하여)
    - 아케이드 (하위: 인텐스 배틀로얄/팀 데스매치)
    - 훈련
    - 맵 선택
    - 사용자 지정 (하위: 대기실 생성)
  패스:
    - 제작소 패스 미션 (하위: 대시보드/데일리/위클리/시즌/업적)
    - 제작소 패스 보상
  전적:
    - 개요 (하위: 생존 레벨 보상, 평판 레벨)
    - 프로필 (하위: 개요, 통계, 프로필 편집)
    - 매치 히스토리 (하위: 매치 리포트 → 개요/무기/통계/2D 리플레이)
    - 통계 (하위: 경쟁)
    - 무기 (하위: 모든 매치)
    - 메달
    - 다시 보기  
  커스터마이즈:
    - 캐릭터 (하위: 옷장/외형/포즈)
    - 무기 (하위: 스킨/무기 참)
    - 탈 것 (하위: 스킨 편집)
    - 로비
    - 유틸리티
    - 이모트 및 스프레이
  은신처:
    - 무기
    - 밀수품
    - 분해
    - 스크랩 브로커
  제작소:
    - 개요 (하위: 더 보기)
    - 일반 제작 (하위: 열기/제작)
    - 특수 제작
    - 컨텐더 (하위: 컨텐더 룸 → 퍼스널라이즈/업그레이드)
  상점:
    - 아이템
    - 추천
    - G-COIN
    - 스텝 업
  뉴스:
    - 최신 뉴스
    - 패치 노트  
  소셜:
    - 친구
    - 설정
  클랜:
    - 클랜원 (하위: 클랜원 순위/클랜원 활동)
    - 소식
    - 챌린지
    - 검색 (하위: 검색 결과)
    - 관리
    - 교환소 (하위: 상점)
    - 안내 (하위: 클랜 가이드/클랜 태그)
    - 초대 (하위: 클랜으로 초대하기)        
  시스템_메뉴:
    - 키가이드
    - 환경설정
  기타:
    - 알림
    - 팝업 (하위: 구매/필터/마스터리 티어/PC방 혜택/2차 비밀번호 재설정/보너스기프트 코드 등록)
```

---

## 실행 절차

커맨드 `/figma`가 호출되면 아래 절차를 순서대로 따른다.

---

### Phase 1: 대화로 화면 확정

**규칙:**
- 매 질문마다 선택지를 번호 목록으로 제시한다
- 선택지 마지막에는 항상 **"N. 신규 화면"** 을 포함한다
- 사용자가 번호 또는 텍스트로 답하면 다음 뎁스로 진행한다
- 더 이상 하위 뎁스가 없거나 사용자가 "이걸로 확정"하면 Phase 2로 넘어간다
- 신규 화면 선택 시 화면 이름과 목적을 자유 입력 받는다

**Q1 — 1뎁스 메뉴 선택:**

```
어떤 메뉴의 화면인가요?

1. 플레이
2. 패스
3. 전적
4. 커스터마이즈
5. 은신처
6. 제작소
7. 상점
8. 소셜
9. 클랜
10. 뉴스
11. 시스템 메뉴
12. 기타 (알림, 팝업 등)
13. 신규 화면
```

**Q2 — 2뎁스 선택 (선택된 1뎁스 기준으로 동적 구성):**

```
[1뎁스명]의 어떤 화면인가요?

1. [2뎁스 항목들...]
N. 신규 화면
```

**Q3 — 3뎁스 이상 (하위 항목이 있을 경우에만):**

```
더 구체적인 화면이 있나요?

1. [3뎁스 항목들...]
N. 이 화면으로 확정
```

**Q4 — 추가 요구사항:**

```
화면에 대해 추가로 알려줄 내용이 있나요?
(필요한 컴포넌트, 데이터 구조, 특이사항 등 자유롭게 입력. 없으면 엔터)
```

**Q5 — 레이아웃 컴포넌트 선택:**

```
이 화면에 필요한 레이아웃 컴포넌트를 선택해주세요. (복수 선택 가능)

1. GNB + LNB (글로벌 헤더 + 로컬 탭) — 대부분의 메뉴 화면
2. GNB Only (글로벌 헤더만) — LNB 없는 단일 화면
3. FOOTER (하단 푸터) — 액션 버튼/소셜 그룹 필요 시
4. 없음 — 팝업, 모달 등 레이아웃 프레임 불필요
```

**레이아웃 선택 후 처리:**
```yaml
선택_처리:
  GNB_포함시:
    - GNB 탭 중 현재 메뉴(1뎁스)를 Selected 상태로 표시
    - 나머지 탭은 Normal 상태
  LNB_포함시:
    - 확정된 메뉴의 2뎁스 항목들을 LNB 탭으로 배치
    - 현재 선택된 2뎁스를 Selected 상태로 표시
  FOOTER_포함시:
    - 화면 목적에 맞는 버튼 구성 문의
    - "이 화면에 필요한 하단 버튼이 있나요? (예: 저장, 확인, 닫기 등)"
  캐시_확인:
    - ./figma-mockups/_shared/ 에 캐시 파일 존재 여부 확인
    - 없으면 MCP로 최초 추출 후 캐시 저장
    - 있으면 캐시 재사용
```

---

### Phase 2: 스크린샷 참조 파일 선정

확정된 메뉴 경로를 바탕으로 SCREENSHOTS_DIR에서 관련 스크린샷을 자동 선정한다.

#### 매칭 알고리즘

3단계 우선순위로 선정한다.

```yaml
# 입력 예시: 확정 경로 = "전적 > 매치 히스토리 > 개요"
# → 검색 키워드: ["전적", "매치히스토리", "개요"]

선정_우선순위:

  P1_정확_매칭:
    설명: "확정된 경로와 파일명이 정확히 일치"
    매칭: "전적_매치히스토리_개요.png"
    최대: 1장
    필수: true

  P2_형제_화면:
    설명: "같은 부모 뎁스의 다른 하위 화면"
    매칭: "전적_매치히스토리_*.png"
    최대: 3장
    용도: "같은 섹션의 레이아웃 패턴 참조"

  P3_같은_1뎁스:
    설명: "같은 1뎁스 메뉴의 다른 화면"
    매칭: "전적_*.png"
    최대: 2장
    용도: "메뉴 전체 스타일 톤 참조"

  총_최대: 6장
```

#### 신규 화면일 경우

```yaml
신규_화면_매칭:
  전략: "사용자가 입력한 화면 목적에서 키워드 추출"
  폴백:
    - 같은 1뎁스 메뉴의 대표 화면 3장
    - 없으면 전체에서 레이아웃 다양성 기준 5장 선정
      (리스트형, 카드형, 대시보드형, 상세형, 팝업형 각 1장)
```

#### 사용자 확인 출력 형식

```
📸 아래 스크린샷을 참조합니다:

[P1] 전적_매치히스토리_개요.png (정확 매칭)
[P2] 전적_매치히스토리_무기.png (형제 화면)
[P2] 전적_매치히스토리_통계.png (형제 화면)
[P3] 전적_프로필_개요.png (스타일 참조)

→ 추가하거나 제외할 파일이 있나요? (없으면 엔터)
```

---

### Phase 3: DS 분석

ORDO Design System Figma 파일에서 필요한 토큰을 MCP로 추출한다.

#### MCP 호출 순서

```yaml
Step_1_변수_추출:
  호출: mcp__figma__get_variable_defs(fileKey="c8Qux8CARpdsaKg1KsUwMm", nodeId="0:1")
  추출_대상:
    color:
      - bg-primary, bg-secondary, bg-tertiary
      - text-primary, text-secondary, text-disabled
      - accent-primary, accent-secondary
      - border-default, border-subtle
      - state-error, state-warning, state-success, state-info
    spacing:
      - spacing-xs, spacing-sm, spacing-md, spacing-lg, spacing-xl
    radius:
      - radius-sm, radius-md, radius-lg
    typography:
      - font-size-xs ~ font-size-3xl
      - font-weight-regular, font-weight-medium, font-weight-bold
      - line-height-tight, line-height-normal, line-height-relaxed

Step_2_컴포넌트_구조:
  호출: mcp__figma__get_design_context(fileKey="c8Qux8CARpdsaKg1KsUwMm", nodeId="{대상 컴포넌트 페이지}")
  화면에_필요한_컴포넌트만_선택_추출:
    버튼: SquareButton (스퀘어 버튼 V2), HoverButton (호버 버튼)
    입력: TextInput (텍스트 인풋), Dropdowns (드롭다운), Toggle (토글)
    네비게이션: Tabs (탭), SideTab (사이드 탭), ContentSwitch (콘텐츠 스위치)
    정보표시: Table (테이블 V2), List (리스트), Tag (태그), Flag (플래그)
    피드백: Modals (모달 템플릿), SystemMessage (시스템 메세지), Loading (로딩), NotiMarker (노티 마커)
    가이드: CoachMark (코치 마크), FilterPopup (필터팝업), ContextMenu (컨텍스트 메뉴)
    기타: ItemSlot (아이템 슬롯 V2), MissionList (미션 리스트), PageControl (페이지 컨트롤), Scroller (스크롤러), TimeIndicator (타임 인디케이터 V2), PUBGID (펍지 아이디)

Step_3_규칙_생성:
  호출: mcp__figma__create_design_system_rules()
  결과: DS 규칙 프롬프트 (Phase 4 HTML 생성 시 참조)
```

#### 토큰 → CSS 변수 매핑

```css
:root {
  /* 컬러 */
  --bg-primary: /* DS 추출값 */;
  --bg-secondary: /* DS 추출값 */;
  --text-primary: /* DS 추출값 */;
  --text-secondary: /* DS 추출값 */;
  --accent-primary: /* DS 추출값 */;
  --border-default: /* DS 추출값 */;

  /* 타이포 */
  --font-body: 'PUBG Body', 'Rajdhani', sans-serif;
  --font-headline: 'PUBG Headline', 'Teko', sans-serif;

  /* 간격 */
  --spacing-xs: /* DS 추출값 */;
  --spacing-sm: /* DS 추출값 */;
  --spacing-md: /* DS 추출값 */;
  --spacing-lg: /* DS 추출값 */;
  --spacing-xl: /* DS 추출값 */;
}
```

#### 폴백 처리

```yaml
폴백_전략:

  MCP_연결_실패:
    메시지: |
      ⚠️ Figma MCP 연결에 실패했습니다.
      1. Figma MCP 서버가 실행 중인지 확인해주세요
      2. DS_URL이 올바른지 확인해주세요
      → 재시도하시겠습니까?

  토큰_일부_누락:
    조치: "P1 스크린샷에서 컬러 피킹으로 보정"
    표기: "추론값에 /* inferred */ 주석"

  토큰_전체_누락:
    조치: "BETTERGROUND 기본 다크 테마 폴백 사용"
    폴백_값:
      bg-primary: "#1a1a2e"
      bg-secondary: "#16213e"
      text-primary: "#eaeaea"
      text-secondary: "#8b8b8b"
      accent-primary: "#f2a900"
      border-default: "#2a2a3e"
```

---

### Phase 4: HTML 생성

추출된 DS 토큰 + 스크린샷 분석 결과를 조합하여 HTML을 생성한다.

#### HTML 기본 템플릿

```html
<!DOCTYPE html>
<html lang="ko" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{메뉴경로}} — BETTERGROUND 시안</title>

  <style>
    /* ===== DS 토큰 (Phase 3에서 주입) ===== */
    :root {
      {{DS_TOKENS_CSS}}
    }

    /* ===== 리셋 ===== */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      width: 1920px;
      height: 1080px;
      background: var(--bg-primary);
      color: var(--text-primary);
      font-family: 'PUBG Body', sans-serif;
      overflow: hidden;
      position: relative;
    }

    /* ===== 레이아웃: GNB + LNB + Content + Footer 수직 배치 ===== */
    .layout {
      display: flex;
      flex-direction: column;
      width: 1920px;
      height: 1080px;
    }

    /* GNB 영역: 72px 고정 + Currency 52px */
    .gnb { flex-shrink: 0; }

    /* LNB 영역: Q5에서 선택 시에만 포함 */
    .lnb { flex-shrink: 0; }

    /* 컨텐츠 영역: 남은 공간 채움 */
    .content {
      flex: 1;
      overflow-y: auto;
      padding: var(--spacing-lg, 24px);
    }

    /* Footer 영역: 56px 고정, 하단 고정 */
    .footer { flex-shrink: 0; }

    /* ===== 컴포넌트 (DS 기반) ===== */
    {{COMPONENT_STYLES}}
  </style>
</head>
<body>
  <div class="layout">

    <!-- GNB: Q5에서 선택 시 캐시에서 로드 또는 동적 생성 -->
    {{#if GNB}}
    <header class="gnb">
      {{GNB_HTML}}
    </header>
    {{/if}}

    <!-- LNB: Q5에서 선택 시, 2뎁스 메뉴 항목으로 탭 구성 -->
    {{#if LNB}}
    <nav class="lnb">
      {{LNB_HTML}}
    </nav>
    {{/if}}

    <!-- 메인 컨텐츠 -->
    <main class="content">
      {{CONTENT_HTML}}
    </main>

    <!-- Footer: Q5에서 선택 시 캐시에서 로드 또는 동적 생성 -->
    {{#if FOOTER}}
    <footer class="footer">
      {{FOOTER_HTML}}
    </footer>
    {{/if}}

  </div>

  {{DYNAMIC_SCRIPTS}}
</body>
</html>
```

> **참고**: `{{#if}}` 구문은 실제 HTML이 아닌 생성 지시자. Phase 4 실행 시 Q5 선택 결과에 따라 해당 섹션을 포함/제외하여 최종 HTML을 생성한다.

#### 레이아웃 패턴 분류

스크린샷 분석 시 아래 패턴 중 가장 유사한 것을 선택하여 `CONTENT_HTML`을 구성한다.

```yaml
레이아웃_패턴:

  dashboard:
    특징: "카드/위젯 그리드 배치, 요약 수치 표시"
    적용_화면: 전적_개요, 제작소_개요, 패스 대시보드
    구조: |
      <div class="dashboard-grid">
        <div class="stat-card">{{통계 위젯}}</div>
        ...
      </div>

  list_detail:
    특징: "좌측 목록 + 우측 상세 패널, 또는 풀 리스트"
    적용_화면: 매치 히스토리, 클랜원, 뉴스
    구조: |
      <div class="list-detail">
        <aside class="list-panel">{{목록}}</aside>
        <section class="detail-panel">{{상세}}</section>
      </div>

  card_grid:
    특징: "카드형 아이템 반복 배치"
    적용_화면: 상점_아이템, 커스터마이즈, 이모트
    구조: |
      <div class="card-grid">
        <div class="item-card">{{아이템}}</div>
        ...
      </div>

  form_settings:
    특징: "입력 폼, 토글, 설정 항목 나열"
    적용_화면: 환경설정, 프로필 편집, 클랜 관리
    구조: |
      <div class="settings-form">
        <div class="form-group">{{설정 항목}}</div>
        ...
      </div>

  tabbed_content:
    특징: "탭 전환으로 하위 뷰 변경"
    적용_화면: 통계(경쟁), 무기(모든 매치), 경쟁전 보상
    구조: |
      <div class="tabbed-view">
        <nav class="tab-bar">{{탭}}</nav>
        <div class="tab-content">{{탭 내용}}</div>
      </div>

  modal_popup:
    특징: "오버레이 팝업, 딤 배경"
    적용_화면: 기타_팝업_*, 구매 확인, 필터
    구조: |
      <div class="modal-overlay">
        <div class="modal-card">{{팝업 내용}}</div>
      </div>
```

#### 스크린샷 분석 → HTML 변환 규칙

```yaml
분석_순서:

  1_레이아웃_파악:
    - 스크린샷에서 그리드/플렉스 구조 식별
    - 위 패턴 중 가장 유사한 것 선택
    - 사이드바/탑바 존재 여부 확인

  2_컴포넌트_식별:
    - 버튼, 테이블, 카드, 탭 등 DS 컴포넌트 매핑
    - 스크린샷 속 텍스트를 읽어 Mock 데이터로 사용
    - 아이콘 위치 확인 (DS 아이콘 또는 placeholder)

  3_컬러_검증:
    - DS 토큰 컬러와 스크린샷 컬러 비교
    - 차이가 크면 스크린샷 기준으로 보정
    - 보정 시 /* screenshot-adjusted */ 주석

  4_반응형_무시:
    - 1440px 고정 너비만 지원
    - 반응형 미디어쿼리 불필요
```

#### Mock 데이터 생성 규칙

```yaml
mock_data:
  원칙: "실제 PUBG 게임 데이터와 유사하게"

  플레이어명: "BETTER_Player01"
  클랜명: "BETTERGROUND"
  레벨: 42
  티어: "다이아몬드 III"

  매치_데이터:
    날짜_범위: "최근 7일"
    킬수_범위: 0~15
    등수_범위: 1~100
    맵: ["에란겔", "미라마", "태이고", "데스턴"]

  아이템:
    등급: ["일반", "희귀", "영웅", "전설", "신화"]
    가격_단위: "G-COIN"
```

#### JS 동적 렌더링 가이드

```yaml
동적_요소_처리:

  차트_그래프:
    방법: "인라인 SVG 또는 Canvas"
    라이브러리: "Chart.js CDN 사용 가능"
    주의: "figmadelay 3000ms 내 렌더링 완료 필수"

  애니메이션:
    허용: "CSS transition만"
    금지: "requestAnimationFrame 루프 (캡처 타이밍 불안정)"

  데이터_로딩:
    방법: "인라인 JSON 변수로 삽입"
    금지: "fetch/XHR 외부 호출"

  렌더링_완료_보장:
    방법: |
      window.addEventListener('load', () => {
        initCharts();
        populateData();
      });
```

#### 출력 경로

```
./figma-mockups/[메뉴경로]/index.html
예: ./figma-mockups/전적_매치히스토리/index.html
```

---

### Phase 5: Figma 캡처

#### 사전 체크리스트

```yaml
캡처_전_확인:

  1_HTTP_서버:
    확인: "로컬 서버가 실행 중인가?"
    명령: "lsof -i :8765 || netstat -an | grep 8765"
    실패시: "서버 시작 후 재시도"

  2_HTML_렌더링:
    확인: "http://localhost:8765/figma-mockups/[경로]/index.html 접근 가능?"
    방법: "curl -s -o /dev/null -w '%{http_code}' URL"
    기대값: "200"

  3_캡처_스크립트:
    확인: "capture.js가 HTML </body> 직전에 삽입?"
    코드: '<script src="https://mcp.figma.com/mcp/html-to-design/capture.js" async></script>'

  4_Figma_MCP:
    확인: "MCP 서버 연결 상태"
    방법: "/mcp 명령으로 확인"
```

#### 캡처 실행 절차

```yaml
Step_1_서버_시작:
  명령: |
    cd {{프로젝트_루트}}
    python -m http.server 8765 &
    # 또는
    npx http-server . -p 8765 -c-1 &
  메모: "서버 PID 기록 (종료용)"

Step_2_캡처_스크립트_삽입:
  대상: "HTML </body> 직전"
  삽입: '<script src="https://mcp.figma.com/mcp/html-to-design/capture.js" async></script>'
  주의: "중복 삽입 금지"

Step_3_캡처_호출:

  첫_캡처:
    호출: |
      mcp__figma__generate_figma_design(
        url: "http://localhost:8765/figma-mockups/{{메뉴경로}}/index.html",
        outputMode: "newFile",
        fileName: "{{메뉴경로}} 시안",
        figmadelay: 3000
      )
    결과: "fileKey 저장"

  추가_캡처:
    호출: |
      mcp__figma__generate_figma_design(
        url: "http://localhost:8765/figma-mockups/{{메뉴경로}}/index.html",
        outputMode: "existingFile",
        fileKey: "{{저장된_fileKey}}",
        pageName: "{{화면명}}",
        figmadelay: 3000
      )

Step_4_완료_대기:
  시간: "10~15초"
  확인: "Figma 파일 URL 반환 여부"

Step_5_정리:
  작업:
    - HTML에서 capture.js 스크립트 태그 제거
    - HTTP 서버 종료
  보존: "HTML 파일은 유지 (수정/재캡처용)"
```

#### 에러 핸들링

```yaml
에러_처리:

  캡처_타임아웃:
    증상: "15초 후에도 URL 미반환"
    대응:
      1: "figmadelay를 5000으로 올려 재시도"
      2: "JS 동적 요소를 정적으로 변환 후 재시도"
      3: |
        ⚠️ 캡처가 타임아웃되었습니다.
        HTML은 생성되었으니 수동 캡처를 시도해주세요.

  캡처_깨짐:
    증상: "Figma에서 레이아웃이 원본과 다름"
    대응:
      1: "CSS Grid → absolute positioning 변환"
      2: "웹폰트 → base64 인라인 임베드"
      3: "외부 이미지 → base64 인라인 변환"

  기존_파일_추가_실패:
    증상: "existingFile 모드에서 fileKey 무효"
    대응:
      1: "fileKey 재확인"
      2: "newFile로 새로 생성"
      3: "사용자에게 기존 파일에 수동 페이지 이동 안내"

  MCP_연결_끊김:
    메시지: |
      ⚠️ Figma MCP 연결이 끊어졌습니다.
      1. /mcp 명령으로 상태 확인
      2. Figma 앱이 열려 있는지 확인
      3. MCP 서버 재시작 후 재시도
```

#### 멀티 페이지 캡처

```yaml
멀티_캡처:
  절차:
    1: "첫 번째 화면 → outputMode: newFile → fileKey 획득"
    2: "이후 화면 → outputMode: existingFile, 동일 fileKey"
    3: "각 페이지마다 pageName 다르게 지정"
    4: "각 캡처 사이 5초 대기 (API 레이트 제한 방지)"

  주의사항:
    - captureId는 1회용 → 매 캡처마다 새 HTML 로드 필요
    - 같은 HTML 재캡처 시 브라우저 새로고침 필요
    - 최대 연속 캡처: 10페이지 (이후 새 파일 생성 권장)
```

---

## 전체 흐름 요약

```
/figma 실행
  │
  ├─ Phase 1: 대화로 메뉴 확정
  │   ├─ Q1: 1뎁스 선택 (13개 + 신규)
  │   ├─ Q2: 2뎁스 선택 (동적)
  │   ├─ Q3: 3뎁스 선택 (하위 있을 때만)
  │   ├─ Q4: 추가 요구사항 수집
  │   └─ Q5: 레이아웃 컴포넌트 선택 (GNB/LNB/FOOTER)
  │         └─ 캐시 확인 → 없으면 MCP 최초 추출 → 저장
  │
  ├─ Phase 2: 스크린샷 자동 선정
  │   ├─ P1: 정확 매칭 (1장)
  │   ├─ P2: 형제 화면 (최대 3장)
  │   ├─ P3: 같은 1뎁스 (최대 2장)
  │   └─ 사용자 확인 → 추가/제외 반영
  │
  ├─ Phase 3: ORDO DS MCP 분석
  │   ├─ Step 1: 변수(토큰) 추출 → CSS 변수 매핑
  │   ├─ Step 2: 컴포넌트 구조 파악
  │   ├─ Step 3: DS 규칙 프롬프트 생성
  │   └─ 폴백: MCP 실패 시 스크린샷 기반 추론 또는 기본값
  │
  ├─ Phase 4: HTML 생성
  │   ├─ 템플릿 구조: GNB + LNB + Content + Footer (수직 배치, 1920x1080)
  │   ├─ 레이아웃 컴포넌트: 캐시에서 로드 → 메뉴 상태 동적 반영
  │   ├─ 컨텐츠 패턴: dashboard / list_detail / card_grid / form / tabbed / modal
  │   ├─ DS 토큰 + 스크린샷 스타일 조합
  │   ├─ Mock 데이터 삽입
  │   └─ 출력: ./figma-mockups/[경로]/index.html
  │
  └─ Phase 5: Figma 캡처
      ├─ 사전 체크리스트 (서버, HTML, 스크립트, MCP)
      ├─ 서버 시작 → 캡처 스크립트 삽입 → MCP 호출
      ├─ 완료 대기 (10~15초) → URL 반환
      ├─ 정리 (스크립트 제거, 서버 종료)
      └─ 에러 시: 단계별 폴백 전략 실행
```

---

## 주의사항

- `file://` URL은 CORS 제한으로 캡처 불가 → 반드시 HTTP 서버 사용
- 캡처 완료 후 HTML에서 캡처 스크립트 제거
- captureId는 1회용 → 페이지마다 새로 발급 필요
- 멀티 페이지 캡처 시 첫 캡처만 `newFile`, 이후는 `existingFile`로 동일 fileKey에 추가

---

## 향후 개선 포인트

- [x] ~~SCREENSHOTS_DIR을 프로젝트 폴더로 이전 (팀 공유)~~ → 사용자 경로로 설정 완료
- [x] ~~DS_URL에 실제 ORDO DS Figma URL 및 nodeId 채워넣기~~ → fileKey, 페이지 목록 반영 완료
- [ ] 메뉴별 자주 쓰는 컴포넌트 조합 프리셋 추가
- [ ] 캡처 품질 검증 자동화 (캡처 후 스크린샷 비교)
- [ ] 멀티 화면 배치 캡처 지원 (한 번에 여러 경로 지정)
- [x] ~~DS_PAGES 각 페이지별 node-id 매핑~~ → 30개 페이지 전체 node-id 반영 완료
