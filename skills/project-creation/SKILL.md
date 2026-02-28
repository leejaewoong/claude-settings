---
name: project-creation
description: Structured project initialization through 3 sequential bundles (A, B, C). Use when starting a new project from scratch.
---

# Project Creation Skill

## Overview

Project initialization proceeds through 3 sequential Bundles with user approval at each stage.

**Note:** This skill uses the `communication` and `commit-message` skills for consistent Korean responses and standardized commit format.

## User Profile Context

* **Level:** Beginner developer
* **Proficiencies:** Python, TypeScript
* **Frameworks:** Basic knowledge of Next.js, React, FastAPI

---

## Bundle A — Requirements Specification

**Goal:** Define what to build

**Process:**
1. Interview user about:
   - Project purpose and goals
   - Target users
   - Core features
   - Success criteria
   - Constraints and limitations

2. Write comprehensive requirements specification

3. Present to user in Korean for review

4. Incorporate feedback

5. Get confirmation before proceeding

**Deliverable:** `docs/requirements.md`

---

## Bundle B — Tech Stack & Basic Architecture

**Goal:** Select technology and design structure

**Process:**
1. Propose 2-3 technology stack combinations

**Stack Requirements:**
- Backend: Python with FastAPI (preferred)
- Frontend: React or Next.js with TypeScript
- Database: Appropriate for project needs (PostgreSQL, MongoDB, SQLite)
- Additional: State management, styling, testing frameworks

2. Present comparison in Korean:
   - Pros and cons
   - Learning curve
   - Community support
   - Project suitability

3. Wait for user selection

4. Design basic architecture:
   - System architecture diagram (mermaid)
   - Component structure
   - Data flow
   - Folder structure

5. Present for approval

**Deliverables:**
- `docs/tech-stack.md`
- `docs/architecture.md`

---

## Bundle C — Detailed Design & Feature List

**Goal:** Plan implementation details

**Process:**

### Step 1: API Design
Create API flow diagrams and specifications:
- API endpoints with methods (GET, POST, etc.)
- Request/response formats
- Authentication flow
- Error handling patterns

**Output:** `docs/api-specification.md`

### Step 2: Feature List
Generate comprehensive Feature list:
- Break down into implementable tasks
- Prioritize features (MVP vs future)
- Estimate complexity (easy/medium/hard)
- Identify dependencies between features

**Output:** `docs/feature-list.md`

### Step 3: UI Reference Collection
**Request UI examples from user:**

Present this message in Korean:
````
컴포넌트 디자인을 위한 UI 스타일을 선택해주세요.

다음 중 하나를 선택해주세요:
1. 기존 프로젝트의 컴포넌트 코드 제공
2. 선호하는 UI 라이브러리 예시 (shadcn/ui, Material-UI 등)
3. 디자인 시스템 또는 스타일 가이드 제공
4. 기본 스타일 사용 (frontend-design plugin 활용)

예시:
- "shadcn/ui Button과 Card 스타일로"
- "Material-UI 스타일로"
- "기본 스타일로 진행"
- [파일 첨부: 기존 컴포넌트 코드]
````

**Wait for user response.**

### Step 4: Component Design

**Design approach based on user's choice:**

#### If user provided custom UI examples:
1. Analyze provided code patterns
2. Extract design patterns:
   - Component composition style
   - Props structure
   - Styling approach (CSS-in-JS, Tailwind, etc.)
   - TypeScript patterns
3. Design components following the same patterns
4. Document component hierarchy and relationships

#### If user chose specific UI library (e.g., shadcn/ui, Material-UI):
1. Reference the library's design system
2. Design components using library's conventions
3. Document component variants and props
4. Specify library-specific patterns

#### If user chose default styling:
**Use the frontend-design plugin from anthropics/claude-code:**

1. Invoke the plugin:
````
   Use frontend-design plugin to create modern, accessible component designs
````

2. The plugin will provide:
   - Modern component patterns
   - Accessibility-first designs
   - Best practices for React/Next.js
   - Tailwind CSS styling patterns
   - Responsive design guidelines

3. Document the designs provided by the plugin

**Component design should include:**

**Frontend Components:**
- Layout components (Header, Footer, Sidebar)
  - Responsibilities
  - Props interfaces
  - Usage patterns
- Page components (Home, Dashboard, etc.)
  - State management
  - API integration points
  - User interactions
- Shared components (Button, Input, Card, etc.)
  - Variants and sizes
  - Props and events
  - Composition patterns

**Backend Components:**
- Service layer structure
- Repository/DAO patterns
- Utility functions
- Middleware components

**State Management:**
- Global state strategy (Context API, Redux, Zustand, etc.)
- Server state management (React Query, SWR, etc.)
- Local state patterns

