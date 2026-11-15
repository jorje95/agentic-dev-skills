---
name: backend-development
description: >-
  Kotlin and Spring Boot 3/4 backend development standards (enriched with SivaLabs & Spring Boot SkillHub best practices) covering idiomatic Kotlin, Value Objects, Command/Query services, Jakarta @field: validation, RFC 9457 ProblemDetail error handling, Flyway migrations, Spring Data JPA, and JUnit 5 + MockK + Testcontainers + ArchUnit testing. Use when building, refactoring, or reviewing backend services and endpoints.
---

# Backend Development Skill (Kotlin & Spring Boot)

Follow these production-grade Kotlin and Spring Boot practices (synthesized from top SkillHub Spring Boot skills: `sivalabs-agent-skills` and `spring-boot-skills`).

## 1. Idiomatic Kotlin & Domain Modeling

- **Immutability & Null Safety**:
  - Prefer `val` over `var` and immutable collections.
  - Use Kotlin null-safety (`?`, `?:`, `let`). Never use `!!` in production code; throw explicit domain exceptions instead.
- **Value Objects (`@JvmInline value class`)**:
  - Wrap domain identifiers and constrained primitives in Kotlin `@JvmInline value class` (with `@get:JsonValue` and `@JsonCreator` or Spring `Converter<String, T>`) to prevent primitive obsession:
    ```kotlin
    @JvmInline
    value class UserId(@get:JsonValue val value: String) {
        init { require(value.isNotBlank()) { "UserId cannot be blank" } }
    }
    ```
- **Constructor Injection**: Use primary constructor injection for all `@RestController`, `@Service`, and `@Component` beans.

## 2. Layered & Modular Architecture (`Spring Modulith` Ready)

- **Controller Layer (`@RestController`)**:
  - Handle HTTP routing, `@Valid` request binding, pagination, and HTTP status codes (`ResponseEntity`).
  - Never put business logic in controllers or expose JPA `@Entity` classes directly in API responses.
- **Service Layer (`@Service`) — Unit of Work & CQS**:
  - Default to `@Transactional(readOnly = true)` at the class level or on query methods; annotate mutating methods explicitly with `@Transactional`.
  - Use dedicated **Command (`*Cmd`)**, **Query (`*Query`)**, and **Result (`*Result` / `*VM`)** Kotlin `data class` models for service inputs and outputs.
  - Decouple cross-module side effects by publishing typed **Domain Events** via Spring's `ApplicationEventPublisher` (`@TransactionalEventListener`).
- **Repository Layer (`@Repository`)**:
  - Isolate Spring Data JPA / JDBC / jOOQ queries.
  - Prevent N+1 queries using DTO projections, `@EntityGraph`, or `JOIN FETCH`.
  - Manage all schema evolution through **Flyway** (`db/migration/V*__*.sql`) with `spring.jpa.hibernate.ddl-auto=validate`.

## 3. API Contracts, Validation & RFC 9457 Error Handling

- **Kotlin DTO Validation (`@field:`)**:
  - Always apply `@field:` use-site targets to Jakarta Bean Validation annotations on Kotlin `data class` properties:
    ```kotlin
    data class CreateOrderRequest(
        @field:NotBlank val customerId: String,
        @field:NotEmpty val items: List<@Valid OrderItemDto>
    )
    ```
- **Global Exception Handling (`ProblemDetail` / RFC 9457)**:
  - Centralize error handling in `@RestControllerAdvice` extending `ResponseEntityExceptionHandler` and returning `ProblemDetail` (`type`, `title`, `status`, `detail`, and `errors` map) without leaking internal stack traces.

## 4. Complementary Testing Pyramid

| Test Level | Tooling | When to Use |
| :--- | :--- | :--- |
| **Unit Tests** | **JUnit 5 + MockK** (`mockk()`, `every`, `verify`) | Pure domain logic, value objects, and service rules (no Spring context) |
| **Web Slice** | `@WebMvcTest` + `MockMvcTester` + `@MockkBean` | Controller routing, JSON serialization, `@Valid` errors, auth guards |
| **Persistence Slice** | `@DataJpaTest` + **Testcontainers** (`@ServiceConnection`) | Custom JPA/SQL queries and mappings against a real DB container (never H2) |
| **Architecture** | **ArchUnit** | Enforcing package boundaries, layer dependencies, and module isolation |
| **End-to-End Smoke** | `@SpringBootTest(webEnvironment = RANDOM_PORT)` + `RestTestClient` | Critical happy-path integration across the full stack |

- Prefer `@Sql("/test-data.sql")` or service-level setup over coupling tests to internal repository state.
