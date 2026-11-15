---
name: react-development
description: >-
  Modern React + TypeScript development guidelines and workflows covering functional components, custom hooks, TanStack Query server state, Zustand/Context client state, React Hook Form + Zod validation, performance, and testing. Use when creating, updating, or reviewing React web components, hooks, or state logic.
---

# React Development Skill

Follow these modern React and TypeScript standards when building or refactoring React web applications.

## 1. Component & State Architecture

- **Strict TypeScript**: Define explicit interfaces for component props, hook return values, and API payloads. Never use `any` or unsafe type assertions.
- **Single-Responsibility Components**:
  - Keep UI components declarative and focused on rendering.
  - Extract data fetching, side effects, and complex state transitions into composable custom hooks (`use*`).
- **State Categorization & Colocation**:
  - **Server Cache State**: Use **TanStack Query** (`useQuery`, `useMutation`, query key factories, optimistic updates) for all async backend state. Never manually mirror `fetch` results into `useState` + `useEffect`.
  - **Local UI State**: Colocate `useState` / `useReducer` in the lowest common ancestor component.
  - **Shared Client State**: Use lightweight atomic/selector stores (e.g., **Zustand**) or scoped React Context to avoid cascading re-renders.
- **Derived State**: Calculate derived values directly during render (or wrap in `useMemo` when measurably expensive). Never use `useEffect` to synchronize one state variable from another.

## 2. Forms, Accessibility & Web Performance

- **Forms & Validation**: Use **React Hook Form** paired with **Zod** (`@hookform/resolvers/zod`) for type-safe schema validation and minimal re-renders.
- **Complete Async UI States**: Every data-driven view must explicitly handle `loading` (skeletons/spinners), `error` (recoverable error UI + retry), and `empty` states.
- **Accessibility (a11y) & Web Vitals**: Use semantic HTML (`<button>`, `<nav>`, `<main>`, `<dialog>`), keyboard navigation support, and optimize LCP/INP.

## 3. Verification Checklist

1. Run TypeScript check (`tsc --noEmit`) and ESLint.
2. Run unit and component tests (Vitest / Jest + **React Testing Library**) querying by accessible roles (`getByRole`, `findByText`) rather than test IDs or internal state.
