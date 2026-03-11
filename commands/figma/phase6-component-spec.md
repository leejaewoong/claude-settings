# Phase 6: component-spec.json 생성 (필수)

> **필수 참조**: `commands/figma/config.md`의 DS_PAGES
> **컴포넌트 상세**: `commands/figma/components/{이름}.md` — customNodes 모사 시 색상·크기 참조

HTML 생성(Phase 4) 완료 후, ORDO Component Placer 플러그인용 컴포넌트 배치 스펙을 JSON으로 **반드시** 생성한다.
이 파일은 캡처된 HTML 위에 레이아웃 DS 컴포넌트 + customNodes를 자동 배치하기 위한 핵심 산출물이다.

## 생성 속도 최적화 (필수)

```yaml
속도_원칙: "반복 노드는 좌표만 변경, 공통 속성은 1회만 결정"

생성_순서:
  Step_1: "layout 배열 작성 (GNB/FOOTER — 고정값이므로 즉시)"
  Step_2: "콘텐츠 영역의 큰 frame 먼저 (배경 패널, 사이드바 등)"
  Step_3: "반복 요소는 '1개 상세 + N개 좌표 오프셋' 패턴으로 일괄 생성"
  Step_4: "검증은 JSON 완성 후 1회만 실행"

반복_노드_일괄_생성:
  원칙: |
    동일 구조의 반복 요소(아이템 카드, 리스트 행, 탭 등)는
    첫 번째 아이템만 모든 속성을 결정하고,
    나머지는 x/y 좌표와 변하는 텍스트(characters)만 변경한다.

  그리드_좌표_계산:
    공식: |
      x = startX + (col * (itemWidth + gapX))
      y = startY + (row * (itemHeight + gapY))
      col = index % columns
      row = Math.floor(index / columns)
    예시_5열_10개: |
      startX=344, startY=192, itemWidth=174, itemHeight=210, gapX=12, gapY=12, columns=5
      → 아이템[0]: x=344, y=192
      → 아이템[1]: x=530, y=192
      → 아이템[4]: x=1088, y=192
      → 아이템[5]: x=344, y=414  (다음 행)

  리스트_좌표_계산:
    공식: "y = startY + (index * (itemHeight + gap))"
    예시: "startY=200, itemHeight=48, gap=4 → [200, 252, 304, 356, ...]"

  공통_속성_1회_결정:
    설명: "첫 아이템에서 결정한 속성을 나머지에 복사"
    복사_대상: ["type", "width", "height", "fill", "cornerRadius", "fontSize", "fontFamily", "fontStyle", "stroke", "strokeWeight"]
    변경_대상: ["x", "y", "name", "characters"]
```

## 핵심 원칙

```yaml
# ═══════════════════════════════════════════════════════════
# 레이아웃 전용 DS + 전면 customNodes 모사 모드
# ═══════════════════════════════════════════════════════════
#
# DS 컴포넌트는 GNB, LNB, FOOTER **레이아웃만** 사용한다.
# 나머지 모든 UI(버튼, 태그, 아이템 슬롯, 모달 등)는
# customNodes(frame/rect/text/line)로 직접 모사한다.
#
# 모사 시 commands/figma/components/{이름}.md 파일을 참조하여
# 원본 컴포넌트의 색상, 크기, 간격, 상태별 스타일을 정확히 반영한다.
#
# ═══════════════════════════════════════════════════════════

DS_사용범위:
  layout_배열: "GNB, LNB, FOOTER만 DS 컴포넌트로 사용"
  content_배열: "항상 빈 배열 []"
  customNodes_배열: "레이아웃 외 모든 UI를 frame/rect/text/line으로 직접 구성"

컴포넌트_md_역할:
  용도: "customNodes 모사 시 참조 자료"
  참조_항목:
    - "색상 정보 (배경, 텍스트, border, 등급별 색상)"
    - "크기 범위 (높이, 너비, padding)"
    - "상태별 스타일 (Default, Hover, Selected, Disabled)"
    - "모사 패턴 (customNodes JSON 예시)"
```

## 스펙 구조

