# Phase 5: HTML → Figma 캡처 (최종 산출물)

> **필수 참조**: `commands/figma/config.md`의 FIGMA_PLAN_KEY, FIGMA_DELAY

## 사전 체크리스트

```yaml
캡처_전_확인:

  1_HTTP_서버:
    확인: "로컬 서버가 실행 중인가?"
    명령: "lsof -i :8765 || netstat -an | grep 8765"
    실패시: "서버 시작 후 재시도"

  2_HTML_렌더링:
    확인: "http://localhost:8765 접근 가능? (Phase 4 인메모리 서버)"
    방법: "curl -s -o /dev/null -w '%{http_code}' http://localhost:8765"
    기대값: "200"

  3_캡처_스크립트:
    확인: "capture.js 삽입은 Step_2에서 서버 재시작 시 처리"
    코드: '<script src="https://mcp.figma.com/mcp/html-to-design/capture.js" async></script>'

  4_Figma_MCP:
    확인: "MCP 서버 연결 상태"
    방법: "/mcp 명령으로 확인"
```

## 캡처 실행 절차

```yaml
Step_1_서버_확인:
  설명: "Phase 4에서 이미 인메모리 서버가 실행 중"
  확인: "curl -s -o /dev/null -w '%{http_code}' http://localhost:8765 → 200"
  실패시: "Phase 4의 인메모리 서버 명령 재실행"

Step_2_캡처_스크립트_삽입:
  설명: "capture.js를 포함한 HTML로 서버 재시작"
  절차:
    1: "기존 서버 프로세스 종료"
    2: "HTML 문자열의 </body> 직전에 capture.js 스크립트 태그 추가"
    3: "수정된 HTML로 인메모리 서버 재시작 (Phase 4와 동일 명령)"
  삽입: '<script src="https://mcp.figma.com/mcp/html-to-design/capture.js" async></script>'
  주의: "중복 삽입 금지"

Step_3_캡처_호출:

  첫_캡처:
    호출: |
      mcp__figma__generate_figma_design(
        outputMode: "newFile",
        fileName: "{{메뉴경로}} 시안",
        planKey: FIGMA_PLAN_KEY  # "organization::1460451802116636798" (KRAFTON, Inc.)
      )
    주의: "팀 선택 질문 생략 — 항상 KRAFTON, Inc. 조직에 생성"
    결과: "captureId 획득"

  추가_캡처:
    호출: |
      mcp__figma__generate_figma_design(
        outputMode: "existingFile",
        fileKey: "{{저장된_fileKey}}"
      )
    결과: "captureId 획득"

Step_3.5_헤드리스_캡처:
  설명: "Puppeteer headless로 캡처 URL을 백그라운드에서 로드 (브라우저 창 없음)"
  URL_형식: |
    {{BASE_URL}}#figmacapture={{captureId}}&figmaendpoint={{endpoint}}&figmadelay={{FIGMA_DELAY}}&figmaselector=.layout
  핵심_파라미터:
    figmaselector: ".layout"  # OUTPUT_WIDTH x OUTPUT_HEIGHT (1920x1080) 프레임 정확히 캡처
    figmadelay: "FIGMA_DELAY 값 사용 (기본 3000ms)"

  실행_명령: |
    NODE_PATH="$(npm root -g)" node -e "
    const puppeteer = require('puppeteer');
    (async () => {
      const browser = await puppeteer.launch({ headless: 'new', args: ['--no-sandbox', '--window-size=1920,1080'] });
      const page = await browser.newPage();
      await page.setViewport({ width: 1920, height: 1080 });
      const url = 'http://localhost:8765#figmacapture={{captureId}}&figmaendpoint={{endpoint}}&figmadelay={{FIGMA_DELAY}}&figmaselector=.layout';
      await page.goto(url, { waitUntil: 'networkidle0', timeout: 30000 });
      // capture.js가 DOM 캡처 + 전송 완료할 때까지 대기
      await page.waitForFunction(() => window.__figmaCaptureComplete === true, { timeout: 20000 }).catch(() => {});
      // 폴백: capture.js가 플래그를 설정하지 않을 경우 figmadelay + 여유 시간 대기
      await new Promise(r => setTimeout(r, {{FIGMA_DELAY}} + 5000));
      await browser.close();
      console.log('Headless capture complete');
    })().catch(e => { console.error(e); process.exit(1); });
    "

  사전_설치:
    확인: "npm list -g puppeteer 2>/dev/null || echo 'not installed'"
    설치: "npm install -g puppeteer"
    참고: "Chromium이 자동 다운로드됨 (~170MB, 최초 1회)"

  폴백_수동_브라우저:
    조건: "Puppeteer 설치 불가 또는 headless 캡처 실패 시"
    명령: |
      start "" "http://localhost:8765#figmacapture={{captureId}}&figmaendpoint={{endpoint}}&figmadelay={{FIGMA_DELAY}}&figmaselector=.layout"
    안내: "브라우저 창이 열립니다. 캡처 완료 후 자동으로 닫아도 됩니다."

Step_4_완료_대기:
  방법: "captureId로 generate_figma_design 재호출하여 polling"
  간격: "5초 간격, 최대 10회"
  완료조건: "status가 completed → fileKey 및 URL 획득"

Step_5_정리:
  작업:
    - 인메모리 서버 프로세스 종료
  보존: "디스크에 저장된 파일 없음 — 재캡처 시 Phase 4부터 재실행"
```

## 에러 핸들링

```yaml
에러_처리:

  캡처_타임아웃:
    증상: "15초 후에도 URL 미반환"
    대응:
      1: "figmadelay를 5000으로 올려 재시도"
      2: "JS 동적 요소를 정적으로 변환 후 재시도"
      3: |
        ⚠️ 캡처가 타임아웃되었습니다.
        HTML은 생성되었으니 수동 캡처를 시도해주세요.

  캡처_깨짐:
    증상: "Figma에서 레이아웃이 원본과 다름"
    대응:
      1: "CSS Grid → absolute positioning 변환"
      2: "웹폰트 → base64 인라인 임베드"
      3: "외부 이미지 → base64 인라인 변환"

  기존_파일_추가_실패:
    증상: "existingFile 모드에서 fileKey 무효"
    대응:
      1: "fileKey 재확인"
      2: "newFile로 새로 생성"
      3: "사용자에게 기존 파일에 수동 페이지 이동 안내"

  MCP_연결_끊김:
    메시지: |
      ⚠️ Figma MCP 연결이 끊어졌습니다.
      1. /mcp 명령으로 상태 확인
      2. Figma 앱이 열려 있는지 확인
      3. MCP 서버 재시작 후 재시도
```

## 멀티 페이지 캡처

```yaml
멀티_캡처:
  절차:
    1: "첫 번째 화면 → outputMode: newFile → fileKey 획득"
    2: "이후 화면 → outputMode: existingFile, 동일 fileKey"
    3: "각 페이지마다 pageName 다르게 지정"
    4: "각 캡처 사이 5초 대기 (API 레이트 제한 방지)"

  주의사항:
    - captureId는 1회용 → 매 캡처마다 새 HTML 로드 필요
    - 같은 HTML 재캡처 시 브라우저 새로고침 필요
    - 최대 연속 캡처: 10페이지 (이후 새 파일 생성 권장)
```
