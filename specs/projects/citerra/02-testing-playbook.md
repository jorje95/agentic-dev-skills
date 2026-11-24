# Citerra — Stage 3: Testing Playbook & Verification Matrix

- **Project Slug:** `citerra`
- **Design Reference:** [01-design.md](./01-design.md)
- **Last Updated:** 2026-11-15

---

## 1. Backend & Security Rules Testing Matrix (`Firebase Functions v2` + `Firestore Emulator`)

| Test Layer | Target Module | Tooling | Key Scenarios Covered | Command |
| :--- | :--- | :--- | :--- | :--- |
| **Shared Schemas & Hashing** | `@citerra/core` | Vitest | Claim normalization determinism, SHA-256 hashing, private-domain blocklist (`mail.google.com`, `localhost`, `docs.google.com`), Zod boundary rejections | `pnpm --filter @citerra/core test` |
| **Firestore Security Rules** | `firestore.rules` | `@firebase/rules-unit-testing` + Firestore Emulator | Verify direct client SDK reads/writes to `claim_hits`, `claim_cache_24h`, `keyword_cache_6h`, and `telemetry_events` are denied (`PERMISSION_DENIED`) | `pnpm --filter @citerra/backend test:rules` |
| **Corroborate & Cache Service** | `functions/src/corroborate` | Vitest + Firebase Functions/Firestore Emulator | 1) Cache miss (`hitCount = 1, 2`) returns `EVIDENCE_ONLY` with `promotionEligible: false`; 2) 3rd distinct cohort hit sets `promotionEligible: true`; 3) `claim_cache_24h` hit returns `CACHE_HIT_VERDICT` in `<100ms` | `pnpm --filter @citerra/backend test:unit` |
| **Telemetry Sanitizer** | `functions/src/telemetry` | Vitest | Rejects payloads containing URLs, emails, high-entropy strings, or unrounded timestamps (`400 Bad Request`) | `pnpm --filter @citerra/backend test:telemetry` |

## 2. Web & Chrome Extension Testing Matrix (`React 19` + `WXT`)

| Component / Hook / Entrypoint | Tooling | Scenarios (`loading`, `error`, `empty`, `success`) | Command |
| :--- | :--- | :--- | :--- |
| **Shared UI (`@citerra/ui`)** | Vitest + React Testing Library + `jest-axe` | `<VerdictCard />`, `<CitationList />`, `<HistoryList />`, `<SupportBanner />` across all 4 verdict states + AXE accessibility audit | `pnpm --filter @citerra/ui test` |
| **Landing Page & Sandbox (`apps/web`)** | Vitest + RTL | `/welcome` onboarding flow, `/donate` Ko-fi/BMC card rendering, Interactive Fact-Check Sandbox state transitions | `pnpm --filter @citerra/web test` |
| **Chrome Extension (`apps/extension`)** | Vitest + `fake-indexeddb` + WXT Test Utils | Right-click context menu payload routing, Dexie.js local history CRUD + JSON export + wipe, local cache hit bypass, Tier 1→2 AI fallback | `pnpm --filter @citerra/extension test` |

## 3. Mobile Testing & Device Playbook (`React Native` + `Kotlin`)

| Screen / Native Module | Verification Type | Checklist |
| :--- | :--- | :--- |
| **`FactCheckSheet` & `HistoryScreen`** | Jest + React Native Testing Library | Safe area insets (`react-native-safe-area-context`), `FlashList` memoized rendering, empty/error states, one-click history wipe |
| **Android `PROCESS_TEXT` Activity** | JUnit 5 + MockK (`android/`) | Intent extraction of `EXTRA_PROCESS_TEXT`, read-only handling, forwarding selected text to React Native bridge |

## 4. High-Risk Edge Cases & Failure Modes

1. **k-Anonymity Sybil / Replay Attack:** A single client sends 3 identical requests with the same `dailyCohortId` to force-promote a private string into `claim_cache_24h`. *Expected:* `distinctCohortHashes` deduplicates by `dailyCohortId`; `promotionEligible` remains `false`.
2. **Private URL / Intranet Selection:** User highlights text inside Gmail, Google Docs, Notion private workspace, or `localhost` / `192.168.*`. *Expected:* `@citerra/core` marks `isPrivateOrigin = true`; client never sends `claimHash` for cache promotion and forces local-only verification.
3. **Local AI Unavailable (No WebGPU & No `window.ai`):** User is on an older CPU-only laptop without Chrome Gemini Nano enabled. *Expected:* Extension gracefully falls back to WASM lightweight keyword extraction + displays evidence snippets from the Blind Search Proxy with a clear notice.
4. **External Search API Timeout / Rate Limit:** Wikipedia or Google Fact Check API times out. *Expected:* `Promise.allSettled` returns partial citations from surviving sources within a strict `3500ms` timeout budget instead of failing the whole request.

## 5. Factuality v2 — 3-Suite Release Gate (2026-11-24)

| Release Gate Suite | Dataset / Harness | Required Threshold | Command |
| :--- | :--- | :--- | :--- |
| **Suite 1: Expanded X-FACT Multilingual Benchmark** | 60+ real IFCN claims across `ro`, `es`, `de`, `pt`, `it`, `pl` (`dev.all.tsv` / `test.all.tsv`) with true per-class Precision, Recall, Macro-F1 & calibration | Accuracy $\ge 75\%$, real Macro-F1 reported transparently, $100\%$ under `5000ms` | `pnpm --filter @citerra/extension exec vitest run test/benchmark.test.ts` |
| **Suite 2: Adversarial Perturbation Suite** | 20+ mutated-fact test cases (wrong birth/event years e.g. `1885` vs `1879`, swapped cities/countries, altered percentages `85%` vs `37%`, subtle negation inversions, mixed true+false compound paragraphs) | Conflict detection recall $\ge 90\%$, zero false `SUPPORTED` on mutated dates/numbers | `pnpm --filter @citerra/core test` |
| **Suite 3: Real-Chrome E2E 5-Second SLA Gate** | Playwright against real Google Chrome loading unpacked `/dist` on live i18n pages (`humanitas.ro`, `reginamaria.ro`, news, hoax, satire) | `0` console `Illegal invocation` / CSP errors, latency $< 5000\text{ ms}$, verified atomic breakdown & citations | `pnpm --filter @citerra/extension exec node scripts/verify-chrome-e2e.mjs` |
