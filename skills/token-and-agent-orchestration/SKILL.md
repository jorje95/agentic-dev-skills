---
name: token-and-agent-orchestration
description: >-
  Token optimization, context window hygiene, and Spec-Driven Divide et Impera (divide and conquer) orchestration. Routes tasks by complexity to the appropriate subagent and model tier (flash_lite, flash, pro). Use whenever planning multi-step features, delegating work, exploring large codebases, or optimizing token usage.
---

# Token Optimization & Spec-Driven Divide et Impera Skill

Maximize engineering throughput while minimizing token consumption by combining **strict context hygiene**, **spec-driven decomposition**, and **complexity-matched agent routing**.

---

## 1. Context Window Hygiene (Token Conservation Rules)

1. **Targeted File Reads Only**:
   - Locate symbols first using `grep` / `ripgrep` or file search, then read only the relevant line range (`StartLine` to `EndLine`) via `read_file`.
   - Never read generated files, lockfiles (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`), build artifacts (`build/`, `dist/`, `.angular/`, `node_modules/`), or minified bundles.
2. **Quiet CLI & Test Execution**:
   - Run build and test commands focused on the single changed test class or file (e.g., `./gradlew test --tests "com.example.UserServiceTest"`, `npx vitest run src/foo.test.ts`) rather than running the entire test suite on every intermediate edit.
   - Filter noisy CLI outputs (`--quiet`, `| tail -n 50`, `jq`) so megabytes of logs never enter the main conversation context.
3. **Offload Broad Exploration**:
   - When a task requires reading more than 4–5 files to understand an unfamiliar module, delegate the survey to the **`research`** subagent (`Model: "flash"`) and ask it to return only a structured summary with file/line pointers.
4. **Recommend `/compact` When Appropriate**:
   - After completing a major milestone in a long session, remind the user they can use `/compact` to compress historical context.

---

## 2. Spec-Driven "Divide et Impera" (Divide & Conquer) Workflow

Do not execute multi-file, multi-layer implementations in a single monolithic agent turn. Follow this 4-stage pipeline:

```text
[1. Spec & Contract] ──► [2. Slice Decomposition] ──► [3. Tiered Subagent Dispatch] ──► [4. Verify & Merge]
   (Orchestrator)           (Atomic Work Units)          (flash_lite / flash / pro)       (Targeted Checks)
```

### Stage 1: Lock the Spec & Contract (Main Agent)
- Define the exact data models, Kotlin DTOs, OpenAPI/TypeScript interfaces, and acceptance criteria upfront (`spec-and-planning`).
- The Spec serves as the **single compact source of truth** passed to worker subagents so they do not need to re-discover requirements.

### Stage 2: Decompose into Atomic, Disjoint Slices
- Partition work so each slice owns **disjoint files** (avoiding edit conflicts):
  - **Slice A (Backend Persistence & Service)**: Flyway migration + JPA Entity/Repository + `@Service`.
  - **Slice B (Backend API & Slice Tests)**: `@RestController` + DTO validation + `@WebMvcTest`.
  - **Slice C (Web Frontend)**: React or Angular component + hook/Signal service + unit test.
  - **Slice D (Mobile Client)**: React Native screen + navigation + hook + RNTL test.

### Stage 3: Complexity-Matched Subagent Routing (`invoke_subagent`)

Assign every delegated task to the **lightest model tier** capable of executing it reliably:

| Complexity Tier | Target Model (`invoke_subagent`) | Subagent Type | Typical Tasks |
| :--- | :--- | :--- | :--- |
| **Tier 1: Trivial / Mechanical** | `Model: "flash_lite"` | `self` or `research` | Generating TypeScript interfaces or Kotlin `data class` DTOs from a locked spec; creating mock fixtures; mechanical renames; adding docstrings; simple config/barrel updates. |
| **Tier 2: Standard / Well-Specified** | `Model: "flash"` | `self`, `research`, or `browser` | Codebase scouting (`research`); implementing an isolated Spring `@RestController`/`@Service`, React/Angular component, or React Native screen from a clear spec; writing standard JUnit 5/MockK or Vitest/Jest unit tests. |
| **Tier 3: Complex / Architectural** | `Model: "pro"` (or `inherit`) | `self` (or Lead Agent) | Authoring the Spec & cross-layer API contracts; complex domain algorithms, concurrency/coroutines, or Spring Security architecture; deep root-cause debugging across layers; security auditing (`code-review-and-security`). |

### Stage 4: Bounded Subagent Prompts & Compact Returns
Every subagent prompt **MUST** include:
1. **Scope Boundary**: Exact files to read and exact files permitted to create/edit.
2. **Inline Spec Excerpt**: Only the DTO/interface contract and acceptance criteria relevant to that slice.
3. **Return Budget**: Instruct the subagent: *"Return a concise summary under 200 words listing only modified files, verification commands run, and any blockers—do not paste full file contents back."*
