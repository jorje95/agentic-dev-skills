# Citerra — Stage 4: Implementation Stage & Subagent Ledger

- **Project Slug:** `citerra`
- **Spec References:** [00-overview.md](./00-overview.md) | [01-design.md](./01-design.md) | [02-testing-playbook.md](./02-testing-playbook.md)
- **Last Updated:** 2026-11-15

> **Execution Rule:** Decompose work into disjoint vertical slices (`token-and-agent-orchestration`). Dispatch each slice to the matched model tier (`flash_lite`, `flash`, `pro`), verify with its exact test command, check off the task below, and back-propagate any contract changes to `01-design.md` and `02-testing-playbook.md`.

---

## 1. Vertical Slice Task Breakdown

### Slice 1: Monorepo Foundation, Brand Assets & Shared Core (`@citerra/core`)
- [x] **Task 1.1:** Initialize private GitHub repo `jorje95/citerra`, `pnpm` workspace, TypeScript strict config, and 3-tier `.firebaserc` (`local`, `staging`, `prod`)
  - **Model Tier:** `flash_lite`
  - **Target Files:** `package.json`, `pnpm-workspace.yaml`, `tsconfig.base.json`, `firebase.json`, `.firebaserc`
  - **Verification:** `pnpm install && pnpm -r typecheck`
- [x] **Task 1.2:** Implement `@citerra/core` (Claim normalizer, isomorphic SHA-256 hasher, private origin detector, Zod API schemas, NLI prompt templates, zero-PII telemetry builder) + Vitest suite
  - **Model Tier:** `flash`
  - **Target Files:** `packages/core/src/**`, `packages/core/test/**`
  - **Verification:** `pnpm --filter @citerra/core test` (8/8 passing)
- [x] **Task 1.3:** Generate Citerra brand logo SVG, app icon, and Landing Page hero assets via `image-generator` subagent
  - **Model Tier:** `flash` (`image-generator`)
  - **Target Files:** `packages/assets/**`
  - **Verification:** `logo.svg`, `logo-mark.png`, `hero-illustration.png` verified

### Slice 2: Firebase Backend, Security Rules & Two-Tier TTL Cache (`packages/backend`)
- [x] **Task 2.1:** Author hardened `firestore.rules` and `firestore.indexes.json` via `firestore-rules-author` subagent
  - **Model Tier:** `pro` (`firestore-rules-author`)
  - **Target Files:** `firestore.rules`, `firestore.indexes.json`
  - **Verification:** Verified Admin-SDK write lock & `isValidSha256` point-lookup guard
- [x] **Task 2.2:** Implement Cloud Function `POST /v1/corroborate` and `POST /v1/claims/contribute` with Two-Tier Firestore Cache (`claim_cache_24h`, `keyword_cache_6h`, `k >= 3` `claim_hits` gate) + parallel Wikipedia, Google Fact Check & Crossref API adapters
  - **Model Tier:** `pro`
  - **Target Files:** `packages/backend/src/service.ts`, `packages/backend/src/store.ts`, `packages/backend/src/firestore-repo.ts`, `packages/backend/src/providers.ts`
  - **Verification:** `pnpm --filter @citerra/backend test:unit` (2/2 passing)
- [x] **Task 2.3:** Implement Cloud Function `POST /v1/telemetry/batch` with strict Zod zero-PII validation and hourly/daily rollup aggregation + unit tests
  - **Model Tier:** `flash`
  - **Target Files:** `packages/backend/src/index.ts`, `packages/backend/test/telemetry.test.ts`
  - **Verification:** `pnpm --filter @citerra/backend test:telemetry` (2/2 passing)

### Slice 3: Shared Cross-Platform UI System (`@citerra/ui` — Gluestack v2 + NativeWind v4)
- [x] **Task 3.1:** Build shared cross-platform components (`VerdictBadge`, `FactCheckCard`, `CitationItemCard`, `HistoryListView`, `SupportCiterraCard`) + unit tests
  - **Model Tier:** `flash`
  - **Target Files:** `packages/ui/src/**`, `packages/ui/test/**`
  - **Verification:** `pnpm --filter @citerra/ui test` (4/4 passing)

### Slice 4: Product Showcase Website, Welcome/Donation Flow & Telemetry Dashboard (`apps/web`)
- [x] **Task 4.1:** Build Landing Page (`/`), First-Install Onboarding + Buy Me a Coffee / Ko-fi Support Page (`/welcome` & `/donate`), Interactive Fact-Check Sandbox, and Analytics View (`/stats`)
  - **Model Tier:** `flash`
  - **Target Files:** `apps/web/src/**`, `apps/web/test/**`
  - **Verification:** `pnpm --filter @citerra/web test && pnpm --filter @citerra/web build` (3/3 passing, Vite bundle built)

### Slice 5: Chrome Extension (`apps/extension` — Manifest V3)
- [x] **Task 5.1:** Implement MV3 background orchestrator (`contextMenus` selection handler, `/welcome` install tab opener), On-Device AI runner (`window.ai` Gemini Nano -> WebGPU local fallback), and On-Device Local History store
  - **Model Tier:** `pro`
  - **Target Files:** `apps/extension/src/**`, `apps/extension/test/**`
  - **Verification:** `pnpm --filter @citerra/extension test && pnpm --filter @citerra/extension build` (3/3 passing)

### Slice 6: Mobile Companion App (`apps/mobile` — React Native + Kotlin)
- [x] **Task 6.1:** Implement Mobile Fact-Check Bottom Sheet UI, Android `ACTION_PROCESS_TEXT` native Kotlin activity (`ProcessTextActivity.kt`), and OS Share Sheet intent parser
  - **Model Tier:** `pro`
  - **Target Files:** `apps/mobile/src/**`, `apps/mobile/android/ProcessTextActivity.kt`, `apps/mobile/test/**`
  - **Verification:** `pnpm --filter @citerra/mobile test && pnpm --filter @citerra/mobile build` (2/2 passing)

---

## 2. Rulings & Spec Drift Ledger

Record architectural rulings and spec adjustments made during implementation:

| Date | Slice / Task | Ruling (`Decision — Reason — Impact`) | Spec Files Updated |
| :--- | :--- | :--- | :--- |
| 2026-11-15 | Init / `/grill-me` | Named project **Citerra** (`citerra`) after collision check on Chrome Web Store & Mobile stores | `00`–`03`, `PROJECTS_INDEX.md` |
| 2026-11-15 | Init / `/grill-me` | Selected **Pure Firebase Backend** with 3-tier env isolation (`local`, `staging`, `prod`) and **Two-Tier TTL Cache** gated by `k >= 3` cohort hits | `01-design.md`, `02-testing-playbook.md` |
| 2026-11-15 | Init / `/grill-me` | Selected **Gluestack UI v2 + NativeWind v4** for unified UX across Web, Chrome Side Panel, and Mobile, plus `/welcome` Buy Me a Coffee / Ko-fi donation flow | `00-overview.md`, `01-design.md` |
| 2026-11-15 | Slice 1 / Task 1.2 | Replaced `node:crypto` with pure isomorphic FIPS 180-4 `sha256Hex` in `@citerra/core` so browser Vite/WXT and React Native Hermes bundles compile with zero Node polyfills | `03-implementation-stage.md` |
