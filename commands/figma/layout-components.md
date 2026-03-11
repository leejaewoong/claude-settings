# 레이아웃 컴포넌트 (GNB / LNB / FOOTER)

> **필수 참조**: `commands/figma/config.md`의 DS_FILE_KEY

```yaml
LAYOUT_COMPONENTS:

  GNB:
    설명: "글로벌 헤더 (로고 + GNB 탭 + 글로벌 아이콘 + 재화)"
    fileKey: "IbLDVPfcTP8KedJzt5olZw"
    node-id: "5608:59792"
    크기: "1920px x 72px (+ Currency 바 52px)"
    포함요소:
      - PUBG 로고 (좌측)
      - GNB 탭 (중앙): 플레이, 패스, 전적, 커스터마이즈, 은신처, 제작소, 상점 등
      - 글로벌 아이콘 (우측): OES, 뉴스, 알림센터, 설정
      - 재화 표시: G-COIN, BP, Plus 상태
    캐시_경로: "C:\figma-mockups\_shared\gnb.html"
    가이드: "https://ordo.pubg.com/6becdc2a4/p/19c570-global-header"

  LNB:
    설명: "로컬 네비게이션 바 — GNB 컴포넌트의 탭=서브-센터 variant 활용"
    fileKey: "IbLDVPfcTP8KedJzt5olZw"
    node-id: "5608:60178"
    크기: "가변 너비, 탭 개수에 따라"
    포함요소:
      - 탭 버튼 (Normal/Selected 상태)
      - 키보드 단축키 표시 (A/D)
    캐시_경로: "C:\figma-mockups\_shared\lnb.html"
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
        - 클랜
        - 소셜 (친구 수)
        - 팀 슬롯 (최대 4인)
        - 팀 파인더
        - 채팅 위젯
    캐시_경로: "C:\figma-mockups\_shared\footer.html"
    가이드: "https://ordo.pubg.com/6becdc2a4/p/12c87d-footer"

  캐시_관리:
    최초_생성: |
      1. mcp__figma__get_design_context로 각 컴포넌트 추출
      2. React+Tailwind 코드를 순수 HTML+CSS로 변환
      3. C:\figma-mockups\_shared\ 에 저장
    갱신_시점:
      - DS 업데이트 후 사용자가 요청할 때
      - 캐시 파일이 없을 때 (최초 실행)
    갱신_방법: "사용자가 '레이아웃 갱신' 요청 시 MCP 재추출 → 캐시 덮어쓰기"
```
