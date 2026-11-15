---
name: backend-development
description: >-
  Kotlin and Spring Boot 3/4 backend development standards covering idiomatic Kotlin, layered/modular architecture, REST API conventions, Jakarta @field: validation, RFC 9457 ProblemDetail error handling, Flyway migrations, Spring Data JPA, and JUnit 5 + MockK + Testcontainers testing. Use when building, refactoring, or reviewing backend services and endpoints.
---

# Backend Development Skill (Kotlin & Spring Boot)

Follow this workflow when designing, implementing, or modifying Kotlin + Spring Boot backend services and APIs.

## 1. Idiomatic Kotlin & Spring Architecture

- **Immutability & Null Safety**:
  - Prefer `val` over `var` and immutable collections.
  - Leverage Kotlin null-safety (`?`, `?:`, `let`). Never use `!!` in production code; throw explicit domain exceptions instead.
- **Dependency Injection**: Use primary constructor injection for all `@RestController`, `@Service`, and `@Component` classes. Never use `@Autowired` field injection.
- **Layer & Module Separation**:
  - **Controller Layer (`@RestController`)**: Handle HTTP routing, `@Valid` request binding, pagination, and HTTP status codes (`ResponseEntity`). Never put business logic in controllers or expose `@Entity` classes directly.
  - **Service Layer (`@Service`)**: Encapsulate domain logic and transaction boundaries (`@Transactional(readOnly = true)` by default on query services, `@Transactional` on write methods).
  - **Repository Layer (`@Repository`)**: Isolate Spring Data JPA / JDBC queries. Use projections or DTO queries to avoid N+1 query issues (`@EntityGraph` or `JOIN FETCH` when needed).

## 2. API Contracts, Validation & Error Handling

- **Kotlin DTO Validation (`@field:`)**:
  - Always prefix Jakarta Bean Validation annotations on Kotlin `data class` constructor properties with `@field:` so annotations apply to the backing field:
    ```kotlin
    data class CreateUserRequest(
        @field:NotBlank val email: String,
        @field:Size(min = 2, max = 100) val displayName: String
    )
    ```
- **RFC 9457 / 7807 `ProblemDetail` Error Responses**:
  - Centralize exception handling in `@RestControllerAdvice` returning `ProblemDetail` with standard `type`, `title`, `status`, `detail`, and field-level validation errors. Never leak internal stack traces or SQL errors.
- **Database Migrations**:
  - Manage all schema changes via versioned **Flyway** (`db/migration/V*__*.sql`) or Liquibase migrations; set `spring.jpa.hibernate.ddl-auto=validate` in production configs.

## 3. Complementary Testing Strategy

Write tests at the fastest level that provides confidence:
1. **Unit Tests (No Spring Context)**: Test domain and service logic using **JUnit 5** and **MockK** (`mockk()`, `every { ... } returns ...`, `verify { ... }`).
2. **Web Slice Tests (`@WebMvcTest`)**: Test controller routing, serialization, `@Valid` constraints, and security guards with `MockMvc` / `MockMvcTester` and `@MockkBean`.
3. **Persistence Slice & Integration Tests (`@DataJpaTest` / `@SpringBootTest`)**:
   - Always use **Testcontainers** (`@ServiceConnection`) with the real target database engine (e.g., PostgreSQL)—never substitute in-memory H2.

## 4. Verification Checklist

1. Run build and static analysis (`./gradlew check` / `ktlint` / `detekt`).
2. Verify all unit and slice tests pass (`./gradlew test`).
3. Confirm API request/response schemas match frontend (React/Angular) and mobile (React Native) TypeScript models.
