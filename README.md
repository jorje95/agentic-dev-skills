# Agentic Development Standards (`agentic-dev`)

Global Antigravity plugin containing always-on rules and modular skills for full-stack agentic software engineering across **Kotlin + Spring Boot**, **React**, **Angular**, and **React Native**.

## Included Always-On Rules (`rules/AGENTS.md`)

1. **`JA:` Prefix Protocol (`Just Asking`)**: Any prompt starting with `JA:` enforces strict read-only informational mode (no code edits, no file creation, no document/artifact updates).
2. **Automatic GitHub Sync**: Any update to skills or rules in this plugin is automatically committed and pushed to [`jorje95/agentic-dev-skills`](https://github.com/jorje95/agentic-dev-skills).
3. **Token Optimization & Spec-Driven Divide et Impera**: Enforces surgical context reads, Spec-first decomposition, and complexity-based routing to subagents (`flash_lite`, `flash`, `pro`).
4. **Core Tech Stack Guardrails**: Baseline standards for Kotlin/Spring Boot, React, Angular, and React Native.

## Included Skills (`skills/`)

| Skill | Scope | Description |
| :--- | :--- | :--- |
| `token-and-agent-orchestration` | Orchestration & Tokens | Context hygiene, Spec-driven *Divide et Impera* task decomposition, and complexity-matched subagent/model tier routing (`flash_lite` / `flash` / `pro`) |
| `spec-and-planning` | Workflow | Spec-driven development, ambiguity resolution, and atomic task breakdown |
| `fullstack-vertical-slice` | End-to-End | Contract-first delivery from Kotlin Spring Boot API to Angular/React web and React Native mobile |
| `backend-development` | Kotlin & Spring Boot | Layered/modular architecture, `@field:` DTO validation, RFC 9457 `ProblemDetail`, Flyway, JUnit 5 + MockK + Testcontainers |
| `angular-development` | Angular | Standalone components, `OnPush`, Signals (`signal`, `computed`, `input`, `output`), `inject()`, `@if`/`@for`/`@defer` |
| `react-development` | React & TypeScript | Functional components, custom `use*` hooks, TanStack Query vs. Zustand/Context, React Hook Form + Zod, RTL testing |
| `mobile-development` | React Native & Kotlin | Screen/Hook/Service separation, React Navigation, Safe Areas, Callstack FPS/TTI/FlashList optimization, Reanimated, Kotlin TurboModules/Expo Modules |
| `tdd-and-verification` | Workflow | Red-Green-Refactor TDD and systematic root-cause debugging |
| `code-review-and-security` | Workflow | OWASP security hardening, auth/IDOR checks, N+1 detection, and multi-layer review |

## Syncing Updates

Run the included helper script (executed automatically by the agent whenever skills or rules change):

```bash
./scripts/sync-to-github.sh "feat: update skill guidelines"
```
