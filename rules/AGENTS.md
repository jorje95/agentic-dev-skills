# Agentic Development Rules & Interaction Protocol

## 1. Prompt Prefix Protocol: `JA:` (Just Asking)

Whenever a user prompt starts with the `JA:` prefix (case-insensitive, e.g., `JA:`, `ja:`):
- **Read-Only / Informational Mode ONLY**: The user is **just asking a question**.
- **No Code or File Modifications**: Do **NOT** create, edit, or delete any workspace files, configuration files, or project assets.
- **No Document or Artifact Updates**: Do **NOT** create or update markdown documents, plans, task lists, or artifacts.
- **No Mutating Commands**: Only use read-only inspection tools (`read_file`, search/grep, or non-mutating inspection commands) if needed to answer the question accurately.

## 2. Automatic GitHub Synchronization for Skills, Rules & Living Specs

All global agentic development rules, skills, and the **Living Spec Portfolio** live in `/Users/nitroi/.gemini/config/plugins/agentic-dev` and are tracked in the GitHub repository [`jorje95/agentic-dev-skills`](https://github.com/jorje95/agentic-dev-skills).
- **Mandatory Auto-Push Rule**: Every time you create, modify, or delete any skill (`skills/**/SKILL.md`), rule (`rules/*.md`), living spec (`specs/**`), script, or manifest (`plugin.json`) in `/Users/nitroi/.gemini/config/plugins/agentic-dev`, you **MUST** immediately commit and push the changes to `origin/main` on GitHub before finishing your turn (via `/Users/nitroi/.gemini/config/plugins/agentic-dev/scripts/sync-to-github.sh "<commit message>"`).

## 3. Living Spec Trees & Project Portfolio Management

Every project we design or build is tracked in our **Master Project Index** (`/Users/nitroi/.gemini/config/plugins/agentic-dev/specs/PROJECTS_INDEX.md`) and structured as a **4-Stage Hierarchical Living Spec Tree** under `/Users/nitroi/.gemini/config/plugins/agentic-dev/specs/projects/<project-slug>/` (see `living-spec-trees` skill):
1. **`00-overview.md` (Overview & Capability Map)**: Vision, measurable success criteria, explicit assumptions, Capability Map (module tree with child specs under `modules/<module-id>/spec.md`), and Always/Ask/Never boundaries.
2. **`01-design.md` (Architecture, Contracts & ADRs)**: System diagrams, Flyway schema/entities, cross-layer API contracts (Kotlin DTOs ↔ TypeScript interfaces), client state design, and ADRs.
3. **`02-testing-playbook.md` (Testing Playbook)**: Verification matrix across Backend (JUnit 5/MockK, `@WebMvcTest`, `@DataJpaTest` + Testcontainers, ArchUnit), Web (Vitest/RTL, Angular `TestBed`, AXE a11y), Mobile (Jest/RNTL, Safe Areas, `FlashList` 60fps), and edge cases.
4. **`03-implementation-stage.md` (Implementation & Subagent Ledger)**: Disjoint vertical slices, subagent model tier assignments (`flash_lite`, `flash`, `pro`), live progress checkboxes (`- [ ]` / `- [x]`), and the `Rulings & Spec Drift Ledger`.
- **Continuous Living Sync**: Whenever requirements, designs, API contracts, tests, or implementation tasks evolve during work on a project, you **MUST** keep `00`–`03` and `PROJECTS_INDEX.md` synchronized in lockstep and push to GitHub.

## 4. Token Optimization & Spec-Driven Divide et Impera

Our workflow is **Spec-Driven** and uses **Divide et Impera (Divide & Conquer)** to minimize token consumption (see `token-and-agent-orchestration` skill):
1. **Context Hygiene**:
   - Load only the relevant node of the project's Living Spec Tree.
   - Use targeted search (`grep`) and line-range `read_file` (`StartLine`–`EndLine`) instead of reading whole large files. Never read lockfiles, build outputs, or `node_modules`.
   - Run targeted single-file/single-class test commands during iteration and filter noisy CLI output.
2. **Spec First, Then Fan Out**:
   - Lock the Spec and API contracts first (`living-spec-trees` + `spec-and-planning`), then decompose work into disjoint, atomic slices in `03-implementation-stage.md`.
3. **Complexity-Matched Agent & Model Routing (`invoke_subagent`)**:
   - **`Model: "flash_lite"` (Trivial / Mechanical)**: DTO/interface scaffolding from spec, mock data, mechanical edits, boilerplate, simple lookups.
   - **`Model: "flash"` (Standard / Scoped Slice)**: Codebase scouting (`research` subagent), implementing well-specified backend endpoints/services, Angular/React components, React Native screens, and standard unit/slice tests.
   - **`Model: "pro"` / Lead Agent (Complex / Architectural)**: Spec & contract design, complex domain/concurrency logic, security hardening, and cross-layer debugging.
   - Instruct subagents to return compact summaries (< 200 words) rather than echoing full files.

## 5. Core Tech Stack Guardrails

1. **Backend (`Kotlin` + `Spring Boot`)**:
   - Idiomatic Kotlin (`val` immutability, null-safety without `!!`, `@JvmInline value class` Value Objects, primary constructor injection, `data class` DTOs).
   - Strict `Controller` → `Service` (`*Cmd`, `*Query`, `*Result`, `@Transactional(readOnly = true)` default) → `Repository` separation; never return JPA entities directly from controllers.
   - Validate inputs with `@Valid` and `@field:NotNull` / `@field:NotBlank` Jakarta annotations; handle errors globally via `@RestControllerAdvice` returning RFC 9457 / 7807 `ProblemDetail`.
   - Test with **JUnit 5**, **MockK**, sliced Spring tests (`@WebMvcTest`, `@DataJpaTest`), **Testcontainers** (never H2), and **ArchUnit**.
2. **Web Frontend (`React` & `Angular`)**:
   - **React**: Strict TypeScript, eliminate async waterfalls (`Promise.all` / parallel queries), avoid barrel imports, TanStack Query for server state, derive state during render (never sync state via `useEffect`), compound component composition.
   - **Angular**: Standalone components by default, Signals-first reactivity (`signal`, `computed`, `linkedSignal`, `input`, `output`, `model`), Signal Forms / typed Reactive Forms, `host: { ... }` bindings, `inject()` DI, and native control flow (`@if`, `@for`, `@switch`, `@defer`).
3. **Mobile (`React Native` & `Kotlin`)**:
   - Strict TypeScript, Callstack `Measure → Optimize → Re-measure` workflow, `FlashList` for lists (memoized items, no inline styles), Reanimated GPU animations (`transform`/`opacity`), `react-native-safe-area-context`, no falsy `&&` rendering, and coroutine-safe Kotlin native modules (`Dispatchers.IO`).
