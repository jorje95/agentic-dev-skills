# Agentic Development Standards (`agentic-dev`)

Global Antigravity plugin containing always-on rules, modular skills, and the **Living Spec Portfolio (`specs/`)** for full-stack agentic software engineering across **Kotlin + Spring Boot**, **React**, **Angular**, and **React Native**.

## Included Always-On Rules (`rules/AGENTS.md`)

1. **`JA:` Prefix Protocol (`Just Asking`)**: Any prompt starting with `JA:` enforces strict read-only informational mode (no code edits, no file creation, no document/artifact updates).
2. **Automatic GitHub Sync**: Any update to skills, rules, or **living project specs** in this plugin is automatically committed and pushed to [`jorje95/agentic-dev-skills`](https://github.com/jorje95/agentic-dev-skills).
3. **Living Spec Trees & Project Portfolio**: Tracks all projects in [`specs/PROJECTS_INDEX.md`](./specs/PROJECTS_INDEX.md) with a 4-stage living spec tree per project (`00-overview.md`, `01-design.md`, `02-testing-playbook.md`, `03-implementation-stage.md`, plus `modules/`).
4. **Token Optimization & Spec-Driven Divide et Impera**: Enforces surgical context reads, Spec-first decomposition, and complexity-based routing to subagents (`flash_lite`, `flash`, `pro`).
5. **Core Tech Stack Guardrails**: Baseline standards for Kotlin/Spring Boot, React, Angular, and React Native.

## Included Skills (`skills/`)

| Skill | Scope | Description |
| :--- | :--- | :--- |
| `living-spec-trees` | Portfolio & Living Specs | Hierarchical Living Spec Trees (`00-overview`, `01-design`, `02-testing-playbook`, `03-implementation-stage` + `modules/`), `PROJECTS_INDEX.md` tracking, and continuous bi-directional code ↔ spec sync |
| `token-and-agent-orchestration` | Orchestration & Tokens | Context hygiene, Spec-driven *Divide et Impera* task decomposition, and complexity-matched subagent/model tier routing (`flash_lite` / `flash` / `pro`) |
| `spec-and-planning` | Workflow | Spec-driven development, ambiguity resolution, and atomic task breakdown |
| `fullstack-vertical-slice` | End-to-End | Contract-first delivery from Kotlin Spring Boot API to Angular/React web and React Native mobile |
| `backend-development` | Kotlin & Spring Boot | Value Objects, CQS services, `@field:` DTO validation, RFC 9457 `ProblemDetail`, Flyway, JUnit 5 + MockK + Testcontainers + ArchUnit |
| `angular-development` | Angular | Standalone components, Signals (`signal`, `computed`, `linkedSignal`, `input`, `output`, `model`), Signal Forms, `host` bindings, `@if`/`@for`/`@defer` |
| `react-development` | React & TypeScript | Waterfall elimination, bundle optimization, TanStack Query, re-render rules, compound component composition, RTL testing |
| `mobile-development` | React Native & Kotlin | Callstack `Measure → Optimize → Re-measure`, `FlashList`, Reanimated GPU animations, React Navigation, Safe Areas, Kotlin TurboModules/Expo Modules |
| `tdd-and-verification` | Workflow | Red-Green-Refactor TDD and systematic root-cause debugging |
| `code-review-and-security` | Workflow | OWASP security hardening, auth/IDOR checks, N+1 detection, and multi-layer review |

## Scaffolding & Syncing Commands

```bash
# Scaffold a new project's 4-stage Living Spec Tree & register in specs/PROJECTS_INDEX.md
./scripts/init-project-spec.sh <project-slug> "<Project Name>" "<Tech Stack>"

# Sync any skill, rule, or living spec updates to GitHub
./scripts/sync-to-github.sh "docs(spec): update project spec"
```
