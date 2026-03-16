# 컨셉 A: PUBG 레이아웃 준수

```yaml
컨셉: A
이름: "PUBG 레이아웃 준수"
설명: "기존 PUBG UI 시각 언어를 엄격히 준수하는 정석 시안"
스크린샷_분석: true     # Phase 2 스크린샷 적극 참조
DS_토큰_사용: strict    # Phase 3 토큰 그대로 사용
```

> **적용 범위**: Phase 4에서 `CONTENT_HTML` 생성 시 필수 준수
> **근거**: 실제 PUBG 프로덕트 스크린샷 112장 분석 + 게임 UI 업계 표준

---

## A. PUBG 시각 언어 원칙

```yaml
PUBG_시각_언어:
  1_전술적_미니멀리즘: "최대 정보를 최소 시각 노이즈로. 어두운 배경 + 전략적 색상"
  2_시네마틱_포커스: "프로급 3D 렌더/시네마틱 배경으로 콘텐츠를 쇼케이스"
  3_골드_절제: "프리미엄 액센트(#f2a900)는 화면당 3-4곳. 남용하면 가치 하락"
  4_플로팅_UI: "모든 패널은 반투명으로 배경 위에 떠 있다. 솔리드 블록 금지"
  5_기하학적_아이덴티티: "육각형/팔각형 뱃지, 코너 장식선 등 밀리터리/택티컬 조형"
```

---

## B. 시각 위계 프레임워크

```yaml
시각_위계:
  L1_주인공 (1~2개):
    수단: "가장 큰 font(20-32px, headline), accent 허용, 면적 40-60%"
    예시: "대시보드 핵심 수치, 캐릭터 미리보기, 선택된 아이템 상세"
  L2_조력자:
    수단: "중간 font(14-16px, body, 600), accent 금지, 면적 25-35%"
    예시: "카드 그리드, 사이드 패널 목록, 진행률 바"
  L3_배경:
    수단: "작은 font(10-12px), text-secondary, 면적 10-20%"
    예시: "메타데이터, 범례, 날짜, 부가 설명"

  적용: "CONTENT_HTML 작성 시 L1을 먼저 결정 → 나머지 L2/L3 분배"
  제한: "L1 요소는 화면당 최대 2개. L1→L2 font-size 차이 최소 6px"
```

---

## C. 색상 적용 규칙 (60/30/10 + 골드 절제)

```yaml
60_30_10_비율:
  60%_주색: "bg-primary #1a1a22 (전체 배경, 어두운 톤)"
  30%_보조색: "bg-secondary #1e1e24, bg-tertiary #222228 (패널, 카드, 구분)"
  10%_액센트: "accent-primary #f2a900 + 상태 색상 (전체의 10% 미만)"

골드_accent_규칙:
  최대: "화면당 3-4곳 (실제 프로덕트 기준)"
  우선순위:
    1: "CTA 버튼 배경 (Primary Button)"
    2: "선택 인디케이터 (탭 언더라인, 사이드탭 바, border)"
    3: "핵심 수치/뱃지 (레벨, 보유 화폐)"
    4: "진행률 바 fill (선택적)"
  금지: "카드 border + 텍스트 라벨 + 배경 gradient + 아이콘에 동시 사용"
  체크: "CONTENT_HTML 완성 후 #f2a900 / accent-primary 검색 → 4회 초과 시 최하위부터 교체"

배경_깊이_4단계:
  레이어_0: "bg-primary #1a1a22 — 전체 배경"
  레이어_1: "bg-secondary #1e1e24 — 패널, 카드 (반투명 권장: rgba(30,30,36,0.85))"
  레이어_2: "bg-tertiary #222228 — 헤더, 도구모음"
  레이어_3: "bg-elevated #2a2a35 — 호버, 드롭다운, 툴팁"
  규칙: "인접 요소는 반드시 1단계 이상 차이"

텍스트_색상:
  주의: "순수 흰색(#ffffff) 대신 off-white(#eaeaea) 사용 — 눈부심 방지 + 대비 유지"
  opacity_위계:
    최중요: "text-primary #eaeaea (100%)"
    보조: "text-secondary #8b8b8b (~60%)"
    비활성: "text-disabled #555555 (~35%)"
```

