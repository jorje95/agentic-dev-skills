---
name: angular-development
description: >-
  Official modern Angular (v19–v22+) development guidelines and workflows covering standalone components, Signals (signal, computed, linkedSignal, input, output, model), Signal Forms / typed Reactive Forms, host bindings, NgOptimizedImage, and built-in control flow (@if, @for, @defer). Use when creating, updating, or reviewing Angular components, services, or state management.
---

# Angular Development Skill

Follow these official modern Angular standards (synthesized from the official `angular/angular` AI guidelines and SkillHub best practices).

## 1. Component & Decorator Standards

- **Standalone by Default**:
  - Always build standalone components, directives, and pipes; never introduce new `NgModule` declarations.
  - In Angular v19+/v22+, standalone is the default—do **not** add redundant `standalone: true` metadata unless the project is on an older Angular version.
- **Change Detection**:
  - Use `OnPush` / zoneless-compatible reactivity (in Angular v22+, `OnPush` is default; in v17–v21, explicitly set `changeDetection: ChangeDetectionStrategy.OnPush`).
- **Host Bindings**:
  - Do **NOT** use `@HostBinding` or `@HostListener` decorators. Put all host bindings and listeners inside the `host: { ... }` property of `@Component` or `@Directive`.
- **Single Responsibility & Separation**:
  - Keep components small and focused. Place component logic in `.ts`, styles in `.css`/`.scss`, and templates in `.html` (or inline for very small components).

## 2. Signals-First Reactivity & State Management

- **Component Inputs, Outputs & Two-Way Binding**:
  - Use `input()` and `input.required()` instead of `@Input()`.
  - Use `output()` instead of `@Output()`.
  - Use `model()` for two-way bound properties (`[(prop)]`) instead of pairing `input()` + `output()`.
- **Local & Derived State**:
  - Use `signal()` for writable state; update exclusively via `.set()` or `.update()` (never `.mutate()`).
  - Use `computed()` for pure derived state.
  - Use `linkedSignal()` for writable state that resets or derives from upstream reactive sources.
  - Avoid using `effect()` to synchronize state; reserve `effect()` strictly for DOM/logging/external API side effects.
- **RxJS Interop**:
  - Bridge Observables to Signals with `toSignal()` (`@angular/core/rxjs-interop`) and clean up imperative subscriptions with `takeUntilDestroyed()`.

## 3. Templates, Styling & Forms

- **Native Control Flow & Deferrable Views**:
  - Always use `@if`, `@for (item of items(); track item.id)`, and `@switch` instead of `*ngIf`, `*ngFor`, and `*ngSwitch`.
  - Use `@defer (on viewport)` / `@defer (on idle)` with `@placeholder` and `@loading` blocks for heavy components.
- **Bindings & Imports**:
  - Do **NOT** use `ngClass` or `ngStyle`; use native `[class.active]="..."` / `[class]="..."` and `[style]="..."` bindings.
  - Do **NOT** import `CommonModule`; import only the specific pipes/directives used (`DatePipe`, `CurrencyPipe`, `AsyncPipe`).
  - Use `NgOptimizedImage` (`ngSrc`) for all static images (except inline base64 images).
- **Forms**:
  - Prefer **Signal Forms** (`@angular/forms/signals`) in Angular v22+, or strictly typed **Reactive Forms** (`NonNullableFormBuilder`) over template-driven forms.
- **Dependency Injection**:
  - Always use the `inject()` function instead of constructor injection.

## 4. Accessibility & Verification

1. Must pass all **AXE** checks and meet **WCAG AA** minimums (focus management, color contrast, semantic ARIA).
2. Run `ng build` / `tsc --noEmit` and component tests (`ng test`) before completing any task.
