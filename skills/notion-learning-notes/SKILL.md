---
name: notion-learning-notes
description: Organizes and summarizes learned content by writing directly to Notion pages via Notion MCP, with visual concepts rendered through the visualize skill and attached as images. Activates when user wants to organize or summarize learning with phrases like '학습 내용 정리', '지금까지 배운 것 정리', '노트 정리', 'summarize what we learned', 'organize learning notes', '노션으로 정리', '노션 페이지 생성', or when requesting structured documentation of learned concepts.
---

# Notion-Based Learning Notes Skill

## Core Purpose

Transform learning conversations into well-structured Notion pages, written directly via Notion MCP. Concepts that need visualization are built with the `visualize` skill (HTML), captured as images, and attached to the page.

---

### 1. Heading Structure

```markdown
## 📚 Main Topic (H2 with emoji)
### Subtopic (H3 without emoji)
#### Key Concept (H4 without emoji)
```

**Only H2 headings use emoji** - keeps table of contents clean.

H3 should convey meaning without reading content.

❌ Vague: "### 기본 사용법"
✅ Clear: "### useState 선언과 상태 업데이트 방법"

### 2. Code Formatting

- **Inline code**: `variableName`, `functionName()`, technical terms only
- **Code blocks**: For actual code examples; remove empty line at end
- **Non-code emphasis**: Use **bold**, NOT inline code
- Explanatory notes for commands may be merged into code blocks as `#` comments instead of separate prose

### 3. Callout Blocks

Use Notion callout blocks (not plain blockquotes):

- First line inside callout: `> **제목**` (bold title, quote-marked)
- **No emoji in callout titles** (💡/⚠️/✅ 사용 금지)
- Title in noun-form, not question form
  - ❌ "왜 frontend에만 EIP?"
  - ✅ "frontend에만 EIP 적용 이유"
- Body: if 2+ points, split into bullet list; avoid long single paragraphs
- Page-top overview callout: 📢 icon + gray background, bold title (e.g. "실습 목표") + numbered goal list

### 4. Toggle Blocks for Supplementary Content

- Deep-dive or supplementary content goes into toggle blocks (e.g. 용어 상세 설명, 긴 코드블록)
- Toggle summary title in **bold**
- Tables, callouts, and code blocks may be nested inside toggles

### 5. Tables

- **Table width**: fill the full page width (지정된 페이지 너비를 가득 채움)
- **Column widths**: proportional to each column's content, with generous padding (내용에 비례 + 여백 넉넉하게); **no cell wraps**, **no horizontal scroll** (줄바꿈 최소화, 가로 스크롤 발생 금지)
- Use **row background colors** to distinguish groups/tiers (e.g. blue_bg / purple_bg / green_bg)
- For grouped rows, write the group name **only on the first row**; leave repeated cells empty
- Command cells: **bold + inline code** combination (e.g. **`git pull`**)
- Header cells: bold

---

## Visualization Workflow (visualize skill + image attach)

Notion blocks and Mermaid are limited for rich information visualization. For concepts where structure, flow, or comparison would be poorly served by text/tables:

1. **Identify** visual concepts: architectures, request/data flows, anatomy breakdowns (e.g. URL 구조 분해), layered comparisons
2. **Build** the visual as an HTML artifact using the `visualize` skill (read `/mnt/skills/user/visualize/SKILL.md` first)
3. **Capture** each visual region as PNG via Playwright:
   - Element-level screenshots by CSS selector / XPath
   - `device_scale_factor=2` for high resolution
   - Capture-time CSS injection allowed for layout adjustments (e.g. column → row restructuring)
   - Numbered filenames: `01_architecture.png`, `02_origin_anatomy.png`, …
4. **Attach**: Notion MCP cannot upload local files. In the page, insert a placeholder callout at each image position:
   - `> 🖼️ 이미지 첨부 자리 — \`<filename>.png\` 파일을 여기에 드래그`
   - Present all PNG files to the user and instruct them to drag each into place and delete the placeholder

---

## Content Rules

- **No page icon**: create pages without an icon (페이지 아이콘 미포함)
- **Privacy generalization**: replace personal identifiers with placeholders
  - Real repo names → `<Repo URL>`, usernames → `<User Name>`, PAT URLs → `<PAT>`
  - Vendor-specific keys → generic terms (e.g. `Anthropic API 키` → "LLM API 키")
