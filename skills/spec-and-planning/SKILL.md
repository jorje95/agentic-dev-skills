---
name: spec-and-planning
description: >-
  Agentic spec-driven development and task breakdown workflow. Turns feature requests or refactors into concrete specifications, API contracts, edge-case matrices, and atomic implementation tasks before writing code. Use at the start of any non-trivial feature, architectural change, or multi-file refactor.
---

# Spec-Driven Development & Task Breakdown Skill

Never jump straight into writing code on complex or ambiguous tasks. Follow this **Define → Plan** workflow first.

## 1. Clarify & Specify (Define)

1. **Context Inspection**: Read the relevant existing files (`Controller`, `Service`, components, hooks, tests) before proposing changes.
2. **Resolve Ambiguity**: If requirements have material gaps (e.g., auth scope, pagination, offline behavior, error recovery), ask concise clarifying questions upfront.
3. **Define Acceptance Criteria**:
   - Inputs, outputs, and data model / DTO changes.
   - Edge cases (empty states, null/missing fields, network failures, unauthorized access, race conditions).
   - Non-functional constraints (latency, 60fps mobile rendering, backward compatibility).

## 2. Atomic Task Breakdown (Plan)

Break the implementation into small, independently verifiable steps:
1. **Schema / Contract Step**: Database migrations, Kotlin DTOs, TypeScript interfaces.
2. **Core Logic Step**: Backend `@Service` + unit tests, or frontend custom hook / Signal store + unit tests.
3. **UI / Transport Step**: `@RestController` slice or React / Angular / React Native component + tests.
4. **Integration & Cleanup Step**: End-to-end wiring, linting, type-checking, and dead-code removal.

## 3. Anti-Rationalization Guardrails

- Do **not** skip planning because a change "looks quick"—small changes across backend/web/mobile often hide contract mismatches.
- Never bundle unrelated refactors into a feature change without asking.
