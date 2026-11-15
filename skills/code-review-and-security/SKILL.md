---
name: code-review-and-security
description: >-
  Comprehensive code review, security auditing (OWASP), and architectural quality checklist for Kotlin Spring Boot, Angular, React, and React Native. Use when reviewing diffs/PRs, auditing security boundaries, or hardening code before shipping.
---

# Code Review & Security Hardening Skill

Perform a structured, multi-angle review across correctness, security, performance, and maintainability.

## 1. Security & Trust Boundaries (CRITICAL)

- **Authentication & Authorization**:
  - Verify Spring Security method/route guards (`@PreAuthorize`, security filter chains) enforce both authentication and **object-level authorization** (prevent IDOR / BOLA).
  - Ensure secrets, API keys, and JWT signing keys are never hardcoded or committed to git.
  - On React Native, verify tokens are stored in Keychain / Keystore (`SecureStore`), never unencrypted `AsyncStorage`.
- **Input Validation & Injection Prevention**:
  - Confirm all Spring Boot request DTOs use `@Valid` with `@field:` constraints.
  - Ensure parameterized queries in Spring Data / JPA / JDBC (never string-concatenated SQL/JPQL).
  - Prevent XSS in React (`dangerouslySetInnerHTML`) and Angular (`bypassSecurityTrust*`).

## 2. Stack-Specific Quality Checks

- **Kotlin & Spring Boot**:
  - No JPA `@Entity` leaked in controller responses.
  - No N+1 query traps on lazy associations inside loops.
  - Proper `@Transactional` boundaries (not calling `@Transactional` methods via `this.` self-invocation).
  - No unsafe `!!` operators or swallowed exceptions.
- **React & Angular**:
  - No `any` types or suppressed linter rules without justification.
  - No state synchronization inside `useEffect` (React) or `effect()` (Angular) where derived state (`useMemo` / `computed()`) belongs.
  - Complete `loading`, `error`, and `empty` state coverage.
- **React Native**:
  - No `ScrollView` wrapping dynamic lists (`FlashList` / `FlatList` required).
  - Safe area insets and keyboard avoidance properly handled on both iOS and Android.
  - Subscriptions, timers, and native listeners cleaned up on unmount.

## 3. Review Output Format

Group findings by severity:
- **Blocking / Critical**: Security vulnerabilities, data loss risks, broken contracts, crashes, or memory leaks.
- **Major**: Performance bottlenecks (N+1 queries, janky list renders), missing validation, or missing tests for core paths.
- **Minor / Nit**: Naming, readability, or idiomatic improvements.
