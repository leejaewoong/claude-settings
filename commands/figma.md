# /figma — BETTERGROUND Figma 시안 자동 생성

BETTERGROUND 프로덕트 스타일에 맞는 Figma 시안을 자동으로 생성하는 스킬.
ORDO Design System + 기존 화면 스크린샷을 조합하여 HTML을 생성하고 Figma 파일로 캡처한다.

---

## 설정값 로드

이 스킬 실행 시 먼저 `commands/figma/config.md`를 읽어 설정값을 파악한다.

---

## 실행 절차

커맨드 `/figma`가 호출되면 아래 절차를 순서대로 따른다.
각 Phase에 진입할 때 해당 파일을 읽고 그 절차대로 실행한다.

---

### Phase 1: 대화로 화면 확정
- `commands/figma/phase1-dialog.md` 를 읽고 절차대로 실행
- 메뉴 구조 참조: `commands/figma/menu-tree.md`
- 레이아웃 참조: `commands/figma/layout-components.md`

### Phase 2: 스크린샷 참조 파일 선정
- `commands/figma/phase2-screenshots.md` 를 읽고 절차대로 실행

### Phase 3: DS 분석
- `commands/figma/phase3-ds-analysis.md` 를 읽고 절차대로 실행

### Phase 4: HTML 생성
- `commands/figma/phase4-html-generation.md` 를 읽고 절차대로 실행
- 컴포넌트 상세: `commands/figma/components/{이름}.md` 참조
- 컨셉 규칙: `commands/figma/concepts/concept-{A|B|C}.md` — Q8에서 선택된 컨셉 적용
- HTML 생성 완료 후 즉시 Phase 5로 자동 진행

### Phase 5: HTML → Figma 캡처 (최종 산출물)
- `commands/figma/phase5-figma-capture.md` 를 읽고 절차대로 실행
- 멀티 컨셉 시 순차 캡처 (같은 Figma 파일에 컨셉별 페이지 분리)

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
  │   ├─ Q5: 레이아웃 컴포넌트 선택 (GNB/LNB/FOOTER)
  │   │     └─ 프리셋 HTML 확인 (gnb.html / lnb.html / footer.html)
  │   ├─ Q6: 로비 배경 / 캐릭터 모델링 포함 여부
  │   ├─ Q7: 화면 분할 수
  │   └─ Q8: 디자인 컨셉 선택 (A/B/C/모두, 복수 선택 가능)
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
  │   ├─ 레이아웃 컴포넌트: 프리셋에서 로드 → 동적 마커 치환으로 메뉴 상태 반영
  │   ├─ 컨셉별 규칙 로드: concepts/concept-{A|B|C}.md
  │   ├─ 컨텐츠 패턴: dashboard / list_detail / card_grid / form / tabbed
  │   ├─ 멀티 컨셉: 복수 선택 시 Agent 병렬 생성 → 순차 서빙
  │   ├─ Mock 데이터 삽입
  │   ├─ 출력: 인메모리 HTTP 서버 (http://localhost:8765)
  │   └─ 생성 완료 → Phase 5 자동 진행
  │
  └─ Phase 5: HTML → Figma 캡처 (최종 산출물)
      ├─ Puppeteer headless로 백그라운드 캡처 (기본)
      ├─ 캡처 스크립트 삽입 → MCP 호출 (KRAFTON 고정)
      ├─ figmaselector=.layout 으로 1920x1080 정확 캡처
      ├─ polling → 완료 → URL 반환
      ├─ 정리 (서버 종료)
      └─ 에러 시: 단계별 폴백 전략 실행
```

---

## 주의사항

- **디자인 텍스트 국문(한글) 필수**: 시안에 표시되는 모든 텍스트(GNB 탭, 버튼, 라벨, Mock 데이터 등)는 국문(한글)으로 작성. 단, 게이머태그/클랜명/재화명 등 고유명사는 원본(영문) 유지.
- `file://` URL은 CORS 제한으로 캡처 불가 → 반드시 HTTP 서버 사용
- 인메모리 서버 사용 — HTML 파일을 디스크에 저장하지 않음
- captureId는 1회용 → 페이지마다 새로 발급 필요
- 멀티 페이지 캡처 시 첫 캡처만 `newFile`, 이후는 `existingFile`로 동일 fileKey에 추가

---

## 향후 개선 포인트

- [x] ~~SCREENSHOTS_DIR을 프로젝트 폴더로 이전 (팀 공유)~~ → 사용자 경로로 설정 완료
- [x] ~~DS_URL에 실제 ORDO DS Figma URL 및 nodeId 채워넣기~~ → fileKey, 페이지 목록 반영 완료
- [x] ~~DS 컴포넌트 자동 배치 플러그인~~ → Phase 6/7 제거, HTML→Figma 캡처가 최종 산출물
- [x] ~~컴포넌트 사용 가이드~~ → figma.md 매핑 테이블 + commands/figma/components/*.md 상세 가이드
- [ ] 메뉴별 자주 쓰는 컴포넌트 조합 프리셋 추가
- [ ] 캡처 품질 검증 자동화 (캡처 후 스크린샷 비교)
- [ ] 멀티 화면 배치 캡처 지원 (한 번에 여러 경로 지정)
- [x] ~~DS_PAGES 각 페이지별 node-id 매핑~~ → 30개 페이지 전체 node-id 반영 완료