**Styling Methodology:**
- CSS framework (Tailwind, CSS Modules, etc.)
- Theme system (colors, typography, spacing)
- Responsive design approach

**Output:** `docs/component-design.md`

### Step 5: Final Review
Present complete Bundle C design for final confirmation:
- API specification
- Feature list with priorities
- Component design

**Deliverables:**
- `docs/api-specification.md`
- `docs/feature-list.md`
- `docs/component-design.md`

---

## After Bundle C Approval

1. Set up project structure
2. Initialize git repository
3. Create initial commit using commit-message skill

**Example commit:**
````
🎉Tada(Many): 프로젝트 구조 초기화

프로젝트 초기 설정
- docs/requirements.md: 프로젝트 요구사항 작성
- docs/tech-stack.md: 선택된 기술 스택 문서화
- docs/architecture.md: 시스템 아키텍처 설계 추가
- docs/api-specification.md: API 엔드포인트 문서화
- docs/feature-list.md: 기능 목록 및 우선순위 정리
- docs/component-design.md: 컴포넌트 구조 및 디자인 패턴 정의
````

---

## Communication Guidelines

* Use communication skill for all interactions (Korean)
* Present each Bundle clearly
* Wait for explicit approval before proceeding
* Be patient and educational with beginner developer
* When requesting UI examples, provide clear options and wait for user response
* When user chooses default styling, use frontend-design plugin

---

## Component Design Template

When creating `docs/component-design.md`, use this structure:
````markdown
# Component Design

## UI Design Pattern

[Describe the UI pattern based on user's choice or frontend-design plugin output]

## Frontend Components

### Layout Components
#### Header
- **Responsibilities**: [Description]
- **Props**: [Interface definition]
- **Usage**: [How it's used in pages]

#### Footer
- **Responsibilities**: [Description]
- **Props**: [Interface definition]
- **Usage**: [How it's used in pages]

#### Sidebar (if applicable)
- **Responsibilities**: [Description]
- **Props**: [Interface definition]
- **Usage**: [How it's used in pages]

### Page Components
#### HomePage
- **Purpose**: [Description]
- **State**: [State variables needed]
- **API Integration**: [Which endpoints it calls]
- **User Interactions**: [Key user actions]

#### DashboardPage
- **Purpose**: [Description]
- **State**: [State variables needed]
- **API Integration**: [Which endpoints it calls]
- **User Interactions**: [Key user actions]

### Shared Components
#### Button
- **Variants**: [List variants: default, primary, secondary, etc.]
- **Sizes**: [List sizes: sm, md, lg, etc.]
- **Props Interface**:
```typescript
  interface ButtonProps {
    variant?: string;
    size?: string;
    disabled?: boolean;
    onClick?: () => void;
    children: React.ReactNode;
  }
```
- **Usage Examples**: [How to use in different scenarios]

#### Input
- **Types**: [text, email, password, etc.]
- **Validation**: [How validation is handled]
- **Props Interface**: [TypeScript interface]
- **Usage Examples**: [How to use in forms]

#### Card
- **Composition**: [How Card, CardHeader, CardContent are composed]
- **Props Interface**: [TypeScript interface]
- **Usage Examples**: [Common use cases]

## Backend Components

### Service Layer
#### UserService
- **Responsibilities**: [What it handles]
- **Key Methods**:
  - `createUser()`: [Description]
  - `authenticateUser()`: [Description]
  - `updateProfile()`: [Description]

#### AuthService
- **Responsibilities**: [What it handles]
- **Key Methods**:
  - `generateToken()`: [Description]
  - `verifyToken()`: [Description]
  - `refreshToken()`: [Description]

### Repository Layer
#### UserRepository
- **Responsibilities**: [Data access methods]
- **Key Methods**:
  - `findById()`: [Description]
  - `findByEmail()`: [Description]
  - `create()`: [Description]
  - `update()`: [Description]

### Database Models
```python
# User model structure
class User(Base):
    __tablename__ = "users"
    
    id: int
    email: str
    password_hash: str
    created_at: datetime
    updated_at: datetime
```

## State Management

**Approach**: [Context API / Redux / Zustand / etc.]

**Global State**:
- AuthContext: [User authentication state]
- ThemeContext: [Dark/light mode]
- ToastContext: [Notifications]

**Server State**:
- React Query for API data caching
- Optimistic updates for better UX
- Automatic background refetching

## Styling Approach

**Primary Method**: [Tailwind CSS / CSS Modules / styled-components / etc.]

**Theme System**:
- Color palette: [Primary, secondary, accent colors]
- Typography scale: [Font sizes and weights]
- Spacing system: [Margin and padding scale]

**Responsive Design**:
- Mobile-first approach
- Breakpoints: [sm, md, lg, xl]
- Component responsiveness patterns
````