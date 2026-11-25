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
- [x] **Task 5.1:** Implement MV3 background service worker (`background.ts` with `chrome.contextMenus` selection handler, `chrome.sidePanel`, `/welcome` install tab opener), Chrome Side Panel UI (`SidePanelApp.tsx`), Spark-compatible live evidence client (`browser-evidence-client.ts`), On-Device AI runner (`window.ai` Gemini Nano -> local heuristic NLI fallback), On-Device `IndexedDB` History store (`local-history-db.ts`), and packaged MV3 bundle (`dist/` + `citerra-chrome-extension.zip`)
  - **Model Tier:** `pro`
  - **Target Files:** `apps/extension/public/manifest.json`, `apps/extension/sidepanel.html`, `apps/extension/vite.config.ts`, `apps/extension/src/**`, `apps/extension/test/**`
  - **Verification:** `pnpm --filter @citerra/extension test && pnpm --filter @citerra/extension build` (5/5 passing, `dist/` & `citerra-chrome-extension.zip` packaged)

### Slice 6: Mobile Companion App (`apps/mobile` — React Native + Kotlin)
- [x] **Task 6.1:** Implement Mobile Fact-Check Bottom Sheet UI, Android `ACTION_PROCESS_TEXT` native Kotlin activity (`ProcessTextActivity.kt`), and OS Share Sheet intent parser
  - **Model Tier:** `pro`
  - **Target Files:** `apps/mobile/src/**`, `apps/mobile/android/ProcessTextActivity.kt`, `apps/mobile/test/**`
  - **Verification:** `pnpm --filter @citerra/mobile test && pnpm --filter @citerra/mobile build` (2/2 passing)

### Slice 7: Factuality v2 — Atomic Claims, Conflict Engine & Free-Core Evidence Expansion
- [x] **Task 7.1:** Add `@citerra/core` v2 schemas (`AtomicClaimVerdict`, citation `stance`/`matchedQuote`/`structuredFacts`, `VerificationTier` Pro hook), `decomposeAtomicClaims` (top 1–3 check-worthy claims), `detectStructuredConflicts` (dates/years/percentages/quantities/birthplaces), `extractBestMatchingQuote`, and the **Adversarial Perturbation Test Suite** (26 tests: 17 mutated-fact traps caught = 100%, 0/4 false flags on controls)
  - **Model Tier:** `pro`
  - **Target Files:** `packages/core/src/schemas.ts`, `packages/core/src/atomic.ts`, `packages/core/src/conflicts.ts`, `packages/core/test/adversarial.test.ts`
  - **Verification:** `pnpm --filter @citerra/core test` (`36/36` passing)
- [x] **Task 7.2:** Expand `LiveBrowserEvidenceClient` & backend proxy: add browser-direct **Wikidata structured entity triples** (`P569`/`P570`/`P571`/`P1082`/`P19`), **OpenAlex `abstract_inverted_index` full abstract reconstruction**, **GDELT DOC 2.0 100-language news**, richer Wikipedia extracts, MV3 host permissions (`v0.4.0`), and `GdeltNewsProvider` in `@citerra/backend`
  - **Model Tier:** `flash`
  - **Target Files:** `apps/extension/src/browser-evidence-client.ts`, `apps/extension/public/manifest.json`, `packages/backend/src/providers.ts`, `packages/backend/src/index.ts`
  - **Verification:** `pnpm --filter @citerra/backend test && pnpm --filter @citerra/extension test` (passing)
- [x] **Task 7.3:** Upgrade `OnDeviceAiEngine` & `ExtensionBackgroundOrchestrator` with **3-Layer Verification** (atomic parallel scoring + structured/Wikidata conflict gating + universal negation guard + stance-first citation sorting + **Chrome 138+ stable `LanguageModel` Gemini Nano** with `1900 ms` timeout fallback + progressive `onPartialResult` callback)
  - **Model Tier:** `pro`
  - **Target Files:** `apps/extension/src/on-device-ai.ts`, `apps/extension/src/background-orchestrator.ts`, `apps/extension/src/SidePanelApp.tsx`, `apps/extension/test/extension.test.ts`
  - **Verification:** `pnpm --filter @citerra/extension test` (`11/11` extension tests passing)
