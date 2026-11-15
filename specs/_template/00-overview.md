# {{PROJECT_NAME}} — Stage 1: Overview & Capability Map

- **Project Slug:** `{{PROJECT_SLUG}}`
- **Status / Stage:** `Overview`
- **Tech Stack:** {{TECH_STACK}}
- **Last Updated:** {{DATE}}

---

## 1. Objective & Vision

- **Problem Statement:** [What problem are we solving and for whom?]
- **Reframed Success Criteria (Measurable & Testable):**
  - [ ] Criterion 1 (e.g., API p95 < 200ms, end-to-end flow completion)
  - [ ] Criterion 2
  - [ ] Criterion 3

## 2. Explicit Assumptions

- **Assumption 1:** [State assumption so it can be validated or corrected early]
- **Assumption 2:** [...]

## 3. Capability Map (Module Spec Tree)

> Each capability module below maps to a child spec node in [`modules/<module-id>/spec.md`](./modules/) when detailed decomposition is needed.

| Module ID (`kebab-case`) | Responsibility & Scope | Depends On | Child Spec |
| :--- | :--- | :--- | :--- |
| `core-domain` | Core entities, shared value objects, auth context | — | `modules/core-domain/spec.md` |

**Build Order:** `core-domain` → ...

## 4. Boundaries (`Always` / `Ask First` / `Never`)

- **Always:** Run unit/slice tests before marking tasks done; keep Kotlin DTOs and TypeScript interfaces in sync; keep this living spec tree updated.
- **Ask First:** Database schema breaking changes, adding new third-party dependencies, changing auth/security rules.
- **Never:** Commit secrets/tokens, use `!!` in Kotlin or `any` in TypeScript, skip verification steps.

## 5. Out of Scope (Deferred V2 Backlog)

- [Deferred item 1 — reason]

## 6. Open Questions

- [ ] [Unresolved question requiring human decision]
