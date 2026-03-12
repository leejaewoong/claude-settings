# 레이아웃 컴포넌트 (GNB / LNB / FOOTER)

> **필수 참조**: `commands/figma/config.md`의 DS_FILE_KEY, ASSET_DIR

```yaml
LAYOUT_COMPONENTS:

  GNB+LNB:
    설명: "글로벌 헤더 (로고 + GNB 탭 + 글로벌 아이콘 + 재화 + LNB)"
    fileKey: "IbLDVPfcTP8KedJzt5olZw"
    node-id: "5608:59793"
    참조_URL: "https://www.figma.com/design/IbLDVPfcTP8KedJzt5olZw/-%EA%B3%B5%ED%86%B5--PUBG-UI-Kit?m=auto&node-id=5608-59793"
    크기: "1920px x 162px"
    내부_구조:
      GNB_본체: "72px (y:0-72) — 로고(좌) + 탭 9개(중앙, 국문) + 글로벌 아이콘 4개(우)"
      재화바: "52px (y:72-124) — G-COIN, BP, Plus 우측 정렬"
      보조재화바: "38px (y:124-162) — 메뉴별 보조재화 아이콘 우측 정렬"
      LNB: "42px — 재화바+보조재화바에 걸쳐 중앙 배치 (A/D 키힌트 포함)"
    포함요소:
      - PUBG 로고 (좌측)
      - GNB 탭 (중앙, 국문): [Q] 플레이, 패스, 전적, 커스터마이즈, 은신처, 제작소, 상점, 이스포츠, 나만의상점 [E] (9개)
      - 글로벌 아이콘 (우측): 이벤트, 뉴스, 알림센터, 시스템메뉴 (4개)
      - 재화 표시: G-COIN, BP, Plus 상태
      - LNB 서브탭 (중앙): A | 탭1 탭2 탭3 ... | D
    프리셋_경로: "C:\\figma-mockups\\_shared\\gnb.html"
    가이드: "https://ordo.pubg.com/6becdc2a4/p/19c570-global-header"

  LNB_Only:
    설명: "로컬 네비게이션 바 단독 — 헤더 텍스트 + 서브탭"
    fileKey: "IbLDVPfcTP8KedJzt5olZw"
    node-id: "5608:60178"
    참조_URL: "https://www.figma.com/design/IbLDVPfcTP8KedJzt5olZw/-%EA%B3%B5%ED%86%B5--PUBG-UI-Kit?m=auto&node-id=5608-60178"
    크기: "1920px x 162px"
    내부_구조:
      헤더_텍스트: "~120px — 큰 글씨 타이틀"
      서브탭: "~42px — A | 탭1 탭2 탭3 ... | D"
    포함요소:
      - 헤더 텍스트 (화면 타이틀)
      - 탭 버튼 (Normal/Selected 상태)
      - 키보드 단축키 표시 (A/D)
    프리셋_경로: "C:\\figma-mockups\\_shared\\lnb.html"
    참고: "탭 텍스트는 Phase 1에서 확정된 메뉴의 2뎁스 항목으로 동적 교체"

  FOOTER:
    설명: "하단 푸터 (액션 버튼 + 소셜 그룹)"
    fileKey: "IbLDVPfcTP8KedJzt5olZw"
    node-id: "5647:1006"
    크기: "1920px x 56px"
    포함요소:
      좌측_버튼그룹:
        - ESC (닫기)
        - Primary 버튼 (최대 1개)
        - Secondary 버튼 (최대 2개)
      우측_소셜그룹:
        - 채팅 위젯
        - 팀 파인더
        - 팀 슬롯 (최대 4인)
        - 소셜 (친구 수)
        - 클랜
    프리셋_경로: "C:\\figma-mockups\\_shared\\footer.html"
    가이드: "https://ordo.pubg.com/6becdc2a4/p/12c87d-footer"

  프리셋_사용:
    방법: |
      1. 프리셋 HTML 파일을 읽는다
      2. 동적 마커를 Phase 1에서 확정된 값으로 치환한다
      3. 치환된 HTML을 메인 템플릿에 삽입한다
    동적_마커:
      "{{ACTIVE_TAB}}": "활성 GNB 탭 (Phase 1 Q1 — 1뎁스 메뉴)"
      "{{LNB_TABS}}": "LNB 탭 텍스트 배열 (Phase 1 Q2 — 2뎁스 항목, 쉼표 구분)"
      "{{ACTIVE_LNB_TAB}}": "활성 LNB 탭 (Phase 1 Q3 — 3뎁스 또는 2뎁스 첫 항목)"
      "{{FOOTER_BUTTONS}}": "좌측 액션 버튼 텍스트 (화면별 다름, 쉼표 구분)"
      "{{HEADER_TEXT}}": "LNB Only 사용 시 화면 타이틀"
      "{{ASSET_DIR}}": "config.md의 ASSET_DIR 절대경로 (에셋 이미지 참조)"
    보조재화_에셋_매핑:
      은신처(HIDEOUT): "아이콘_은신처_보조재화1~4.png (4개)"
      제작소(WORKSHOP): "아이콘_제작소_보조재화1~3.png (3개)"
      패스(PASS): "아이콘_패스_보조재화1.png (1개)"
      이스포츠: "아이콘_이스포츠_보조재화1~2.png (2개, 랜덤 풀에 포함)"
      기타_메뉴: "전체 보조재화 아이콘 풀에서 2~3개 랜덤 선택하여 배치 (빈 영역 방지)"
    보조재화_자동_배치:
      규칙: "gnb.html 스크립트가 {{ACTIVE_TAB}} 기반으로 자동 처리"
      매핑_메뉴: "HIDEOUT, WORKSHOP, PASS → 해당 메뉴 전용 보조재화 아이콘 + Mock 수치"
      비매핑_메뉴: "PLAY, CAREER, CUSTOMIZE, STORE 등 → 전체 풀에서 랜덤 2~3개 선택"
    에셋_경로: "ASSET_DIR (config.md 참조) — SCREENSHOTS_DIR/에셋/"
    갱신_시점:
      - DS 업데이트 후 사용자가 요청할 때
      - 프리셋 파일 수동 수정 시
    갱신_방법: "프리셋 HTML 파일을 직접 편집하거나, Figma 참조 URL에서 최신 디자인을 확인 후 반영"
```
