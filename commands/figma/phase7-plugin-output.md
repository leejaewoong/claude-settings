# Phase 7: 플러그인 안내 + 출력

> **필수 참조**: `commands/figma/config.md`의 DS_PAGES (페이지명/node-id), `commands/figma/layout-components.md`의 node-id

Phase 5에서 HTML 캡처가 완료되고, Phase 6에서 생성한 component-spec.json을 출력하고 ORDO Component Placer 플러그인 사용을 안내한다.
캡처된 HTML 레이어는 DS 컴포넌트 교체 시 시각 참조로 활용된다.

## 출력 형식

```markdown
## 🔌 ORDO Component Placer — DS 인스턴스 자동 배치

아래 JSON을 복사하여 Figma에서 ORDO Component Placer 플러그인에 붙여넣으세요.

\```json
{{component-spec.json 내용}}
\```

### 사용 방법
1. Figma에서 Plugins → ORDO Component Placer 실행
2. 위 JSON을 텍스트 영역에 붙여넣기
3. "배치 실행" 클릭
4. DS 컴포넌트 인스턴스가 자동 배치됨

### 플러그인 미설치 시 — 수동 교체 가이드

| # | 캡처된 요소 | DS 컴포넌트 | DS 페이지 | 비고 |
|---|------------|------------|----------|------|
| 1 | {{요소 설명}} | {{DS 컴포넌트명}} | {{DS 페이지명}} | {{상태/속성 설정}} |
| 2 | ... | ... | ... | ... |

교체 순서: 레이아웃(GNB→LNB→Footer) → 버튼/입력 → 카드/슬롯 → 태그/뱃지
```

## 생성 규칙

```yaml
생성_규칙:
  - Phase 6의 component-spec.json 전문을 코드 블록으로 출력
  - 플러그인 사용법 안내 (3단계)  
  - DS_PAGES의 페이지명과 node-id를 참조하여 정확한 위치 안내
  - GNB/LNB/Footer는 레이아웃 컴포넌트 섹션의 node-id 참조
```