---

## D. 반투명 패널 & 배경 처리

```yaml
플로팅_패널_규칙:
  원칙: "콘텐츠 패널은 솔리드 배경 대신 반투명 오버레이를 사용한다"

  패널_배경_프리셋:
    사이드_패널: "background: rgba(26,26,34,0.85); backdrop-filter: blur(8px)"
    카드_컨테이너: "background: rgba(30,30,36,0.80)"
    정보_패널: "background: rgba(26,26,34,0.90)"
    솔리드_허용: "GNB/Footer만 솔리드 배경 허용 (프리셋이므로)"

  배경_이미지_처리:
    캐릭터_있을때: "캐릭터 이미지가 배경 역할 → 패널이 캐릭터 위에 반투명으로"
    캐릭터_없을때: "콘텐츠 영역 배경에 미묘한 그라디언트 또는 비네팅 적용"
    비네팅_프리셋: |
      background:
        radial-gradient(ellipse 120% 80% at 50% 40%, rgba(34,34,40,0.3) 0%, transparent 70%),
        var(--bg-primary);

  오버레이_페이드:
    용도: "하단에서 콘텐츠가 캐릭터를 자연스럽게 가릴 때"
    값: "linear-gradient(180deg, transparent 0%, rgba(26,26,34,0.95) 30%, rgba(26,26,34,1) 100%)"
```

---

## E. 여백 & 간격 체계

```yaml
8px_그리드:
  원칙: "모든 간격 값은 4px 배수 (4, 8, 12, 16, 20, 24, 28, 32)"

섹션_간격:
  대블록: "32-48px (예: 좌측패널↔중앙그리드)"
  중블록: "20-24px (예: 섹션 헤더↔콘텐츠)"
  소블록: "12-16px (예: 카드 간 gap, 리스트 아이템 간)"

내부_패딩:
  카드_컨테이너: "20-28px"
  패널: "24-32px (좌우), 20-28px (상하)"
  카드_내부: "12-16px"
  리스트_아이템: "16px (좌우), 12px (상하)"

구분_처리:
  우선순위:
    1: "여백만으로 구분 (24-32px gap)"
    2: "여백 + 배경색 차이 (1단계 차이)"
    3: "여백 + 1px 구분선 (border: 1px solid var(--border-default))"
  금지: "구분선과 배경색 동시 사용"

비율:
  콘텐츠_대_여백: "7:3 (콘텐츠 70%, 여백 30%)"
  카드_이미지_대_텍스트: "이미지 60-70%, 텍스트+패딩 30-40%"
```

---

## F. 타이포그래피 조합 규칙

```yaml
역할별_스타일:
  화면_타이틀: "font-headline, 24-32px, 700, line-height 1.2, letter-spacing 0.5-1px"
  섹션_제목: "font-body, 16-20px, 700, line-height 1.3"
  카드_제목: "font-body, 13-14px, 600, line-height 1.4"
  본문_설명: "font-body, 12-13px, 400, line-height 1.6, text-secondary"
  라벨_메타: "font-body, 10-11px, 600, uppercase, letter-spacing 0.5-1.5px, text-secondary"
  수치_데이터: "font-headline, 20-32px, 700, line-height 1.0, text-primary 또는 accent"

배율_규칙: "인접 위계 간 font-size 비율 최소 1.2x (12→14, 14→17, 16→20)"

금지_조합:
  - "font-headline + 12px 이하"
  - "font-weight 700 + text-disabled"
  - "한글 + letter-spacing 2px 이상"
  - "font-size 10px + line-height 1.0"
```

---

## G. 시각 처리 프리셋 (매직 넘버 근절)

