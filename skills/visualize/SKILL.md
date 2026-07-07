---
name: visualize
description: Creates self-contained HTML visualizations (infographics, slide decks, dashboards, diagrams, timelines, comparisons) with built-in theme toggle, PNG download, and PDF print. Used by notion-learning-notes to render concept images. Activates on requests like '시각화해줘', '인포그래픽 만들어', '다이어그램으로 그려줘', '슬라이드로 정리해줘', 'visualize this', 'make an infographic', or when a concept needs a visual HTML explanation.
---

# Visualize Skill

학습 개념·아키텍처·플로우·비교를 단일 HTML 파일 시각화로 만든다.
결과물은 자체 완결(single file), 다크/라이트 테마, PNG 다운로드, PDF 인쇄를 기본 지원한다.

## Core Principles

- **CSS-first, JS-minimal** — 애니메이션은 CSS `@keyframes`/`transition`이 기본. JS는 메뉴·테마 토글·스크롤 옵저버·숫자 카운터·PNG 다운로드에만 사용. JS가 실패해도 콘텐츠는 항상 보여야 한다.
- **Self-contained** — 하나의 HTML 파일. CDN은 jsDelivr만, 꼭 필요할 때만.
- **Both themes** — 다크/라이트 모두에서 검수. 기본은 다크.
- **Budget** — 총 200KB 미만, 콘솔 에러 0, 시맨틱 HTML, 인쇄 CSS 포함.

## Workflow

1. **유형 선택** — 콘텐츠에 맞는 시각화 유형을 고른다 (슬라이드덱/인포그래픽/대시보드/플로차트/타임라인/비교/데이터 시각화/원페이저/마인드맵/칸반).
   → 유형별 상세 패턴: [references/patterns.md](references/patterns.md)
2. **스켈레톤에서 시작** — 반드시 필수 HTML 스켈레톤을 복사해 시작한다 (테마·인쇄·폰트·메뉴·애니메이션 내장).
   → [references/skeleton.md](references/skeleton.md)
3. **햄버거 메뉴 확인** — 우상단 메뉴(테마 토글 / PNG 다운로드 / PDF 인쇄)는 모든 시각화의 필수 요소.
   → 구현 전체: [references/menu.md](references/menu.md)
4. **스타일·모션 다듬기** — 필요한 부분만 로드해서 적용한다.
   → 고급 CSS 기법: [references/css-techniques.md](references/css-techniques.md)
   → 애니메이션 규칙: [references/animations.md](references/animations.md)
5. **라이브러리는 최후 수단** — Chart.js/D3/Mermaid 등은 스켈레톤으로 부족할 때만.
   → [references/libraries.md](references/libraries.md)
6. **자체 평가 후 반복** — 8개 차원 루브릭으로 채점하고 미달 항목을 고친 뒤 완료한다.
   → [references/eval.md](references/eval.md)

## Integration

- `notion-learning-notes` 스킬이 개념 이미지를 만들 때 이 스킬을 호출한다. HTML 생성 후 Playwright로 영역 캡쳐(PNG, device_scale_factor=2)하는 절차는 해당 스킬 문서를 따른다.
- 민감정보(자격 증명·IP·계정 식별자)는 캡쳐 전에 치환하거나 마스킹한다.

## Maintenance Notes

스킬 구조 개선 시 참고: [references/anthropic-skill-guide-notes.md](references/anthropic-skill-guide-notes.md)
