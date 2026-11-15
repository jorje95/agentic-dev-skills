---
name: token-and-agent-orchestration
description: >-
  Token optimization, context window hygiene, and Spec-Driven Divide et Impera (divide and conquer) subagent orchestration (synthesized from Superpowers subagent-driven-development & parallel dispatch). Routes tasks by complexity to the appropriate subagent and model tier (flash_lite, flash, pro). Use whenever planning multi-step features, delegating work, exploring large codebases, or optimizing token usage.
---

# Token Optimization & Spec-Driven Divide et Impera Skill

Maximize engineering quality while minimizing token consumption by combining **strict context hygiene**, **spec-driven decomposition**, **parallel subagent dispatch**, and **complexity-matched model routing** (synthesized from `obra/superpowers` and `addyosmani/agent-skills`).

---

## 1. Context Window Hygiene (Token Conservation Rules)

1. **Surgical File Reads Only**:
   - Locate symbols first using `grep` / `ripgrep` or file search, then read only the relevant line range (`StartLine` to `EndLine`) via `read_file`.
   - Never read generated files, lockfiles (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`), build outputs (`build/`, `dist/`, `.angular/`, `node_modules/`), or minified bundles.
2. **Targeted CLI & Single-Test Execution**:
   - Run single-test commands during iteration (`./gradlew test --tests "com.example.UserServiceTest"`, `npx vitest run src/foo.test.ts`) instead of full test suites.
   - Pipe verbose CLI output through `tail`, `head`, or `jq` so large logs never flood the main context window.
3. **Offload Broad Exploration to `research` Subagent**:
   - When exploring unfamiliar modules (4+ files), delegate to the `research` subagent (`Model: "flash"`) so intermediate file reads stay out of the primary orchestrator's context.
4. **Proactive Context Compaction**:
   - Suggest `/compact` to the user after finishing major milestones in long conversations.

---

## 2. Spec-Driven "Divide et Impera" (Subagent-Driven Development)

Never execute multi-layer features in one monolithic context. Follow this 4-stage pipeline:

```text
[1. Spec & Contract] ──► [2. Disjoint Slices] ──► [3. Parallel Tiered Dispatch] ──► [4. Spec + Quality Verify]
   (Orchestrator)         (Zero Shared State)        (flash_lite / flash / pro)         (Targeted Checks)
```

### Stage 1: Lock the Spec & Contract First
- Author a concise Spec and API Contract (Kotlin DTOs, OpenAPI/TypeScript interfaces, error codes, edge cases) in the main agent (`spec-and-planning`).
- The Spec is the **binding authority** passed to subagents so they never guess or re-read unrelated files.

### Stage 2: Decompose into Independent, Disjoint Slices
- Partition tasks so each subagent owns **disjoint files** with zero write collisions:
  - *Slice 1*: Backend Repository + `@Service` + MockK unit tests
  - *Slice 2*: Backend `@RestController` + `@WebMvcTest`
  - *Slice 3*: Angular/React web component + hook/Signal service + unit tests
  - *Slice 4*: React Native screen + hook + RNTL tests

### Stage 3: Parallel Subagent Dispatch & Complexity-to-Model Routing
- **Parallel Fan-Out**: When 2+ slices have no sequential file dependency (e.g., Web Slice and Mobile Slice once the API contract is locked), invoke multiple subagents **in the same turn** so they execute concurrently.
- **Complexity-Matched Model Selection (`invoke_subagent`)**:

| Complexity Tier | Target Model (`invoke_subagent`) | Subagent Type | Typical Tasks |
| :--- | :--- | :--- | :--- |
| **Tier 1: Trivial / Mechanical** | `Model: "flash_lite"` | `self` or `research` | Generating TypeScript interfaces or Kotlin `data class` / `@JvmInline value class` DTOs from a locked spec; mock fixtures; mechanical renames; docstrings; barrel/config updates. |
| **Tier 2: Standard / Scoped Slice** | `Model: "flash"` | `self`, `research`, or `browser` | Codebase scouting (`research`); implementing a well-specified Spring `@RestController`/`@Service`, React/Angular component, or React Native screen; writing JUnit 5/MockK or Vitest/Jest tests. |
| **Tier 3: Complex / Architectural** | `Model: "pro"` (or `inherit`) | `self` (or Lead Agent) | Authoring the Spec & cross-layer API contracts; complex domain algorithms, concurrency/coroutines, or Spring Security architecture; multi-layer root-cause debugging; security review (`code-review-and-security`). |

### Stage 4: Subagent Prompt Contract & Continuous Execution
1. **Isolated Context Construction**: Every subagent prompt must include:
   - Exact files to read and exact files allowed to create/modify.
   - Inline Spec excerpt (DTOs, interfaces, acceptance criteria).
   - Verification command to run before returning.
   - **Strict Output Budget**: *"Return a summary under 200 words listing only modified files, test results, and any rulings/blockers—do not echo full file contents."*
2. **Rulings Over Stalls**:
   - Once a plan is running, execute all slices continuously without pausing for "Should I continue?" check-ins.
   - Only pause for: (a) destructive/irreversible operations, (b) security/credential boundaries, (c) unrequested external pushes/publishes, or (d) a fundamentally contradictory requirement.
