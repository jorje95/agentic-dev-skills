---
name: angular-development
description: >-
  Modern Angular development guidelines and workflows using standalone components, Signals, OnPush change detection, inject() DI, typed Reactive Forms, RxJS interop, and modern control flow (@if, @for, @defer). Use when creating, updating, or reviewing Angular components, services, or state management.
---

# Angular Development Skill

Follow these modern Angular standards when authoring, refactoring, or reviewing Angular web applications.

## 1. Component & Reactivity Standards

- **Standalone by Default**: All components, directives, and pipes must be standalone. Do not introduce new `NgModule` declarations.
- **Change Detection**: Always configure `changeDetection: ChangeDetectionStrategy.OnPush` on every component.
- **Signals-First State Management**:
  - Use `signal()` for writable state and `computed()` for derived state.
  - Use signal-based `input()`, `input.required()`, `output()`, and `model()` instead of `@Input()` and `@Output()` decorators.
  - Avoid using `effect()` to copy or synchronize state; prefer `computed()` or `linkedSignal()`.
- **Dependency Injection**: Use `inject()` at field initialization rather than constructor parameter injection.
- **RxJS & Signals Interop**:
  - Use RxJS for async streams, `HttpClient` pipelines, and complex event coordination (`switchMap`, `debounceTime`, `retry`).
  - Bridge observables to templates with `toSignal()` (from `@angular/core/rxjs-interop`) and auto-clean subscriptions with `takeUntilDestroyed()`.

## 2. Templates, Routing & Forms

- **Built-in Control Flow**: Always use `@if`, `@for (item of items(); track item.id)`, and `@switch` instead of `*ngIf`, `*ngFor`, and `*ngSwitch`.
- **Deferrable Views**: Use `@defer (on viewport)` or `@defer (on idle)` with `@placeholder` and `@loading` blocks to lazy-load heavy below-the-fold components.
- **Typed Reactive Forms**: Use strictly typed `FormBuilder` / `NonNullableFormBuilder` for complex forms with explicit validation state feedback.
- **Lazy Route Loading**: Use `loadComponent` and `loadChildren` in route definitions for code splitting.

## 3. Verification Checklist

1. Run `ng build` / `tsc --noEmit` to verify strict template and TypeScript compilation.
2. Run unit/component tests (`ng test`) verifying DOM output, signal transitions, and accessibility attributes.
