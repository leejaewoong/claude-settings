# Phase 4: HTML 생성

> **필수 참조**: `commands/figma/config.md`의 SERVE_PORT + ASSET_DIR, `commands/figma/layout-components.md`의 프리셋 경로
> **컴포넌트 상세**: `commands/figma/components/{이름}.md` 참조
> **시각 품질**: `commands/figma/concepts/concept-{A|B|C}.md` — Phase 1 Q8에서 선택된 컨셉 규칙 적용

추출된 DS 토큰 + 스크린샷 분석 결과를 조합하여 HTML을 생성한다.

## 생성 속도 최적화 (필수)

```yaml
속도_원칙: "보일러플레이트는 복사, 콘텐츠만 생성에 집중"

생성_순서:
  Step_1_골격_복사:
    설명: "아래 HTML 기본 템플릿을 그대로 복사하고, DS 토큰 CSS만 주입"
    소요: "즉시 (생성 아님, 복사)"

  Step_2_레이아웃_주입:
    설명: "GNB/LNB/Footer는 프리셋 HTML을 로드하고 동적 마커를 치환하여 삽입 (새로 생성 금지)"
    소요: "즉시 (프리셋 로드 + 마커 치환)"
    프리셋_경로:
      GNB+LNB: "commands/figma/presets/gnb.html"
      LNB_Only: "commands/figma/presets/lnb.html"
      FOOTER: "commands/figma/presets/footer.html"
    동적_마커_치환:
      "{{ACTIVE_TAB}}": "Phase 1 Q1에서 선택한 1뎁스 메뉴 (예: PLAY, STORE 등)"
      "{{LNB_TABS}}": "Phase 1 Q2에서 확정된 2뎁스 메뉴 항목 배열 (예: NORMAL,RANKED,ARCADE,...)"
      "{{ACTIVE_LNB_TAB}}": "Phase 1 Q3에서 선택한 3뎁스 (또는 2뎁스 첫 항목)"
      "{{FOOTER_BUTTONS}}": "화면별 좌측 액션 버튼 텍스트 (예: PRIMARY,SECONDARY)"
      "{{HEADER_TEXT}}": "LNB Only 사용 시 화면 타이틀 (Phase 1에서 확정된 메뉴명)"
      "{{ASSET_DIR}}": "config.md의 ASSET_DIR 절대경로 (에셋 이미지 참조)"
    보조재화_자동_배치: "{{SUB_CURRENCY}} 수동 치환 불필요 — gnb.html 스크립트가 {{ACTIVE_TAB}} 기반으로 자동 처리 (매핑 메뉴: HIDEOUT/WORKSHOP/PASS → 전용 아이콘, 나머지 → 랜덤 2~3개)"

  Step_3_콘텐츠_집중:
    설명: "CONTENT_HTML만 새로 생성 — 이것이 유일한 생성 작업"
    방법:
      - "레이아웃 패턴 1개 선택 → 해당 구조 HTML만 작성"
      - "CSS는 클래스 기반으로 재사용 (인라인 style 최소화)"
      - "반복 요소는 HTML 내 동일 클래스로 통일, 개별 스타일 금지"
    시각품질_적용:
      컨셉_분기:
        Concept_A:
          규칙: "commands/figma/concepts/concept-a-pubg.md 읽고 적용"
          적용: "섹션 A-H + 셀프체크 전체 준수"
        Concept_B:
          규칙: "commands/figma/concepts/concept-b-competitor.md 읽고 적용"
          적용: "경쟁작별 시각 규칙 적용, DS 토큰 기반 유지, 참조 타이틀 안내"
        Concept_C:
          규칙: "commands/figma/concepts/concept-c-experimental.md 읽고 적용"
          적용: "frontend-design SKILL.md 원칙 적용, DS foundation만 유지"
      공통: "폰트(PUBG Body/Headline), GNB/Footer 프리셋, 컴포넌트 크기 — 모든 컨셉 동일"

  Step_4_검증_스킵:
    설명: "생성 중 검증하지 않음 — 사용자 리뷰에서 확인"

CSS_최적화:
  금지: "각 요소에 인라인 style 속성 남발"
  필수: "공통 스타일은 <style> 블록 내 클래스로 정의"
  예시_나쁨: |
    <div style="width:174px;height:210px;background:#1e1e24;border:1px solid #8b8b8b;border-radius:4px;">
    <div style="width:174px;height:210px;background:#1e1e24;border:1px solid #4fc3f7;border-radius:4px;">
  예시_좋음: |
    <style>.item-card { width:174px; height:210px; background:#1e1e24; border-radius:4px; }</style>
    <div class="item-card" style="border-color:#8b8b8b;">
    <div class="item-card" style="border-color:#4fc3f7;">

컴포넌트_md_참조:
  규칙: "필요한 컴포넌트의 .md만 읽는다 (전체 읽기 금지)"
  예시: "버튼+태그만 있으면 SquareButton.md, Tag.md만 참조"
```

