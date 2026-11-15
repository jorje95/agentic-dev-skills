---
name: tdd-and-verification
description: >-
  Test-Driven Development (Red-Green-Refactor) and systematic root-cause debugging workflow across Kotlin (JUnit 5, MockK, Testcontainers), React/Angular (Vitest, Jest, Testing Library), and React Native. Use when writing tests, implementing business logic, or fixing bugs and test failures.
---

# TDD & Systematic Debugging Skill

Enforce evidence-based verification and test-first discipline across backend, web, and mobile codebases.

## 1. Red → Green → Refactor Cycle

1. **Red (Write a Failing Test First)**:
   - Express the desired behavior or bug reproduction in an automated test before changing production code.
   - **Kotlin / Spring Boot**: JUnit 5 + MockK for domain/service logic; `@WebMvcTest` for controllers; `@DataJpaTest` + Testcontainers for persistence.
   - **React / React Native**: Vitest or Jest + Testing Library (`render`, `renderHook`, user-event interactions).
   - **Angular**: `TestBed` with standalone component imports and Signal state assertions.
2. **Green (Minimal Implementation)**:
   - Write the simplest production code that makes the failing test pass without breaking existing tests.
3. **Refactor**:
   - Clean up duplication, improve naming, and enforce strict typing while keeping the test suite green.

## 2. Systematic Debugging & Error Recovery

When encountering a bug, build failure, or flaky test:
1. **Reproduce & Read the Full Error**: Inspect the exact stack trace, compiler diagnostic, or failing assertion—never guess or apply blind fixes.
2. **Isolate the Layer**: Determine whether the fault lies in the backend API payload, serialization, state/query cache, or UI rendering.
3. **Write a Regression Test**: Capture the root cause in a test that fails before the fix and passes after.
4. **Verify Clean State**: Run the full relevant test suite and type-checker before declaring the issue resolved.