```yaml
그라디언트_프리셋:
  패널_배경: "linear-gradient(180deg, #1e1e24 0%, #1a1a22 100%)"
  오버레이_페이드: "linear-gradient(180deg, transparent 0%, rgba(26,26,34,0.95) 30%, rgba(26,26,34,1) 100%)"
  카드_이미지: "linear-gradient(180deg, rgba(40,40,50,1) 0%, rgba(30,30,38,1) 100%)"
  CTA_버튼: "linear-gradient(180deg, #f2a900 0%, #d4940a 100%)"
  주변광_글로우: "radial-gradient(ellipse 600px 400px at 50% 60%, rgba(242,169,0,0.04) 0%, transparent 70%)"

그림자_프리셋:
  카드_기본: "없음 (border만으로 구분)"
  카드_호버: "0 4px 12px rgba(0,0,0,0.3)"
  카드_선택: "0 0 16px rgba(242,169,0,0.25), inset 0 0 20px rgba(242,169,0,0.05)"
  플로팅_패널: "0 8px 24px rgba(0,0,0,0.4)"
  글로우_도트: "0 0 10px rgba(242,169,0,0.5)"

border_프리셋:
  기본: "1px solid var(--border-default)"
  선택: "2px solid var(--accent-primary)"
  미묘한: "1px solid var(--border-subtle)"

opacity_프리셋:
  미도달_잠김: "opacity: 0.45"
  획득완료_딤: "overlay rgba(0,0,0,0.4)"
  비활성: "opacity: 0.5"

transition_프리셋:
  기본: "all 0.15s ease"
  색상: "color 0.2s, border-color 0.2s"
  위치: "transform 0.2s ease"
  주의: "0.5s 이상 금지 (정적 캡처 시 의미 없음)"

PUBG_장식_요소:
  코너_장식: "패널 모서리에 1-2px 금색 라인 또는 기하학 도형 (택티컬 느낌)"
  육각형_뱃지: "성취/등급/보상 표시에 hexagonal clip-path 사용"
  적용: "선택적 — 모든 화면에 강제 아님, 패스/성취/등급 화면에 적합"
```

---

## H. 컴포넌트 조합 패턴

```yaml
카드+태그+가격:
  구조: "card-image(태그 좌상단 absolute, 가격 우하단) + card-info(아이템명 14px, 등급 10px)"
  간격: "card-image padding 8px, card-info padding 10-12px"

섹션헤더+필터:
  구조: "section-title-area(아이콘+제목 16-20px+카운트 12px) ↔ section-controls(필터 버튼)"
  배치: "justify-content: space-between, margin-bottom 16-20px"

진행률_블록:
  구조: "progress-label(라벨 + 값 accent) + progress-bar(5-8px, radius 4px)"
  색상: "bar-bg: bg-elevated, fill: gradient(accent-primary → accent-secondary)"

정보_라벨+값:
  수평형: "info-label(11px, secondary, uppercase) ↔ info-value(13-14px, primary)"
  수직형: "info-label(10px, secondary, uppercase, ls 1px) 위에 info-value(20-24px, headline)"
```

---

## 셀프 체크리스트

CONTENT_HTML 작성 완료 후 아래 항목을 점검한다:

```yaml
셀프_체크:
  - "[ ] #f2a900 / accent-primary 사용 횟수 ≤ 4"
  - "[ ] 모든 패널 배경이 rgba() 반투명 (솔리드 #1e1e24 등 금지, GNB/Footer 제외)"
  - "[ ] L1/L2/L3 위계가 시각적으로 구분 가능"
  - "[ ] 그라디언트/그림자는 섹션 G 프리셋만 사용 (매직 넘버 없음)"
  - "[ ] 인접 배경색 1단계 이상 차이"
  - "[ ] 타이포그래피 역할별 스타일 준수 (섹션 F)"
  - "[ ] 모든 간격 값이 4px 배수"
  - "[ ] 텍스트 색상 #ffffff 미사용 (#eaeaea 사용)"
```
