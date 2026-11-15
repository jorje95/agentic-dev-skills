# {{PROJECT_NAME}} — Stage 4: Implementation Stage & Subagent Ledger

- **Project Slug:** `{{PROJECT_SLUG}}`
- **Spec References:** [00-overview.md](./00-overview.md) | [01-design.md](./01-design.md) | [02-testing-playbook.md](./02-testing-playbook.md)
- **Last Updated:** {{DATE}}

> **Execution Rule:** Decompose work into disjoint vertical slices (`token-and-agent-orchestration`). Dispatch each slice to the matched model tier (`flash_lite`, `flash`, `pro`), verify with its exact test command, check off the task below, and back-propagate any contract changes to `01-design.md` and `02-testing-playbook.md`.

---

## 1. Vertical Slice Task Breakdown

### Slice 1: Foundation & Contracts
- [ ] **Task 1.1:** Scaffold DTOs, Value Objects, and TypeScript interfaces from `01-design.md`
  - **Model Tier:** `flash_lite`
  - **Target Files:** `...`
  - **Verification:** `./gradlew compileKotlin` / `tsc --noEmit`

### Slice 2: Backend Core (`Kotlin` + `Spring Boot`)
- [ ] **Task 2.1:** Flyway migration + Repository + Testcontainers slice test
  - **Model Tier:** `flash`
  - **Target Files:** `...`
  - **Verification:** `./gradlew test --tests "*RepositoryTest"`
- [ ] **Task 2.2:** Service business logic + MockK unit tests + Controller `@WebMvcTest`
  - **Model Tier:** `flash`
  - **Target Files:** `...`
  - **Verification:** `./gradlew test --tests "*ServiceTest" --tests "*ControllerTest"`

### Slice 3: Web & Mobile Clients (`Angular` / `React` / `React Native`)
- [ ] **Task 3.1:** Web feature view + state/query hook + component test
  - **Model Tier:** `flash`
  - **Target Files:** `...`
  - **Verification:** `pnpm --filter web test`
- [ ] **Task 3.2:** Mobile screen + navigation + Safe Area / `FlashList` + RNTL test
  - **Model Tier:** `flash`
  - **Target Files:** `...`
  - **Verification:** `pnpm --filter mobile test`

---

## 2. Rulings & Spec Drift Ledger

Record architectural rulings and spec adjustments made during implementation:

| Date | Slice / Task | Ruling (`Decision — Reason — Impact`) | Spec Files Updated |
| :--- | :--- | :--- | :--- |
| {{DATE}} | Init | Initialized living spec tree for `{{PROJECT_NAME}}` | `00`–`03`, `PROJECTS_INDEX.md` |