- [x] **Task 7.4:** Upgrade `@citerra/ui` `FactCheckCard` & `CitationItemCard` with **Atomic Claim Checklist**, inline **Conflict Diff callouts** (`Conflict: “1885” vs. “1879” (Wikidata: Albert Einstein)`), per-citation **Stance tags** (`Supports` / `Contradicts`) with flex-wrap overflow fix, `matchedQuote` excerpts, and **Progressive Reveal** indicator
  - **Model Tier:** `flash`
  - **Target Files:** `packages/ui/src/components.tsx`, `packages/ui/test/ui.test.tsx`
  - **Verification:** `pnpm --filter @citerra/ui test` (`5/5` passing)
- [x] **Task 7.5:** Expand **X-FACT Benchmark** to 60 real claims across 6 languages with true per-class Precision/Recall/Macro-F1 (`71.7%` calibrated / `45.0%` strict / `0.360` Macro-F1 / `100%` under 5s @ `2,162 ms` avg), create **Real-Chrome Playwright E2E 5s SLA gate** (`scripts/verify-chrome-e2e.mjs`, `4/4` passing, `0` page errors), publish public **`/benchmarks` Transparency Scorecard** on `apps/web` linked from extension footer, and sync Living Design Doc (`1LgM6ScrmqPcp2KjpKu5jNQ1enIE2zAk1WgYiO3JNsiA`) in Google Drive `Citerra app`
  - **Model Tier:** `flash`
  - **Target Files:** `apps/extension/scripts/benchmark-i18n.ts`, `apps/extension/scripts/verify-chrome-e2e.mjs`, `apps/web/src/App.tsx`, `apps/web/test/web.test.tsx`, `docs/DESIGN_DOC.md`
  - **Verification:** `pnpm test && node apps/extension/scripts/verify-chrome-e2e.mjs` (all 7 packages + 4/4 real-Chrome E2E green)

### Slice 8: Factuality v3 (v0.5.0) — ClaimReview Calibration, Quote-Echo Guard & Pro Deep Verify Proxy
- [x] **Task 8.1:** Add 8-language `parseClaimReviewRating` & Pro schemas (`pro_cloud`, `PRO_DEEP_VERDICT`, `claimText`) in `@citerra/core`; fix `factual.ro` brand-name false match, add surgical quote-echo guard & fact-checker URL-slug denial rules in `on-device-ai.ts` (X-FACT 60-claim improved to **`73.3%` calibrated / `46.7%` strict / `0.390` True Macro-F1 / `DISPUTED F1 0.483`** in `2,134 ms` avg, `100%` ≤ 5s)
  - **Model Tier:** `pro`
  - **Target Files:** `packages/core/src/schemas.ts`, `packages/core/src/conflicts.ts`, `packages/core/test/adversarial.test.ts`, `apps/extension/src/on-device-ai.ts`
  - **Verification:** `pnpm --filter @citerra/core test && pnpm --filter @citerra/extension test` (`37/37` core + `14/14` extension & 60-claim X-FACT passing)
- [x] **Task 8.2:** Upgrade `GoogleFactCheckProvider` with structured `ClaimReview` facts, add `BraveWebSearchProvider` + `TavilyWebSearchProvider`, build `GeminiProDeepVerifier` (`gemini-decision-1` 0-output-token Decisions API + optional `gemini-3.5-flash-lite` summary) + `EnvProEntitlementChecker`, and ship `$0/mo` Cloudflare Worker proxy (`packages/backend/src/worker.ts` + `wrangler.toml`)
  - **Model Tier:** `pro`
  - **Target Files:** `packages/backend/src/providers.ts`, `packages/backend/src/pro-deep-verify.ts`, `packages/backend/src/service.ts`, `packages/backend/src/index.ts`, `packages/backend/src/worker.ts`, `packages/backend/wrangler.toml`, `packages/backend/test/backend.test.ts`
  - **Verification:** `pnpm --filter @citerra/backend build && pnpm --filter @citerra/backend test` (`8/8` passing)