```json
{
  "name": "메뉴경로_화면명",
  "width": 1920,
  "height": 1080,
  "layout": [
    {
      "component": "GNB",
      "variant": "탭=Pass, 서브페이지=True, 사이드 정렬=False",
      "x": 0, "y": 0,
      "width": 1920, "height": 168,
      "textOverrides": { "Tab1": "보상", "Tab2": "미션" }
    },
    {
      "component": "FOOTER",
      "variant": "Console=False, 우측 표시=On",
      "x": 0, "y": 1024,
      "width": 1920, "height": 56,
      "hideNonOverriddenButtons": true
    }
  ],
  "content": [],
  "customNodes": [
    {
      "name": "배경 패널",
      "type": "frame",
      "x": 0, "y": 168,
      "width": 320, "height": 856,
      "fill": "#1e1e24"
    },
    {
      "name": "Primary 버튼",
      "type": "rect",
      "x": 44, "y": 968,
      "width": 200, "height": 44,
      "fill": "#f2a900",
      "cornerRadius": 4
    },
    {
      "name": "버튼 텍스트",
      "type": "text",
      "x": 60, "y": 980,
      "width": 168, "height": 20,
      "characters": "선택 보상 획득 (200P)",
      "fontSize": 14,
      "fontFamily": "Inter",
      "fontStyle": "Bold",
      "fill": "#1a1a22",
      "textAlignHorizontal": "CENTER"
    }
  ]
}
```

## 생성 규칙

