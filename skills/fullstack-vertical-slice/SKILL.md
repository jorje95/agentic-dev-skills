---
name: fullstack-vertical-slice
description: >-
  End-to-end vertical slice workflow spanning Kotlin Spring Boot REST APIs, shared OpenAPI/TypeScript contracts, Angular or React web views, and React Native mobile screens. Use when implementing or updating a complete feature across backend, web, and mobile.
---

# Full-Stack Vertical Slice Skill

When delivering a feature that spans the backend and client applications, execute in this strict contract-first order to prevent integration drift.

## Step 1: API Contract & Domain Model First

1. Define the request/response payloads, validation rules, error codes (`ProblemDetail`), and pagination semantics.
2. Document or update the OpenAPI specification (or shared TypeScript/Kotlin schema) before writing UI code.

## Step 2: Backend Implementation (`Kotlin` + `Spring Boot`)

1. **Database Migration**: Add a versioned Flyway/Liquibase migration if schema changes are needed.
2. **Persistence & Service**: Implement the Spring Data repository and `@Service` business logic with `@Transactional` boundaries.
3. **Controller & Validation**: Expose the `@RestController` endpoint with `@Valid` and `@field:` constraints on Kotlin `data class` DTOs.
4. **Backend Verification**: Run JUnit 5 + MockK unit tests and `@WebMvcTest` / Testcontainers slice tests.

## Step 3: Web Frontend Integration (`React` or `Angular`)

- **If React**:
  1. Update TypeScript DTO interfaces and Zod schemas.
  2. Create or update TanStack Query (`useQuery` / `useMutation`) hooks with proper cache invalidation.
  3. Build the component handling `loading`, `error`, and `empty` states, plus React Testing Library tests.
- **If Angular**:
  1. Update TypeScript interfaces and `HttpClient` service methods.
  2. Expose reactive state via Signals (`signal`, `computed`, `toSignal`).
  3. Build or update the Standalone `OnPush` component using `@if`/`@for` control flow and verify with component tests.

## Step 4: Mobile Integration (`React Native` + `Kotlin`)

1. Update shared TypeScript API types and TanStack Query hooks (including offline cache behavior).
2. Implement or update the screen with `SafeAreaView`, `FlashList`/`FlatList` (if list-based), and typed React Navigation route params.
3. Add any required Kotlin native module methods on `Dispatchers.IO` if device hardware/OS APIs are involved.
4. Verify with Jest + React Native Testing Library.
