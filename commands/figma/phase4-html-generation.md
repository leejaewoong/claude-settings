# Phase 4: HTML 생성

> **필수 참조**: `commands/figma/config.md`의 OUTPUT 설정 + ASSET_DIR, `commands/figma/layout-components.md`의 프리셋 경로
> **컴포넌트 상세**: `commands/figma/components/{이름}.md` 참조

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
      GNB+LNB: "C:\\figma-mockups\\_shared\\gnb.html"
      LNB_Only: "C:\\figma-mockups\\_shared\\lnb.html"
      FOOTER: "C:\\figma-mockups\\_shared\\footer.html"
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
    /* background: #000000 — Figma 캡처 시 프레임 배경이 비어 보이는 것을 방지 */
    .layout {
      display: flex;
      flex-direction: column;
      width: 1920px;
      height: 1080px;
      background: #000000;
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
      - "카드 그리드는 개별 카드에 명시적 width, height (px) 지정"
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
          grid-template-columns: repeat(auto-fill, minmax(174px, 1fr));
          grid-auto-rows: 210px;
          gap: 12px;
        }

    검증_체크리스트:
      - ".content 직계 자식 요소에 height 또는 min-height가 있는가?"
      - "flex/grid 자식 요소에 명시적 크기가 있는가?"
      - "콘텐츠 전체 높이가 .content 영역의 50% 이상을 채우는가?"
      - "비어 보이는 영역이 없는가? (배경색으로 시각 확인)"

  4.6_캐릭터_모델링_배치:
    조건: "Phase 1 Q6에서 '캐릭터 모델링 포함' 선택 시"
    참조_이미지: "SCREENSHOTS_DIR/캐릭터 모델링.png (전신, 검은 배경)"

    Y좌표_규칙: |
      캐릭터 발 밑 = Footer 바로 윗부분에 고정.
      Footer와의 간격: 0~50px (최대 50px).
      CSS: bottom 값 = Footer높이(56px) + 간격(0~50px).
    X좌표_규칙: |
      자유롭게 변경 가능.
      단, 캐릭터 본체가 화면 밖으로 잘리면 안 됨.
      검은 배경 부분은 잘려도 무방.
    크기_규칙: |
      캐릭터 높이 = 콘텐츠 영역의 70~90%.
      GNB+LNB+Footer 기준: 862px × 0.7~0.9 = 약 600~775px.
      캐릭터가 GNB/LNB 영역을 침범하지 않도록 주의.

    CSS_패턴: |
      /* 캐릭터 모델링 — .layout 내부에 absolute 배치 */
      .character-model {
        position: absolute;
        bottom: 56px;           /* Footer 높이 = 56px, 간격 0px */
        /* bottom: 86px;        /* Footer + 30px 간격 예시 */
        left: 50%;              /* X좌표 자유 변경 */
        transform: translateX(-50%);
        height: 700px;          /* 콘텐츠 영역 70~90% */
        z-index: 2;             /* UI 패널 뒤 또는 앞 조절 */
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
        z-index: 1;
      }

    HTML_삽입_위치: |
      .layout 내부, .content 바깥에 absolute로 배치.
      <div class="layout">
        {{GNB}}
        <main class="content">...</main>
        <img class="character-model" src="SCREENSHOTS_DIR/캐릭터 모델링.png" alt="캐릭터">
        <div class="character-shadow"></div>
        {{FOOTER}}
      </div>

    주의사항:
      - "mix-blend-mode: lighten은 검은 배경(#000~#333)만 투명화함 — 밝은 배경에서는 다르게 보일 수 있음"
      - "좌우 분할 레이아웃(커스터마이즈 등)에서는 캐릭터를 우측 패널 영역에 배치"
      - "모달/팝업 화면에서는 캐릭터 배치 비권장 (모달에 가려짐)"

  5_컴포넌트_크기_준수:
    원칙: |
      HTML 요소의 CSS 크기는 DS 컴포넌트 공식 규격에 맞춘다.
      스크린샷 분석으로 대략적 위치를 잡되, 최종 크기는 아래 표를 따른다.
      이 규격을 벗어나면 Figma 캡처 결과물에서 DS 가이드와 크기 불일치가 발생한다.

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
        Small: "40-89px (인벤토리 축소, 같은구간 보상 썸네일)"
        Middle: "90-200px (보상 그리드 기본 카드)"
        Large: "201-350px (상세 미리보기 이미지)"
        5열_그리드_기본: "width: 174px, height: 210px, gap: 12px"
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
        - "등급/상태 태그 (무료, 획득, 등급명)"
        - "아이템 이미지 영역 (placeholder 또는 이모지)"
        - "가격 표시 (미구매 시: 'C 120' 등)"
        - "아이템명 텍스트"
        - "등급 텍스트 (CLASSIC, RARE, EPIC 등 — 등급별 색상)"
        - "획득 완료 시: 오버레이 + ✓ 마크 + '획득 완료' 텍스트"

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

## 출력 경로

```
C:\figma-mockups\[메뉴경로]\index.html
예: C:\figma-mockups\전적_매치히스토리\index.html
```

## 사용자 리뷰 (HTML 확정)

HTML 생성 후 반드시 사용자 확인을 거쳐야 Phase 5(Figma 캡처)로 진행한다.

```yaml
리뷰_절차:

  1_프리뷰_제공:
    방법: "HTTP 서버를 시작하고 브라우저에서 확인할 수 있는 URL을 안내"
    명령: |
      cd C:\figma-mockups && python -m http.server 8765 &
    URL: "http://localhost:8765/{{메뉴경로}}/index.html"
    안내_메시지: |
      HTML 시안이 생성되었습니다.
      아래 URL에서 확인해주세요:
      → http://localhost:8765/{{메뉴경로}}/index.html

      수정하고 싶은 부분이 있으면 말씀해주세요.
      확인되면 "확인" 또는 "OK"라고 답변해주세요.

  2_수정_반복:
    조건: "사용자가 수정 요청 시"
    처리: |
      - 사용자 피드백을 반영하여 HTML 수정
      - 수정 후 브라우저 새로고침 안내
      - 다시 확인 질문
    반복: "사용자가 '확인'할 때까지"

  3_확정_후_진행:
    조건: "사용자가 '확인', 'OK', 'ㅇㅇ', '넘어가' 등 승인 답변"
    처리: "Phase 5(Figma 캡처)로 진행"
    주의: "서버는 Phase 5 캡처에서도 사용하므로 유지"
```