```yaml
component_spec_생성:

  레이아웃_매핑:
    - Phase 1 Q5에서 선택한 레이아웃 컴포넌트를 layout 배열에 추가
    - content 배열은 항상 빈 배열 []

  # ═══════════════════════════════════════════════════════════
  # GNB + LNB 통합 규칙 (중복 배치 방지)
  # ═══════════════════════════════════════════════════════════
  #
  # LNB(서브-센터)는 Global Header PC를 이미 포함.
  # GNB와 LNB를 모두 layout에 넣으면 Global Header가 2개 렌더링됨.
  # 반드시 아래 규칙에 따라 단일 컴포넌트로 통합한다.
  #
  # ═══════════════════════════════════════════════════════════

  GNB_LNB_통합:
    설명: "GNB와 LNB를 동시 선택 시 GNB 하나로 통합. 별도 LNB 배치 금지."
    규칙:
      GNB+LNB: |
        layout에 GNB 1개만 배치.
        variant: "탭={1뎁스 메뉴}, 서브페이지=True, 사이드 정렬=False"
        x=0, y=0, width=1920, height=168
        textOverrides: LNB의 Tab1/Tab2 등 서브 탭 텍스트를 GNB에 합산
      LNB만: |
        layout에 LNB 1개만 배치.
        variant: "Default"
        x=0, y=0, width=1920, height=168
        (Global Header PC가 LNB 서브-센터에 자동 포함)
    안전_영역: "콘텐츠 시작 y=168"
    금지: "GNB + LNB 2개를 동시에 layout에 넣지 않는다"

  GNB_variant_매핑:
    설명: "Phase 1 Q1에서 선택한 1뎁스 메뉴에 따라 variant 결정 (서브페이지는 LNB 선택 여부에 따름)"
    매핑:
      플레이: "탭=Play"
      패스: "탭=Pass"
      전적: "탭=Career"
      커스터마이즈: "탭=Customize"
      은신처: "탭=Hideout"
      제작소: "탭=Workshop"
      상점: "탭=Store"
      클랜: "탭=E-sport"
      카카오: "탭=Kakao"
    서브페이지:
      GNB+LNB: "서브페이지=True"
    공통: "사이드 정렬=False"
    예시: "탭=Pass, 서브페이지=True, 사이드 정렬=False"

  LNB_처리:
    설명: "GNB 컴포넌트의 탭=서브-센터 variant를 LNB로 활용"
    variant: "Default"
    참고: |
      - LNB는 독립 컴포넌트가 아니라 GNB의 서브페이지 variant
      - 플러그인 레지스트리에서 LNB.variants.Default → GNB 서브-센터 key로 매핑됨
      - textOverrides로 탭 텍스트 변경 (2뎁스 메뉴 항목)
      - GNB+LNB 동시 선택 시: LNB를 별도 배치하지 않고 GNB에 서브페이지=True로 통합

  FOOTER_처리:
    variant_매핑:
      PC_화면: "Console=False, 우측 표시=On"
      콘솔_화면: "Console=True, 우측 표시=On"
    위치: "x=0, y=1024, width=1920, height=56"
    우측_표시: "항상 '우측 표시=On' 포함 — 우측 닉네임/레벨 영역 표시"
    버튼_숨김:
      설명: "textOverrides에 지정하지 않은 FOOTER 내부 버튼은 자동 숨김"
      적용: "hideNonOverriddenButtons: true를 FOOTER 항목에 추가"
      예시_모든버튼숨김: |
        { "component": "FOOTER", "variant": "Console=False, 우측 표시=On",
          "hideNonOverriddenButtons": true }
        → 좌측 버튼 그룹(ESC, Primary, Secondary) 모두 숨김, 우측 닉네임/레벨 표시
      예시_일부표시: |
        { "component": "FOOTER", "variant": "Console=False, 우측 표시=On",
          "textOverrides": { "Primary": "구매하기" },
          "hideNonOverriddenButtons": true }
        → Primary 버튼만 표시, 나머지 숨김, 우측 닉네임/레벨 표시

  # ═══════════════════════════════════════════════════════════
  # customNodes 모사 규칙
  # ═══════════════════════════════════════════════════════════

  customNodes_모사:
    원칙: |
      모든 UI 요소(버튼, 태그, 슬롯, 모달 등)를 customNodes로 직접 구성한다.
      HTML의 CSS 레이아웃을 참조하여 좌표(x, y)를 결정한다.
      단, 크기(width, height)는 commands/figma/components/{이름}.md의
      공식 규격을 우선 적용하고, HTML 크기는 참고만 한다.
      색상·스타일도 .md 파일을 따른다.

    크기_결정_우선순위:
      1순위: "components/{이름}.md의 공식 크기 규격"
      2순위: "HTML CSS에서 추출한 크기 (1순위가 없는 커스텀 영역)"
      3순위: "스크린샷에서 추정한 크기 (1, 2순위 모두 없을 때)"

    버튼_모사:
      참조: "commands/figma/components/SquareButton.md"
      패턴: |
        Primary: rect(fill=#f2a900, cornerRadius=4) + text(fill=#1a1a22, fontStyle=Bold)
        Secondary: rect(fill=#222228, stroke=#333340, cornerRadius=4) + text(fill=#eaeaea)
        Disabled: rect(fill=#333340, cornerRadius=4) + text(fill=#555555)
      크기:
        XSmall: "높이 26"
        Small: "높이 32"
        Default: "높이 44"
        Large: "높이 54"
        XLarge: "높이 64"

    태그_모사:
      참조: "commands/figma/components/Tag.md"
      패턴: "rect(fill=등급/타입별 색상, cornerRadius=2~4) + text(fontSize=10~13)"
      색상_매핑:
        Yellow: "fill=#f2a900, text=#1a1a22"
        Red: "fill=#ff5252, text=#ffffff"
        Purple: "fill=#ab47bc, text=#ffffff"
        Blue: "fill=#4fc3f7, text=#1a1a22"
        Black: "fill=#2a2a35, text=#eaeaea"
        White: "fill=#eaeaea, text=#1a1a22"
        Premium: "fill=#f2a900, text=#1a1a22"

    아이템슬롯_모사:
      참조: "commands/figma/components/ItemSlot.md"
      패턴: "frame(fill=#1e1e24, cornerRadius=4, stroke=등급색상) + rect(이미지 placeholder)"
      등급_색상:
        Classic: "#8b8b8b"
        Rare: "#4fc3f7"
        Epic: "#ab47bc"
        Legendary: "#f2a900"
      상태:
        Default: "strokeWidth=1"
        Select: "strokeWidth=2"
        Acquired: "+ rect(fill=#000000, opacity=0.4) + text('✓', fill=#5a9a6a)"

    모달_모사:
      참조: "commands/figma/components/Modals.md"
      패턴: |
        1. rect 딤 (1920×1080, fill=#000000, opacity=0.7)
        2. frame 배경 (fill=#1e1e24, cornerRadius=8, stroke=#2a2a35)
        3. text 타이틀 (fontSize=20, Bold, fill=#eaeaea)
        4. rect 닫기 버튼 (32×32, fill=#222228, stroke=#333340)
        5. 내부 콘텐츠 (text/line/rect로 구성)

    기타_컴포넌트:
      설명: "각 컴포넌트의 md 파일에 '모사 패턴 (customNodes)' 섹션 참조"
      목록:
        - "ContentSwitch → ContentSwitch.md 참조"
        - "Tabs → rect(배경) + rect(활성탭) + text(탭명) × N"
        - "Table → rect(헤더) + rect(행) + text(셀)"
        - "List → frame(배경) + text(항목) + line(구분선)"
        - "SideTab → frame(패널) + rect(선택 인디케이터) + text(탭명)"
        - "Tooltip → frame(배경) + text(제목) + text(내용)"
        - "Dropdowns → rect(트리거) + text(값) + text(▼)"
        - "MissionList → rect(항목) + text + rect(진행바)"
        - "FooterButton → rect(배경) + text(타이틀/설명)"

  # ═══════════════════════════════════════════════════════════
  # 레이아웃 규칙
  # ═══════════════════════════════════════════════════════════

  레이아웃_충돌_방지:
    안전_영역:
      설명: "GNB(+LNB)/FOOTER와 겹치지 않는 콘텐츠 배치 영역"
      헤더_영역: "y: 0 ~ 168 (GNB 서브페이지=True 또는 LNB 단독)"
      FOOTER_영역: "y: 1024 ~ 1080"
      콘텐츠_안전_영역: "x: 0, y: 168, width: 1920, height: 856"
      규칙: "customNodes의 모든 요소는 안전 영역 내에 배치 (모달 딤 제외)"

    컴포넌트_간_마진:
      수직_최소_마진: 8
      수평_최소_마진: 8
      그리드_아이템_간격: "12-16"
      섹션_간_간격: "24-32"

    프레임_경계_준수:
      규칙: |
        모든 요소는 루트 프레임(1920×1080) 안에 완전히 포함되어야 한다.
        x + width <= 1920, y + height <= 1080
        모달 화면의 딤 오버레이(1920×1080)만 예외.

  # ═══════════════════════════════════════════════════════════
  # 노드 생성 규칙 (생성 중 참조)
  # ═══════════════════════════════════════════════════════════

  노드_생성_규칙:
    폰트: "text 노드의 fontFamily는 항상 'Inter' (Pretendard 등 커스텀 폰트 금지)"
    카드_내부_필수: "frame(외곽) + rect(이미지) + text(아이템명) + text(등급명)"
    보조_UI: "네비 뱃지, 화폐 아이콘, 진행바, 경고 메시지 등 보이는 것은 모두 노드로 생성"

  # ═══════════════════════════════════════════════════════════
  # 최종 검증 (JSON 출력 직전 1회만 실행)
  # ═══════════════════════════════════════════════════════════
  #
  # 생성 중에는 검증하지 않는다. JSON 전체를 완성한 뒤 1회만 아래를 확인한다.
  #

  최종_검증:
    1_필수_필드:
      루트: "name(string), width(1920), height(1080), layout(array), content([]), customNodes(array, 1개↑)"
      layout_항목: "component, variant, x, y, width, height + GNB→textOverrides, FOOTER→hideNonOverriddenButtons"
      customNodes_항목:
        공통: "name, type, x, y, width, height"
        frame_rect: "+ fill"
        text: "+ characters, fontSize, fontFamily(Inter), fontStyle, fill"
        line: "+ fill, strokeWeight"

    2_크기_검증:
      SquareButton: "높이 26/32/44/54/64 중 하나"
      ItemSlot: "40-350px 범위"
      Modal: "너비 660/760/960"
      SideTab: "패널 200-280px"
      Tag: "높이 16-32px"
      위반_시: "DS 규격으로 보정"

    3_경계_검증: "모든 노드: x+width≤1920, y+height≤1080 (모달 딤 제외)"

    4_타입_검증: "x/y/width/height/fontSize는 number, fill은 #hex — 불일치 시 자동 보정"
```