- **No version footer** (Version / Last Updated / Topic 미포함)
- **Integrate follow-up Q&A**: answers to questions asked after page creation should be added into the page (typically as toggle blocks at the relevant section)
- Organize by logical concept hierarchy, not chronological order
- Include practical examples (개념 → 예시 → 활용)

---

## Sensitive Information Handling (mandatory pre-publish check)

Before creating the Notion page AND before capturing any image, scan all content for sensitive values and sanitize them.

### Detection Targets

| 분류 | 예시 | 민감도 |
|---|---|---|
| 자격 증명 | API 키, 토큰, PAT, 비밀번호, `.pem` 키 파일명 | 높음 — 항상 마스킹 |
| 공인 IP / EIP | `3.x.x.x` 등 외부 도달 가능 주소 | 높음 — 항상 마스킹 |
| 사설 IP | `172.31.x.x`, `10.x.x.x`, `192.168.x.x` | 중간 — 내부 토폴로지 정찰에 악용 가능, 문서에서는 마스킹 |
| 계정 식별자 | AWS 계정 ID, 실명, 사용자명, 실명 레포 주소, 이메일 | 높음 — 플레이스홀더화 |
| 인프라 고유값 | SG ID, 인스턴스 ID, VPC ID, 도메인 | 중간 — 플레이스홀더화 |

**Principle**: 인바운드 규칙(SG 등)이 있어도 IP는 노출 금지. 방어는 다층(defense-in-depth)이며, 주소 공개는 스캔·표적 공격의 시작점이 됨. 공인 IP는 직접 공격 표면, 사설 IP는 내부 구조 정보.

### Text Handling — Generalization

Replace with semantic placeholders that preserve learning value:
- `3.34.158.24` → `<EIP>` / `x.x.x.x`
- `172.31.42.205` → `<BACKEND_PRIVATE_IP>` / `172.31.x.x`
- `jaewoong-work.pem` → `<key>.pem`
- `leejaewoong/en-calendar` → `<User Name>/<Repo>`
- `Anthropic API 키` → "LLM API 키"

### Image Handling — Source Replacement first, Blur second

1. **Preferred — capture-time replacement**: before screenshot, inject JS/CSS into the HTML to swap real values with placeholders (text remains readable, learning value preserved)
2. **Fallback — blur**: if source cannot be modified, apply `filter: blur(6px)` to the element at capture time, or post-process the PNG region (PIL `GaussianBlur`)
3. Never publish an image without this check — images bypass text-based scanning, so they are the most common leak path

---

## Language Rules

### Bilingual Terms

**형식**: 한국어(English)

예시: 상태(State), 훅(Hook), 렌더링(Rendering)

### Sentence Style

**명사형 종결, 문장형 종결 금지**

❌ Wrong: useState는 상태를 관리합니다.
✅ Correct: useState를 통한 상태 관리

---

## Process

### Step 1: Analyze & Plan
- Identify key topics and concepts from the conversation
- Mark which concepts need visualization (visualize skill) vs text/table
- Confirm target parent page in Notion with the user

### Step 2: Build Visuals (if any)
- Use the `visualize` skill to build HTML, capture regions to PNG (see Visualization Workflow)

### Step 3: Create Notion Page
- Write directly via Notion MCP (`notion-create-pages` / `notion-update-page`)
- Apply all format, table, callout, toggle, and content rules above
- Insert image placeholder callouts where PNGs belong

### Step 4: Report
```
✅ 노션 페이지 생성 완료

📄 제목: [Title] (링크)
📏 구조: [X]개 섹션, 표 [Y]개, 콜아웃 [Z]개, 이미지 [N]장
```
- Present PNG files for drag-in
- Remind: full-width toggle (`⋯ → 전체 너비`) must be set manually (API 미지원)

---

## Quality Checklist

- [ ] H2 only has emoji; H3/H4 clear titles
- [ ] Korean (English) format, noun-ending style
- [ ] Callout titles: no emoji, noun-form, bold
- [ ] Tables fill page width; columns proportional with generous padding, no wrapping/scroll
- [ ] Group rows: name on first row only, row colors applied
- [ ] Visual concepts built with visualize skill, captured, placeholders inserted
- [ ] No page icon
- [ ] Sensitive info scan done: 자격 증명·공인/사설 IP·계정 식별자 모두 마스킹 (텍스트 = 일반화, 이미지 = 캡쳐 전 치환 또는 블러)
- [ ] Personal identifiers replaced with placeholders
- [ ] No version footer
- [ ] Follow-up Q&A integrated into the page
