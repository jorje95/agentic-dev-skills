# Agentic Development Rules & Interaction Protocol

## 1. Prompt Prefix Protocol: `JA:` (Just Asking)

Whenever a user prompt starts with the `JA:` prefix (case-insensitive, e.g., `JA:`, `ja:`):
- **Read-Only / Informational Mode ONLY**: The user is **just asking a question**.
- **No Code or File Modifications**: Do **NOT** create, edit, or delete any workspace files, configuration files, or project assets.
- **No Document or Artifact Updates**: Do **NOT** create or update markdown documents, plans, task lists, or artifacts.
- **No Mutating Commands**: Only use read-only inspection tools (`read_file`, search/grep, or non-mutating inspection commands) if needed to answer the question accurately.

## 2. Automatic GitHub Synchronization for Skills & Rules

All global agentic development rules and skills live in `/Users/nitroi/.gemini/config/plugins/agentic-dev` and are tracked in the GitHub repository [`jorje95/agentic-dev-skills`](https://github.com/jorje95/agentic-dev-skills).
- **Mandatory Auto-Push Rule**: Every time you create, modify, or delete any skill (`skills/**/SKILL.md`), rule (`rules/*.md`), script, or manifest (`plugin.json`) in `/Users/nitroi/.gemini/config/plugins/agentic-dev`, you **MUST** immediately commit and push the changes to `origin/main` on GitHub before finishing your turn (via `/Users/nitroi/.gemini/config/plugins/agentic-dev/scripts/sync-to-github.sh "<commit message>"`).

## 3. Token Optimization & Spec-Driven Divide et Impera

Our workflow is **Spec-Driven** and uses **Divide et Impera (Divide & Conquer)** to minimize token consumption (see `token-and-agent-orchestration` skill):
1. **Context Hygiene**:
   - Use targeted search (`grep`) and line-range `read_file` (`StartLine`–`EndLine`) instead of reading whole large files. Never read lockfiles, build outputs, or `node_modules`.
   - Run targeted single-file/single-class test commands during iteration and filter noisy CLI output.
2. **Spec First, Then Fan Out**:
   - Lock the Spec and API contracts first (`spec-and-planning`), then decompose work into disjoint, atomic slices.
3. **Complexity-Matched Agent & Model Routing (`invoke_subagent`)**:
   - **`Model: "flash_lite"` (Trivial / Mechanical)**: DTO/interface scaffolding from spec, mock data, mechanical edits, boilerplate, simple lookups.
   - **`Model: "flash"` (Standard / Scoped Slice)**: Codebase scouting (`research` subagent), implementing well-specified backend endpoints/services, Angular/React components, React Native screens, and standard unit/slice tests.
   - **`Model: "pro"` / Lead Agent (Complex / Architectural)**: Spec & contract design, complex domain/concurrency logic, security hardening, and cross-layer debugging.
   - Instruct subagents to return compact summaries (< 200 words) rather than echoing full files.

## 4. Core Tech Stack Guardrails

1. **Backend (`Kotlin` + `Spring Boot`)**:
   - Idiomatic Kotlin (`val` immutability, null-safety without `!!`, primary constructor injection, `data class` DTOs).
   - Strict `Controller` → `Service` → `Repository` separation; never return JPA entities directly from controllers.
   - Validate inputs with `@Valid` and `@field:NotNull` / `@field:NotBlank` Jakarta annotations; handle errors globally via `@RestControllerAdvice` returning RFC 9457 / 7807 `ProblemDetail`.
   - Test with **JUnit 5**, **MockK**, sliced Spring tests (`@WebMvcTest`, `@DataJpaTest`), and **Testcontainers** (never use in-memory H2 for persistence tests).
2. **Web Frontend (`React` & `Angular`)**:
   - **React**: Strict TypeScript, functional components, custom `use*` hooks for business/API logic, TanStack Query for server state vs. Zustand/Context for client state, derived state computed during render (never sync state via `useEffect`).
   - **Angular**: Standalone components by default, `ChangeDetectionStrategy.OnPush`, Signals-first reactivity (`signal`, `computed`, `input`, `output`), `inject()` DI, and built-in control flow (`@if`, `@for`, `@switch`, `@defer`).
3. **Mobile (`React Native` & `Kotlin`)**:
   - Strict TypeScript, declarative screen/hook/service separation, `react-native-safe-area-context`, and React Navigation static/typed routers.
   - **Measure → Optimize → Re-measure** performance workflow: `FlashList`/`FlatList` for lists (never nest inside vertical `ScrollView`), UI-thread animations (`react-native-reanimated`), offline-resilient query caching, and thin coroutine-safe Kotlin native modules (TurboModules / Expo Modules).
