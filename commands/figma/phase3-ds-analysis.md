# Phase 3: DS 분석

> **필수 참조**: `commands/figma/config.md`의 DS_FILE_KEY, DS_PAGES
> **컴포넌트 상세**: `commands/figma/components/{이름}.md` — 색상, 크기, 스타일 참조

## 토큰 소스 우선순위

```yaml
토큰_소스:
  기본: "아래 로컬 캐시 사용 (MCP 불필요)"
  선택적_갱신: "사용자가 '토큰 갱신' 요청 시에만 MCP 호출"
  컴포넌트_상세: "commands/figma/components/{이름}.md 파일 참조"
```

Figma가 열려 있지 않거나, DS 파일이 선택되지 않아도 **로컬 캐시만으로 Phase 4 진행이 가능**하다.

---

## 로컬 토큰 캐시 (기본 소스)

```css
:root {
  /* ── 배경 ── */
  --bg-primary: #1a1a22;
  --bg-secondary: #1e1e24;
  --bg-tertiary: #222228;
  --bg-elevated: #2a2a35;
  --bg-overlay: rgba(0, 0, 0, 0.7);

  /* ── 텍스트 ── */
  --text-primary: #eaeaea;
  --text-secondary: #8b8b8b;
  --text-disabled: #555555;
  --text-inverse: #1a1a22;

  /* ── 액센트 ── */
  --accent-primary: #f2a900;    /* 골드 — CTA, 선택 인디케이터 */
  --accent-secondary: #d4940a;  /* 골드 다크 — hover */

  /* ── 보더 ── */
  --border-default: #2a2a35;
  --border-subtle: #333340;
  --border-strong: #3a3a45;

  /* ── 상태 ── */
  --state-error: #ff5252;
  --state-warning: #f2a900;
  --state-success: #5a9a6a;
  --state-info: #4fc3f7;

  /* ── 등급 ── */
  --grade-classic: #8b8b8b;
  --grade-rare: #4fc3f7;
  --grade-epic: #ab47bc;
  --grade-legendary: #f2a900;
  --grade-mythic: #ff5252;

  /* ── 태그 ── */
  --tag-yellow-bg: #f2a900;
  --tag-yellow-text: #1a1a22;
  --tag-red-bg: #ff5252;
  --tag-red-text: #ffffff;
  --tag-purple-bg: #ab47bc;
  --tag-purple-text: #ffffff;
  --tag-blue-bg: #4fc3f7;
  --tag-blue-text: #1a1a22;
  --tag-black-bg: #2a2a35;
  --tag-black-text: #eaeaea;
  --tag-white-bg: #eaeaea;
  --tag-white-text: #1a1a22;

  /* ── 버튼 ── */
  --btn-primary-bg: #f2a900;
  --btn-primary-text: #1a1a22;
  --btn-secondary-bg: #222228;
  --btn-secondary-text: #eaeaea;
  --btn-secondary-border: #333340;
  --btn-disabled-bg: #333340;
  --btn-disabled-text: #555555;

  /* ── 모달 ── */
  --modal-bg: #1e1e24;
  --modal-border: #2a2a35;
  --modal-close-bg: #222228;
  --modal-close-border: #333340;
  --modal-warning-bg: #2a2518;
  --modal-warning-border: #3d3520;

  /* ── 아이템 슬롯 ── */
  --slot-bg: #1e1e24;
  --slot-acquired-overlay: rgba(0, 0, 0, 0.4);
  --slot-locked-overlay: rgba(0, 0, 0, 0.6);
  --slot-check: #5a9a6a;

  /* ── 타이포 ── */
  --font-body: 'PUBG Body', 'Rajdhani', 'Noto Sans KR', 'Malgun Gothic', sans-serif;
  --font-headline: 'PUBG Headline', 'Teko', 'Noto Sans KR', 'Malgun Gothic', sans-serif;
  --font-size-xs: 10px;
  --font-size-sm: 12px;
  --font-size-md: 14px;
  --font-size-lg: 16px;
  --font-size-xl: 20px;
  --font-size-2xl: 24px;
  --font-size-3xl: 32px;

  /* ── 간격 ── */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 12px;
  --spacing-lg: 16px;
  --spacing-xl: 24px;
  --spacing-2xl: 32px;

  /* ── 라운딩 ── */
  --radius-sm: 2px;
  --radius-md: 4px;
  --radius-lg: 8px;
}
```

---

## Phase 4로 전달

위 CSS 변수 블록을 Phase 4 HTML 템플릿의 `{{DS_TOKENS_CSS}}` 위치에 그대로 주입한다.

---

## (선택) MCP로 토큰 갱신

사용자가 명시적으로 "토큰 갱신", "DS 새로 가져와" 등을 요청할 때만 실행한다.

```yaml
갱신_절차:
  전제조건:
    - "Figma 데스크톱 앱이 실행 중"
    - "ORDO Design System 파일이 열려 있음"
    - "Figma MCP 서버가 연결됨"

  Step_1_변수_추출:
    호출: mcp__figma__get_variable_defs(fileKey="c8Qux8CARpdsaKg1KsUwMm", nodeId="0:1")
    추출: "color, spacing, radius, typography 변수"

  Step_2_컴포넌트_구조:
    호출: mcp__figma__get_design_context(fileKey="c8Qux8CARpdsaKg1KsUwMm", nodeId="{대상 페이지}")
    추출: "화면에 필요한 컴포넌트 구조"

  Step_3:
    조치: "추출 결과로 위 로컬 캐시를 업데이트"
    안내: "이 파일(phase3-ds-analysis.md)의 로컬 토큰 캐시 섹션을 갱신하세요"

  실패_시:
    메시지: |
      ⚠️ Figma MCP 연결에 실패했습니다.
      로컬 캐시 토큰으로 계속 진행합니다.
```