## 출력 경로 (화면별 파일 분리)

```yaml
파일_분리_규칙:
  원칙: "Phase 1 Q7에서 결정한 화면 수만큼 개별 JSON 파일을 생성한다"
  단일_화면: "component-spec.json 1개"
  복수_화면: "component-spec-1.json, component-spec-2.json, ... 화면별 1개씩"

  파일명_형식: "component-spec-{순번}.json (순번은 1부터)"
  예시:
    단일: "C:\figma-mockups\패스_보상\component-spec.json"
    복수:
      - "C:\figma-mockups\패스_보상\component-spec-1.json  (보상 목록 화면)"
      - "C:\figma-mockups\패스_보상\component-spec-2.json  (보상 상세 화면)"
      - "C:\figma-mockups\패스_보상\component-spec-3.json  (구매 확인 모달)"

  각_파일_구조:
    설명: "각 JSON은 독립적인 완전한 스펙 (name, width, height, layout, content, customNodes 포함)"
    name_규칙: "메뉴경로_화면설명 (예: '패스_보상_목록', '패스_보상_상세')"

  장점:
    - "플러그인에서 화면별로 개별 실행 가능"
    - "Figma에 화면별 별도 프레임 생성"
    - "JSON 파일 크기 축소 → 생성 속도 향상"
```