## HTML 기본 템플릿

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
      background: var(--bg-primary, #000000);
      color: var(--text-primary, #eaeaea);
      font-family: 'PUBG Body', sans-serif;
      overflow: hidden;
      position: relative;
    }

    /* ===== 레이아웃: GNB + LNB + Content + Footer 수직 배치 ===== */
    /* background: var(--bg-primary) — GNB/Footer와 배경색 통일 */
    .layout {
      display: flex;
      flex-direction: column;
      width: 1920px;
      height: 1080px;
      background: var(--bg-primary, #1a1a22);
    }

    /* GNB+LNB 영역: 162px 고정 (GNB 72px + 재화바 52px + 보조재화바 38px, LNB 42px 중앙 배치) */
    .gnb { flex-shrink: 0; }

    /* LNB 영역: Q5에서 선택 시에만 포함 */
    .lnb { flex-shrink: 0; }

    /* ===== 컨텐츠 영역: 명시적 높이 계산 ===== */
    /* GNB+LNB=162px, Footer=56px → 콘텐츠=862px */
    /* LNB Only=162px, Footer=56px → 콘텐츠=862px */
    /* Footer만 → 콘텐츠=1024px */
    /* 없음 → 콘텐츠=1080px */
    .content {
      flex: 1;
      min-height: 600px; /* 콘텐츠가 절대 사라지지 않도록 최소 높이 보장 */
      overflow-y: auto;
      padding: var(--spacing-lg, 24px);
      position: relative;
    }

    /* Footer 영역: 56px 고정, 하단 고정 */
    .footer { flex-shrink: 0; }

    /* ===== 컴포넌트 (DS 기반) ===== */
    {{COMPONENT_STYLES}}
  </style>
</head>
<body>
  <div class="layout">

    <!-- GNB: Q5에서 선택 시 프리셋에서 로드 + 동적 마커 치환 -->
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

    <!-- Footer: Q5에서 선택 시 프리셋에서 로드 + 동적 마커 치환 -->
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

## 레이아웃 패턴 분류

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
    시각_가이드:
      L1: "상단 대형 수치 카드 1-2개 (높이 200px+, 반투명 패널)"
      L2: "하단 소형 카드 그리드 (높이 120-160px)"
      비율: "대형 40%, 소형 50%, 여백 10%"
      배경: "비네팅 그라디언트 또는 캐릭터 배경 위 반투명 오버레이"

  list_detail:
    특징: "좌측 목록 + 우측 상세 패널, 또는 풀 리스트"
    적용_화면: 매치 히스토리, 클랜원, 뉴스
    구조: |
      <div class="list-detail">
        <aside class="list-panel">{{목록}}</aside>
        <section class="detail-panel">{{상세}}</section>
      </div>
    시각_가이드:
      L1: "우측 상세 패널 (면적 60-70%, 반투명 rgba(26,26,34,0.85))"
      L2: "좌측 목록 패널 (면적 25-30%, 반투명 rgba(30,30,36,0.80))"
      비율: "좌측 280-320px 고정, 우측 flex:1"
      배경: "좌우 패널 모두 반투명, 배경색 1단계 차이"

  card_grid:
    특징: "카드형 아이템 반복 배치"
    적용_화면: 상점_아이템, 커스터마이즈, 이모트
    구조: |
      <div class="card-grid">
        <div class="item-card">{{아이템}}</div>
        ...
      </div>
    시각_가이드:
      L1: "선택된 카드 확대 또는 상단 배너 (accent border 허용)"
      L2: "카드 그리드 전체 (반투명 컨테이너, 개별 카드는 border만)"
      비율: "카드 이미지 65%, 텍스트+패딩 35%"
      배경: "카드 컨테이너 rgba(30,30,36,0.80), 개별 카드 rgba(26,26,34,0.90)"

  form_settings:
    특징: "입력 폼, 토글, 설정 항목 나열"
    적용_화면: 환경설정, 프로필 편집, 클랜 관리
    구조: |
      <div class="settings-form">
        <div class="form-group">{{설정 항목}}</div>
        ...
      </div>
    시각_가이드:
      L1: "좌측 카테고리 패널 + 우측 설정 영역 (반투명)"
      L2: "설정 그룹 카드 (배경 1단계 차이, 반투명)"
      비율: "카테고리 240px 고정, 설정 영역 flex:1"
      배경: "카테고리 rgba(26,26,34,0.85), 설정 그룹 rgba(30,30,36,0.80)"

  tabbed_content:
    특징: "탭 전환으로 하위 뷰 변경"
    적용_화면: 통계(경쟁), 무기(모든 매치), 경쟁전 보상
    구조: |
      <div class="tabbed-view">
        <nav class="tab-bar">{{탭}}</nav>
        <div class="tab-content">{{탭 내용}}</div>
      </div>
    시각_가이드:
      L1: "탭 콘텐츠 메인 영역 (반투명 패널)"
      L2: "탭 바 (선택 탭에만 accent underline, 1곳)"
      비율: "탭 바 44px 고정, 콘텐츠 나머지 전체"
      배경: "탭 콘텐츠 rgba(26,26,34,0.85), 탭 바는 bg-tertiary"

  # modal_popup — 제작 제외
  # 미리보기/팝업 화면은 기존 프로덕트 규칙이 정교하여 시안 제작 불필요.
  # 단, 해당 화면으로 진입하는 버튼/트리거는 부모 화면에 반드시 포함할 것.
  # 예: 아이템 카드(클릭→미리보기), "구매" 버튼(클릭→구매 확인 팝업)
```

## 스크린샷 분석 → HTML 변환 규칙

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
    - 1920px 고정 너비만 지원
    - 반응형 미디어쿼리 불필요

  4.5_콘텐츠_영역_크기_필수:
    원칙: |
      네비게이션과 푸터만 보이고 주요 콘텐츠가 보이지 않는 현상을 방지한다.
      콘텐츠 영역(.content)과 그 내부 요소에 반드시 명시적 크기를 지정한다.

    높이_계산:
      GNB+LNB+Footer: "콘텐츠 높이 = 1080 - 162 - 56 = 862px"
      LNB_Only+Footer: "콘텐츠 높이 = 1080 - 162 - 56 = 862px"
      Footer만: "콘텐츠 높이 = 1080 - 56 = 1024px"
      없음: "콘텐츠 높이 = 1080px"

    필수_규칙:
      - ".content 내부의 최상위 컨테이너에 width: 100%, height: 100% 또는 명시적 px 높이 지정"
      - "그리드/리스트 컨테이너에 min-height 지정 (최소 400px)"
      - "좌우 분할 레이아웃은 양쪽 패널 모두 height: 100% 지정"
      - "카드 그리드는 콘텐츠 영역을 충분히 채우도록 열 수와 카드 크기를 자유 결정"
      - "빈 영역이 생기면 background-color로 구분 가능하게 처리"

    콘텐츠_컨테이너_템플릿:
      설명: "콘텐츠 내부 최상위 요소는 반드시 아래 패턴 중 하나를 따른다"
      풀_영역: |
        .content-wrapper {
          width: 100%;
          height: 100%;
          display: flex;      /* 또는 grid */
        }
      좌우_분할: |
        .content-wrapper {
          width: 100%;
          height: 100%;
          display: flex;
        }
        .left-panel { width: 280px; height: 100%; flex-shrink: 0; }
        .right-panel { flex: 1; height: 100%; }
      그리드: |
        .content-wrapper {
          width: 100%;
          height: 100%;
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
          grid-auto-rows: minmax(150px, auto);
          gap: 12px;
        }
        /* 슬롯 크기와 열 수는 화면 목적에 맞게 자유 결정 — 가로·세로 여백 최소화 */

    검증_체크리스트:
      - ".content 직계 자식 요소에 height 또는 min-height가 있는가?"
      - "flex/grid 자식 요소에 명시적 크기가 있는가?"
      - "콘텐츠 전체 높이가 .content 영역의 50% 이상을 채우는가?"
      - "비어 보이는 영역이 없는가? (배경색으로 시각 확인)"

  4.6_캐릭터_모델링_배치:
    조건: "Phase 1 Q6에서 '캐릭터 모델링 포함' 선택 시"
    참조_이미지: "SCREENSHOTS_DIR/캐릭터 모델링.png (전신, 검은 배경)"

    배경_규칙: |
      캐릭터 이미지의 검은 배경 가장자리가 페이지와 자연스럽게 블렌딩되도록
      .layout에 has-character 클래스를 추가하고 배경을 #111115으로 강제한다.
      mix-blend-mode: lighten으로 검은 배경(#000~#333)이 #111115보다 어두워 정상적으로 제거된다.

    Y좌표_규칙: |
      캐릭터 발 밑 = Footer 바로 윗부분에 고정.
      Footer와의 간격: 0~50px (최대 50px).
      CSS: bottom 값 = Footer높이(56px) + 간격(0~50px).
    X좌표_규칙: |
      자유롭게 변경 가능.
      단, 캐릭터 본체가 화면 밖으로 잘리면 안 됨.
      검은 배경 부분은 잘려도 무방.
    크기_규칙: |
      캐릭터 높이를 850px로 고정한다 (height: 850px, width: auto).
      캐릭터 위에 UI/컴포넌트가 표시될 수 있으므로 z-index를 낮게 설정한다.

    z_index_가이드: |
      GNB: 10 > 콘텐츠: 3 > 캐릭터: 1 > 그림자: 0

    CSS_패턴: |
      /* 캐릭터 모델링 포함 시 배경 강제 — GNB/Footer와 통일 */
      .layout.has-character { background: #111115; }
      .layout.has-character .content { background: #111115; }

      /* 캐릭터 모델링 — .layout 내부에 absolute 배치 */
      .character-model {
        position: absolute;
        bottom: 56px;           /* Footer 높이 = 56px, 간격 0px */
        /* bottom: 86px;        /* Footer + 30px 간격 예시 */
        left: 50%;              /* X좌표 자유 변경 */
        transform: translateX(-50%);
        height: 850px;          /* 캐릭터 높이 850px 고정 */
        width: auto;            /* 비율 유지 */
        z-index: 1;             /* UI(3+)보다 낮게 */
        mix-blend-mode: lighten; /* 검은 배경 제거 */
        pointer-events: none;
      }
      /* 발 아래 그림자 (선택) */
      .character-shadow {
        position: absolute;
        bottom: 50px;
        left: 50%;
        transform: translateX(-50%);
        width: 200px;
        height: 30px;
        background: radial-gradient(ellipse, rgba(0,0,0,0.4) 0%, transparent 70%);
        z-index: 0;
      }

    HTML_삽입_위치: |
      .layout 내부, .content 바깥에 absolute로 배치.
      has-character 클래스를 .layout에 추가한다.
      <div class="layout has-character">
        {{GNB}}
        <main class="content">...</main>
        <img class="character-model" src="SCREENSHOTS_DIR/캐릭터 모델링.png" alt="캐릭터">
        <div class="character-shadow"></div>
        {{FOOTER}}
      </div>

    주의사항:
      - "mix-blend-mode: lighten은 검은 배경(#000~#333)만 투명화함 — has-character로 배경을 #111115로 강제 (캐릭터 이미지의 #000~#333이 #111115보다 어두워 정상 제거)"
      - "좌우 분할 레이아웃(커스터마이즈 등)에서는 캐릭터를 우측 패널 영역에 배치"
      - "모달/팝업 화면에서는 캐릭터 배치 비권장 (모달에 가려짐)"
      - "UI 패널은 z-index: 3 이상으로 설정하여 캐릭터(z-index: 1) 위에 표시"

  5_컴포넌트_크기_준수:
    원칙: |
      HTML 요소의 CSS 크기는 DS 컴포넌트 규격을 참고한다.
      스크린샷 분석으로 대략적 위치를 잡되, 최종 크기는 아래 표를 참고한다.
      ItemSlot은 콘텐츠 영역을 충분히 채우도록 크기와 열 수를 자유롭게 결정한다.

    크기_참조표:
      SquareButton:
        XSmall: "height: 26px"
        Small: "height: 32px"
        Default: "height: 44px"
        Large: "height: 54px"
        XLarge: "height: 64px"
        용도_가이드: "Primary CTA → Large(54px), Secondary → Default(44px), Compact → Small(32px)"
        너비: "내부 텍스트에 따라 자동 (min-width: 60px)"

      ItemSlot:
        Small: "~60px (참고, 인벤토리/보조 썸네일)"
        Middle: "~150px (참고, 일반 그리드)"
        Large: "~300px (참고, 상세 미리보기)"
        크기_자유: "슬롯 크기와 열 수는 콘텐츠 영역을 충분히 채우도록 자유 결정 (가로 여백 최소화)"
        내부_구조: "상단 이미지(60-70%) + 하단 텍스트(아이템명+등급)"

      Modal:
        Small: "width: 660px (단순 확인/구매)"
        Default: "width: 760px (일반 모달)"
        Large: "width: 960px (복잡 콘텐츠)"
        padding: "32px (상하좌우 동일)"
        cornerRadius: "8px"

      SideTab:
        panel_width: "200-280px (280px 초과 금지)"
        tab_height: "40-48px"
        tab_padding: "left 16px, right 12px"
        indicator: "좌측 3px bar (선택 시 #f2a900)"

      Tag:
        XSmall: "height: 16-18px, fontSize: 10px"
        Small: "height: 18-20px, fontSize: 11px"
        Default: "height: 20-24px, fontSize: 12px"
        Large: "height: 24-28px, fontSize: 13px"

      ContentSwitch:
        tab_height: "36px"
        tab_min_width: "80px"

      Tabs:
        height: "44px (고정)"

  6_콘텐츠_완전성:
    원칙: |
      HTML에 표현하는 모든 시각 요소는 Figma 캡처에 그대로 반영된다.
      따라서 HTML에서 생략하면 최종 Figma 시안에서도 누락된다.
      아래 체크리스트를 확인하여 빠짐없이 생성한다.

    반복_요소_전개:
      원칙: "그리드/리스트의 각 아이템은 내부 구조까지 완전히 HTML로 작성"
      아이템_카드_필수_요소:
        - "등급/상태 태그 (FREE, OWNED, 등급명 — 영문)"
        - "아이템 이미지 영역 (placeholder 또는 이모지)"
        - "가격 표시 (미구매 시: 'C 120' 등)"
        - "아이템명 텍스트 (영문)"
        - "등급 텍스트 (COMMON, RARE, EPIC, LEGENDARY, MYTHIC — 등급별 색상)"
        - "획득 완료 시: 오버레이 + ✓ 마크 + 'OWNED' 텍스트"

    보조_UI_누락_방지:
      체크리스트:
        - "네비게이션 뱃지 (구간 번호, 진행 상태, 미니 진행바)"
        - "토큰/화폐 아이콘 (C 원형 아이콘 + 수치)"
        - "보유/잔액 정보 텍스트"
        - "닫기/뒤로 버튼"
        - "드래그/회전 컨트롤 (텍스트 + 화살표)"
        - "카테고리 상세 메타데이터 (카테고리, 시즌, 구간, 유형)"
        - "경고/안내 메시지 (⚠ 아이콘 포함)"
```

## Mock 데이터 생성 규칙

```yaml
mock_data:
  원칙: "실제 PUBG 게임 데이터와 유사하게, 모든 텍스트는 영문으로 작성"
  언어: "EN — 디자인에 표시되는 모든 텍스트(버튼, 라벨, 메뉴, 상태, Mock 데이터)는 영문"

  플레이어명: "BETTER_Player01"
  클랜명: "BETTERGROUND"
  레벨: 42
  티어: "Diamond III"

  매치_데이터:
    날짜_범위: "Last 7 Days"
    킬수_범위: 0~15
    등수_범위: 1~100
    맵: ["Erangel", "Miramar", "Taego", "Deston"]

  아이템:
    등급: ["Common", "Rare", "Epic", "Legendary", "Mythic"]
    가격_단위: "G-COIN"
```

## JS 동적 렌더링 가이드

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

## 인메모리 서빙

```yaml
파일_저장_금지: "HTML을 디스크에 쓰지 않는다. Write 도구 호출 없이 Bash로 인메모리 서버를 시작한다."

서버_시작:
  방법: "생성한 HTML을 Bash heredoc으로 Node.js 인메모리 서버에 전달"
  명령: |
    node -e "
    const http=require('http');
    let d='';
    process.stdin.on('data',c=>d+=c);
    process.stdin.on('end',()=>{
      http.createServer((q,r)=>{
        r.writeHead(200,{'Content-Type':'text/html;charset=utf-8'});
        r.end(d);
      }).listen(8765,()=>console.log('http://localhost:8765'));
    });" <<'HTMLEOF'
    {{생성된 HTML 전체}}
    HTMLEOF
  실행: "run_in_background: true — 서버를 백그라운드로 실행"
  URL: "http://localhost:8765"

수정_시_서버_재시작:
  절차:
    1: "기존 서버 프로세스 종료 (kill)"
    2: "수정된 HTML로 동일 명령 재실행"

자동_진행:
  설명: "HTML 생성 및 서버 시작 완료 후 즉시 Phase 5(Figma 캡처)로 진행"
  주의: "서버는 Phase 5 캡처에서 사용하므로 유지"
```

## 멀티 컨셉 생성

Phase 1 Q8에서 복수 컨셉 선택(MULTI_CONCEPT = true) 시 적용한다.

```yaml
멀티_컨셉_생성:

  공통_요소:
    설명: "GNB/LNB/Footer 마커 치환, Mock 데이터는 1회만 생성 (모든 컨셉 동일)"
    폰트: "PUBG Body / PUBG Headline — 모든 컨셉 공통"
    대상: "Step 1(골격), Step 2(레이아웃) 결과물은 모든 컨셉이 공유"

  CONTENT_HTML_생성:
    단일_컨셉:
      방법: "해당 컨셉 규칙 파일 로드 → CONTENT_HTML 1개 생성 → 서빙 → Phase 5"
    복수_컨셉:
      방법: |
        SELECTED_CONCEPTS 배열을 순회하며 각 컨셉별 CONTENT_HTML을 생성한다.
        1. 공통 골격(Step 1-2) 결과물을 메모리에 보관
        2. 각 컨셉의 규칙 파일을 읽고 CONTENT_HTML만 개별 생성
        3. 공통 골격 + 컨셉별 CONTENT_HTML을 조합하여 전체 HTML 구성
        4. 모든 컨셉 HTML을 메모리에 보관
        5. 첫 번째 컨셉 HTML을 port 8765에 서빙 → Phase 5로 자동 진행

  병렬_생성:
    조건: "SELECTED_CONCEPTS 길이 ≥ 2"
    방법: |
      Agent 도구로 컨셉별 서브에이전트를 병렬 실행하여 CONTENT_HTML 생성 시간을 단축한다.
      1. 메인 스레드: 공통 요소 생성 (Step 1-2: 골격 + GNB/Footer)
      2. Agent 도구로 컨셉별 서브에이전트 병렬 실행 (최대 3개):
         - 각 에이전트에 전달: Phase 1-3 컨텍스트 요약 + 해당 컨셉 규칙 파일 경로
         - 각 에이전트의 작업: CONTENT_HTML 생성 후 반환
      3. 메인 스레드: 반환된 CONTENT_HTML들을 공통 템플릿에 각각 조합
      4. 첫 번째 컨셉 HTML을 서빙 → Phase 5에서 순차 캡처
    제약:
      - "서빙/캡처는 단일 포트(8765)이므로 순차 처리"
      - "Agent 병렬화의 이점: HTML '생성' 시간 단축 (가장 큰 병목)"

  Concept_B_표시:
    조건: "Concept B가 SELECTED_CONCEPTS에 포함된 경우"
    안내: |
      컨셉 B 시안을 생성합니다.
      참조: {경쟁작명} — {해당 화면 유형}
      주요 적용: {적용된 시각 요소 1-2줄 요약}
```
