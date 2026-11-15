# {{PROJECT_NAME}} — Stage 3: Testing Playbook & Verification Matrix

- **Project Slug:** `{{PROJECT_SLUG}}`
- **Design Reference:** [01-design.md](./01-design.md)
- **Last Updated:** {{DATE}}

---

## 1. Backend Testing Matrix (`Kotlin` + `Spring Boot`)

| Test Layer | Target Class / Module | Tooling | Key Scenarios Covered | Command |
| :--- | :--- | :--- | :--- | :--- |
| **Unit** | `*Service`, Value Objects | JUnit 5 + MockK | Happy path, domain invariants, exception throwing | `./gradlew test --tests "*ServiceTest"` |
| **Web Slice** | `*Controller` | `@WebMvcTest` + `@MockkBean` | HTTP status codes, `@field:Valid` 400 ProblemDetail, auth guards | `./gradlew test --tests "*ControllerTest"` |
| **Persistence Slice** | `*Repository` | `@DataJpaTest` + Testcontainers | Custom queries, constraints, N+1 prevention (real DB, never H2) | `./gradlew test --tests "*RepositoryTest"` |
| **Architecture** | Package/Module boundaries | ArchUnit | Layer isolation (`Controller` → `Service` → `Repository`) | `./gradlew test --tests "*ArchitectureTest"` |

## 2. Web Frontend Testing Matrix (`React` / `Angular`)

| Component / Hook / Service | Tooling | Scenarios (`loading`, `error`, `empty`, `success`) | Command |
| :--- | :--- | :--- | :--- |
| `*Component` / `use*` | Vitest / Jest + Testing Library / `TestBed` | User interactions, accessible roles (`getByRole`), validation errors, AXE a11y | `pnpm test` |

## 3. Mobile Testing & Device Playbook (`React Native` + `Kotlin`)

| Screen / Native Module | Verification Type | Checklist |
| :--- | :--- | :--- |
| `*Screen` | Jest + RNTL + Simulator | Safe areas, `FlashList` 60fps scroll, keyboard avoidance, offline cache fallback, iOS & Android back navigation |

## 4. High-Risk Edge Cases & Failure Modes

1. **Invalid / Boundary Inputs:** Empty strings, oversized payloads, invalid IDs.
2. **Concurrency / Idempotency:** Duplicate form submissions, optimistic update rollback on 500 error.
3. **Auth & Permissions:** Expired JWT refresh, cross-tenant IDOR attempt (`403`).
