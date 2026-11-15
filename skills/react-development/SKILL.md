---
name: react-development
description: >-
  Modern React + TypeScript development guidelines and performance rules (enriched with Vercel React Best Practices & Composition Patterns from SkillHub) covering waterfall elimination, bundle size, TanStack Query, re-render optimization, compound component composition, and React Testing Library. Use when creating, updating, or reviewing React web components, hooks, or state logic.
---

# React Development Skill (Vercel Best Practices & Composition)

Follow these prioritized React + TypeScript rules (synthesized from `vercel-labs/agent-skills`: `vercel-react-best-practices` and `vercel-composition-patterns`).

## Priority 1: Eliminating Async Waterfalls & Data Fetching (`CRITICAL`)

- **Parallelize Independent Requests (`async-parallel`)**: Never chain sequential `await` calls or nested component fetches when requests are independent; use `Promise.all()` or parallel **TanStack Query** (`useQueries` / `useQuery`) hooks.
- **Server Cache Deduplication**: Use **TanStack Query** (`useQuery`, `useMutation`, query key factories) or SWR for all backend state; never manually copy `fetch` responses into `useState` inside `useEffect`.
- **Suspense Boundaries (`async-suspense-boundaries`)**: Use `<Suspense>` and error boundaries to stream/isolate slow subtrees without blocking the entire page.

## Priority 2: Bundle Size Optimization (`CRITICAL`)

- **Avoid Barrel Imports (`bundle-barrel-imports`)**: Import modules directly from their source paths rather than large index/barrel files that defeat tree-shaking.
- **Dynamic Imports (`bundle-dynamic-imports`)**: Lazy-load heavy modals, charts, and editors (`React.lazy` / `next/dynamic`) and preload on user intent (`onMouseEnter` / `onFocus`).

## Priority 3: State & Re-render Optimization (`HIGH`)

- **Derive State During Render (`rerender-derived-state-no-effect`)**: Compute derived values directly during render (or `useMemo` when measurably expensive). Never use `useEffect` to sync one state variable from another.
- **Put Interaction Logic in Event Handlers (`rerender-move-effect-to-event`)**: Side effects triggered by a user action (click, submit) belong in the event handler, not in a `useEffect` watching state flags.
- **Defer State Reads (`rerender-defer-reads`)**: Do not subscribe a component to fast-changing store/context values if they are only read inside callbacks.
- **Lazy State Initialization (`rerender-lazy-state-init`)**: Pass an initializer function `useState(() => computeInitial())` for non-trivial initial values (`localStorage`, parsing).
- **Responsive Transitions (`rerender-transitions`)**: Use `startTransition` or `useDeferredValue` for non-urgent filtering/search updates to keep inputs at 60fps.

## Priority 4: Component Composition Patterns (`MEDIUM-HIGH`)

- **Avoid Boolean Prop Proliferation (`architecture-avoid-boolean-props`)**: Instead of adding many boolean mode flags (`isCompact`, `isAdmin`, `withHeader`, `hideFooter`), create explicit variant components or use **Compound Components** (`<Card><Card.Header /><Card.Body /></Card>`).
- **Prefer `children` Over `renderX` Props (`patterns-children-over-render-props`)**: Use standard `children` and slot composition rather than proliferating custom render props.
- **Decoupled Context Interface (`state-context-interface`)**: Structure complex feature providers around `{ state, actions, meta }` interfaces so UI consumers are decoupled from state implementation details.
- **React 19 Modern APIs**: When on React 19+, pass `ref` as a standard prop (no `forwardRef`) and use `use(Context)` instead of `useContext(Context)`.

## Verification Checklist

1. Ensure every async view explicitly handles `loading`, `error`, and `empty` states.
2. Run `tsc --noEmit` and ESLint.
3. Verify user-visible behavior with **Vitest / Jest + React Testing Library** (`getByRole`, `userEvent`).