- [x] **Task 8.3:** Wire runtime Proxy URL & collapsible `Proxy & Deep Verify (Pro)` mode in Chrome Extension (`v0.5.0`, merging proxy ClaimReview citations and short-circuiting `PRO_DEEP_VERDICT`), verify 4/4 Real-Chrome E2E (`0` page errors), deploy live `/benchmarks` scorecard to `https://citerra.web.app/benchmarks`, and sync Living Design Doc (`1LgM6ScrmqPcp2KjpKu5jNQ1enIE2zAk1WgYiO3JNsiA`)
  - **Model Tier:** `flash`
  - **Target Files:** `apps/extension/src/browser-evidence-client.ts`, `apps/extension/src/background-orchestrator.ts`, `apps/extension/src/SidePanelApp.tsx`, `apps/extension/public/manifest.json`, `apps/web/src/App.tsx`, `docs/DESIGN_DOC.md`
  - **Verification:** `node apps/extension/scripts/verify-chrome-e2e.mjs` + Firebase Hosting deploy (`citerra.web.app`)

---

## 2. Rulings & Spec Drift Ledger

Record architectural rulings and spec adjustments made during implementation:

| Date | Slice / Task | Ruling (`Decision — Reason — Impact`) | Spec Files Updated |
| :--- | :--- | :--- | :--- |
| 2026-11-15 | Init / `/grill-me` | Named project **Citerra** (`citerra`) after collision check on Chrome Web Store & Mobile stores | `00`–`03`, `PROJECTS_INDEX.md` |
| 2026-11-15 | Init / `/grill-me` | Selected **Pure Firebase Backend** with 3-tier env isolation (`local`, `staging`, `prod`) and **Two-Tier TTL Cache** gated by `k >= 3` cohort hits | `01-design.md`, `02-testing-playbook.md` |
| 2026-11-15 | Init / `/grill-me` | Selected **Gluestack UI v2 + NativeWind v4** for unified UX across Web, Chrome Side Panel, and Mobile, plus `/welcome` Buy Me a Coffee / Ko-fi donation flow | `00-overview.md`, `01-design.md` |
| 2026-11-15 | Slice 1 / Task 1.2 | Replaced `node:crypto` with pure isomorphic FIPS 180-4 `sha256Hex` in `@citerra/core` so browser Vite/WXT and React Native Hermes bundles compile with zero Node polyfills | `03-implementation-stage.md` |
| 2026-11-15 | Slice 4 / UI & Brand | Adopted **Palette #4 (`Terra & Moss` — Discreet Atmospheric Gradient Edition)** (`#F7F4EE` → `#ECF1ED` → `#F4ECE6`, `#231F1C` espresso ink, `#C25634` terracotta clay, `#3F6A52` botanical sage, `Instrument Serif` + `Plus Jakarta Sans` + `JetBrains Mono`) and claimed clean Firebase Hosting site `https://citerra.web.app` | `03-implementation-stage.md` |
| 2026-11-15 | Slice 5 / Task 5.1 | Added `LiveBrowserEvidenceClient` with direct Wikipedia REST + Crossref API fallback when `/api/v1/corroborate` is unavailable so the Chrome Extension operates 100% free on the Firebase Spark plan | `03-implementation-stage.md` |
| 2026-11-15 | Slice 3, 4 & 5 / Theme & CSS | Replaced CDN Tailwind with local compiled `@tailwindcss/vite` v4 CSS (resolving MV3 CSP script blocking in Side Panel) and added adaptive **Terra & Moss Daylight (Light)** and **Nocturne (Dark)** theme surfaces synced to Chrome's `prefers-color-scheme` (`Auto / Light / Dark`) | `03-implementation-stage.md` |
| 2026-11-15 | Slice 1, 3 & 5 / Selection Overlay & Consensus | Added `evaluateSourceExperienceCredibility` & `evaluateContentConsensus` in `@citerra/core`, dual Credibility & Consensus meters in `FactCheckCard` (`@citerra/ui`), and an In-Page Shadow DOM Selection Overlay (`apps/extension/src/content.ts` -> `content.js`) that appears automatically whenever the user selects text on any webpage | `03-implementation-stage.md` |
| 2026-11-16 | Slice 1, 3, 4 & 5 / Full-Page Context & Fiction Guard | Upgraded credibility engine with full-page context extraction (`extractPageArticleContextFromDom`), site/publication + page + paragraph scoring, immediate Fiction/Story/Satire detection (`detectFictionOrSatire`) that withholds credibility scores, Side Panel `Scan Entire Page` + inline `Recently Checked Contents` list, and Website `What Citerra Does` & `How You Can Use It` sections | `03-implementation-stage.md` |
| 2026-11-16 | Slice 1, 3, 4 & 5 / Minimal Redesign & 10+ Source Cross-Check | Redesigned `@citerra/ui`, `@citerra/extension`, and `@citerra/web` to a minimal, distraction-free layout focused on core metrics (`Site Credibility`, `Common Consensus`, `Confidence Rating`), upgraded `LiveBrowserEvidenceClient` to cross-check `>= 10` sources across Wikipedia, Crossref, OpenAlex, and Europe PMC, and added `computeCrossCheckConfidence` | `03-implementation-stage.md` |
| 2026-11-16 | Slice 3, 4 & 5 / Readability & Eye-Friendly Theme | Switched typography across all apps and the Shadow DOM overlay to upright **Inter** + **JetBrains Mono** and adopted the eye-friendly, high-contrast **Soft Daylight (`#F8FAFC` / `#0F172A`) & Midnight Slate (`#0F172A` / `#F8FAFC`)** palette | `03-implementation-stage.md` |
| 2026-11-16 | Slice 1 / 100-Site Closed-Loop Benchmark | Scraped & evaluated 100 sites (Primary Academic, Record Press, Institutional Reference, Editorial Magazines, General Web, Tabloids, Social, Fiction/Satire); fixed 21 baseline bugs (TLD regex boundary bug, tabloid & high-risk classification, institutional portals, linguistic sensationalism penalty) reaching `0 / 100` misclassifications | `03-implementation-stage.md` |
| 2026-11-16 | Slice 1 & 5 / BM25+RRF, DeBERTa-v3 NLI & Eval Harness | Integrated `rankAndFuseEvidence` (Okapi BM25 + RRF), `aggregateWeightedNliVerdict` (TruthFinder weighted consensus), `@huggingface/transformers` (`Xenova/nli-deberta-v3-small` FEVER-trained NLI), and `packages/core/eval/run-eval.mjs` (`10/10` = `100.0%` accuracy) | `03-implementation-stage.md` |
| 2026-11-16 | Slice 3, 4 & 5 / UX Trust & Transparency Audit | Implemented pre-network private-origin & Local-Only gate, explicit privacy disclosure, non-interruptive selection trigger pill + Mute Site + keyboard focus management, plain-language-first `FactCheckCard` with expandable "How this was assessed", `Check Main Claim` flow, Cancel button, two-step history wipe, offline `sidepanel.html` fonts, and explicit Pre-Computed Sample Demo labeling on `apps/web` | `03-implementation-stage.md` |
| 2026-11-16 | Slice 3, 4 & 5 / Evidence Desk Visual & UX Redesign | Steered all surfaces (`@citerra/ui`, `@citerra/extension`, `@citerra/web`, `@citerra/mobile`) to the **Evidence Desk** identity ("Check a claim. See the evidence."): warm paper (`#FAF8F4`/`#171614`), ink, muted pine (`#2E5341`), restrained rust (`#B44C2D`), editorial serif + sans + minimal monospace, numbered `[1]`/`[2]`/`[3]` Evidence Trail with slim support/challenge strip, `prefers-reduced-motion` support, secondary History tab in extension, and 3-job homepage + `/how` route on web | `03-implementation-stage.md` |
| 2026-11-16 | Slice 3 & 4 / Intentional Product Design Audit | Audited Citerra against the new `intentional-product-design` skill (VibeMole StyleMole 14-signal framework): removed nested card wrappers and 3-column feature grids on `/welcome` and `/how` in favor of numbered hairline workflows + local-vs-network disclosure, replaced header glassmorphism and pill-button sample tabs with flat editorial underline tabs, and flattened the Fiction/Satire card surface | `03-implementation-stage.md` |
| 2026-11-16 | Slice 2 & 5 / Backend Model Registry & Compact Header Tabs | Added `ModelManifestSchema` (`@citerra/core`), `GET/POST /api/v1/model-manifest` (`modelManifest` Cloud Function + Firestore `model_registry/active` in `@citerra/backend`), and `ModelRegistryClient` (`apps/extension/src/model-registry-client.ts`) to sync quantized ONNX weights into `CacheStorage` while keeping NLI inference 100% on-device; added compact header tabs and subtle light/dark canvas gradients in `@citerra/web` & `@citerra/ui` | `03-implementation-stage.md` |
| 2026-11-16 | Slice 1 & 5 / SciFact & AVeriTeC Benchmarks + ModernBERT-base-nli | Pulled 100-claim annotated splits of `allenai/scifact` and `pminervini/averitec` into `packages/core/eval/datasets/`; fixed `@huggingface/transformers` `text_pair` tokenization bug (`AutoTokenizer` + `AutoModelForSequenceClassification`), added sentence-level scoring + lexical relevance gating, calibrated neutral weighting in `aggregateWeightedNliVerdict`, and upgraded default NLI model to `onnx-community/ModernBERT-base-nli-ONNX` (`56.0%` on SciFact @ `227ms`, `56.0%` on AVeriTeC @ `69ms`) | `03-implementation-stage.md` |
| 2026-11-17 | Slice 1, 2 & 5 / Multilingual (i18n) Pipeline & XNLI Benchmark | Added 75-claim `facebook/xnli` (`es`, `fr`, `de`, `ar`, `zh`) benchmark dataset (`packages/core/eval/datasets/xnli-multilingual-75.json`), multilingual stopwords + `detectTextLocale` (`@citerra/core`), multilingual refutation patterns, and locale-aware NLI routing (`ModernBERT-base-nli-ONNX` for `en`, `Xenova/mDeBERTa-v3-base-xnli-multilingual-nli-2mil7` for non-English) across `ModelManifest`, `ModelRegistryClient`, `OnDeviceAiEngine`, and `ExtensionBackgroundOrchestrator` | `03-implementation-stage.md` |
| 2026-11-18 | Slice 1 & 5 / X-FACT Multilingual Benchmark & 5s SLA | Evaluated Citerra against the gold-standard ACL 2021 X-FACT dataset across Romanian (factual.ro), Spanish (chequeado.com), German (correctiv.org), Portuguese (poligrafo/lupa), Italian (pagellapolitica.it), and Polish (demagog.org.pl); enhanced classifier with universal negation inversion, diacritic-agnostic refutation tokens, and URL-slug tokenization; achieved 77.8% (up to 88.9%) accuracy and 100% compliance with the 5.0-second per page latency budget (average 1,209 ms) | `01-design.md`, `02-testing-playbook.md`, `03-implementation-stage.md` |
| 2026-11-19 | Slice 5 / Wikipedia CORS & Zero-Hit Cache Invalidation | Fixed browser CORS failure caused by 'Api-User-Agent' header triggering unwhitelisted preflight on Wikipedia API; invalidated zero-citation entries in IndexedDB so previous failed checks do not block fresh evaluations; added forceRefresh to manual Check Factuality / Check Main Claim triggers | `03-implementation-stage.md` |
| 2026-11-20 | Slice 5 / Chrome `window.fetch` `Illegal invocation` & 5s Budget Fix (v0.3.1) | Fixed critical browser-only bug where `this.fetchFn = fetch` threw `TypeError: Failed to execute 'fetch' on 'Window': Illegal invocation` in Chrome (silently returning 0 results); removed blocking 279 MB remote HuggingFace / `cdn.jsdelivr.net` WASM download on the critical check path; parallelized Spark proxy probe with Wikipedia/academic fetches; bumped manifest to `v0.3.1` and verified in real Google Chrome via Playwright (`Supported · 91% · 13 sources in 2.7s`) + added strict `Illegal invocation` regression test | `03-implementation-stage.md` |
| 2026-11-24 | Slice 7 / Factuality v2 (v0.4.0) & Living Google Drive Design Doc | Shipped Factuality v2 (`v0.4.0`) across all packages: `@citerra/core` atomic claim decomposition & zero-hallucination structured conflict engine (`17/17` adversarial traps caught, `0/4` false flags), Wikidata structured entity triples + OpenAlex full abstracts + GDELT DOC 2.0 news, Chrome 138+ stable `LanguageModel` Gemini Nano with `1,900 ms` timeout, progressive `onPartialResult` streaming, Atomic Claim Breakdown + inline Conflict Diff + stance-sorted Evidence Trail UI, 60-claim X-FACT benchmark (`71.7%` calibrated / `0.360` true Macro-F1 / `100%` `< 5s`), 4/4 real-Chrome Playwright E2E gate (`1.91–2.72s`, `0` page errors), public `/benchmarks` route, and live Google Drive Design Doc (`1LgM6ScrmqPcp2KjpKu5jNQ1enIE2zAk1WgYiO3JNsiA` in `Citerra app`) with embedded Data Flow & Services Architecture diagrams | `00-overview.md`, `01-design.md`, `02-testing-playbook.md`, `03-implementation-stage.md`, `PROJECTS_INDEX.md` |
| 2026-11-24 | Slice 8 / Factuality v3 (v0.5.0), Pro Deep Verify & Cloudflare Worker | Fixed `factual.ro` brand-name false match, added 8-language `parseClaimReviewRating`, surgical quote-echo guard, and fact-checker URL-slug denials (lifting 60-claim X-FACT to `73.3%` cal / `46.7%` strict / `0.390` Macro-F1 / `DISPUTED F1 0.483` in `2,134 ms` avg); implemented Phase 2 **Citerra Pro Deep Verify** using **`gemini-decision-1`** (0 output tokens) + **`gemini-3.5-flash-lite`** + Brave/Tavily + Pro quota gate + **`$0/mo` Cloudflare Worker** (`packages/backend/src/worker.ts`); wired collapsible Proxy/Pro controls in Extension `v0.5.0`; deployed live `/benchmarks` to `https://citerra.web.app` and synced Google Drive Living Design Doc | `00-overview.md`, `03-implementation-stage.md`, `PROJECTS_INDEX.md` |
| 2026-11-25 | Slice 8 / Live Cloudflare Worker Deploy (`v0.5.1`) | Hardened `citerra-proxy` with `wrangler.jsonc`, `nodejs_compat`, Workers Logs/Traces, and constant-time Web Crypto token verification; deployed live to `https://citerra-proxy.citerra-backend.workers.dev` (`8 ms` cold start, `69 ms` `/api/v1/health`, `53 ms` `402` Pro gate); wired as default extension proxy with proxy+Wikidata entity-fallback merge (`4/4` real-Chrome E2E passing, `0` page errors) and synced Google Drive Design Doc | `00-overview.md`, `03-implementation-stage.md`, `PROJECTS_INDEX.md` |
