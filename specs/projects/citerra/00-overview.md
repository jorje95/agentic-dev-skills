# Citerra — Stage 1: Overview & Capability Map

- **Project Slug:** `citerra`
- **Status / Stage:** `Design`
- **Tech Stack:** Firebase (Cloud Functions v2 TS, Firestore, Hosting, Remote Config, Crashlytics), WXT + React 19 (Chrome MV3 Extension), React 19 + Vite (Landing Page & Web Sandbox), React Native + Expo + Kotlin Native Modules (Mobile), Gluestack UI v2 + NativeWind v4 (Shared Cross-Platform UX)
- **Workspace / Repo:** `/Users/nitroi/.gemini/antigravity/scratch/citerra` (`github.com/jorje95/citerra` — Private)
- **Last Updated:** 2026-11-15

---

## 1. Objective & Vision

- **Problem Statement:** Users reading articles, posts, and web content across desktop and mobile lack a fast, privacy-preserving way to verify the factuality of a selected paragraph against credible independent sources without sending their personal browsing history or raw private text to cloud AI providers.
- **Reframed Success Criteria (Measurable & Testable):**
  - [ ] **Right-Click & Mobile Selection Entrypoint:** Selecting a paragraph on Desktop Chrome (`chrome.contextMenus`) or Mobile (`Android ACTION_PROCESS_TEXT` / iOS & Android Share Sheet) opens the unified Citerra Side Panel / Bottom Sheet and initiates verification in `< 150ms`.
  - [ ] **Fast Trending Cache (`< 100ms` p95):** Claims that have reached the `k >= 3` anonymity threshold resolve from the Firestore 24h Canonical Claim Cache in `< 100ms` without requiring full local LLM inference.
  - [ ] **On-Device AI Tiered Inference:** Uncached claims decompose locally via Tier 1 (`window.ai` Gemini Nano / Mobile AICore), Tier 2 (WebLLM WebGPU / MediaPipe quantized 1.5B model), or Tier 3 (local Ollama), sending only stripped keyword queries to the Blind Search Proxy.
  - [ ] **100% Local Private History:** Search and verification history is stored exclusively on-device (`Dexie.js` IndexedDB on Web/Extension, `op-sqlite` with SQLCipher on Mobile) with instant local search, JSON/CSV export, and one-click wipe.
  - [ ] **Zero-PII Telemetry & 3-Tier Environments:** Automated isolation across `local` (Firebase Emulators), `staging`, and `prod` projects, collecting strictly validated zero-PII operational telemetry.
  - [ ] **Unified Cross-Platform UX & Donations:** Shared UI components via `Gluestack UI v2 + NativeWind v4`, an automatic `/welcome` onboarding + donation page on first install, and Buy Me a Coffee / Ko-fi integration.

## 2. Explicit Assumptions

- **V1 Scope is Text + Source Metadata Only:** V1 focuses strictly on selected text paragraphs plus page source metadata (URL domain, OpenGraph/JSON-LD publisher, author, date). Video transcript/frame extraction is deferred to V2.
- **k-Anonymity Privacy Gate (`k >= 3`):** No canonical claim text or verdict is stored in the shared 24h Firestore cache until at least 3 independent lookups of the same normalized claim hash have occurred on public domains.
- **Private Repository Enforcement:** Both the project repository (`jorje95/citerra`) and the global specs/skills repository (`jorje95/agentic-dev-skills`) must remain strictly **private** on GitHub.

## 3. Capability Map (Module Spec Tree)

> Each capability module below maps to a child spec node in [`modules/<module-id>/spec.md`](./modules/) as implementation slices begin.

| Module ID (`kebab-case`) | Responsibility & Scope | Depends On | Child Spec |
| :--- | :--- | :--- | :--- |
| `shared-core` | `@citerra/core`: Claim normalization, SHA-256 hashing, NLI prompts, Zod schemas, source credibility scoring, zero-PII telemetry builder | — | `modules/shared-core/spec.md` |
| `shared-ui` | `@citerra/ui`: Cross-platform Gluestack UI v2 + NativeWind v4 components (VerdictCard, CitationList, HistoryDrawer, DonateBanner) + generated brand assets | `shared-core` | `modules/shared-ui/spec.md` |
| `firebase-backend` | Cloud Functions v2 (`corroborate`, `submitVerdict`, `ingestTelemetry`), Two-Tier Firestore TTL Cache (`k >= 3`), Firestore Security Rules, 3-tier env config | `shared-core` | `modules/firebase-backend/spec.md` |
| `web-landing` | React 19 + Vite product showcase website (`/`, `/welcome`, `/donate`, `/privacy`, `/admin/telemetry`) + interactive live sandbox hosted on Firebase Hosting | `shared-ui`, `firebase-backend` | `modules/web-landing/spec.md` |
| `chrome-extension` | WXT Manifest V3 extension: `contextMenus`, `sidePanel`, Offscreen WebGPU/Gemini Nano inference worker, Dexie.js local history, `/welcome` install trigger | `shared-ui`, `firebase-backend` | `modules/chrome-extension/spec.md` |
| `mobile-companion` | Expo + React Native app with Kotlin `ACTION_PROCESS_TEXT` & iOS/Android Share Sheet extension, MediaPipe/AICore native module, `op-sqlite` history | `shared-ui`, `firebase-backend` | `modules/mobile-companion/spec.md` |

**Build Order:** `shared-core` → `firebase-backend` → `shared-ui` → `web-landing` → `chrome-extension` → `mobile-companion`

## 4. Boundaries (`Always` / `Ask First` / `Never`)

- **Always:**
  - Keep all GitHub repositories **private**.
  - Delegate any `firestore.rules` creation or modification to the `firestore-rules-author` subagent.
  - Validate every incoming payload in Firebase Cloud Functions with strict `Zod` schemas and reject unexpected fields.
  - Run unit/emulator tests before checking off tasks in `03-implementation-stage.md`.
- **Ask First:**
  - Adding paid external search provider APIs (e.g., Brave Search, Tavily) beyond free tiers (Google Fact Check Tools API, Wikipedia/Wikidata, Crossref).
  - Changing the `k >= 3` anonymity threshold or TTL durations (`24h` claim cache, `6h` keyword cache).
- **Never:**
  - Send raw selected text from private/authenticated pages (e.g., `mail.google.com`, `docs.google.com`, intranet URLs) to the backend cache.
  - Log user IP addresses, persistent user IDs, or full browsing URLs in Firestore or Cloud Functions logs.
  - Commit API keys, `.env` secrets, or Firebase service account JSON files.

## 5. Out of Scope (Deferred V2 Backlog)

- **Video Content Extraction (V2):** Capturing `<video>` captions/frames/audio via Offscreen Whisper/OCR for right-clicking on video players.
- **User Accounts & Cloud History Sync (V2):** Optional end-to-end encrypted cloud sync of search history across devices.
- **Community Notes / Crowdsourced Annotations (V2):** User-submitted counter-evidence and peer voting.

## 6. Resolved Design Decisions (`/grill-me` Log)

- [x] **Project Name & Privacy:** Named **Citerra** (`citerra`), zero store collisions; all GitHub repos strictly private.
- [x] **Cross-Platform UX System:** **Gluestack UI v2 + NativeWind v4** shared across Web, Chrome Extension Side Panel, and React Native Mobile Bottom Sheet.
- [x] **Backend Stack:** **Pure Firebase Backend** (Cloud Functions v2, Firestore with TTL policies, Hosting, Remote Config, Crashlytics) across 3 isolated environments (`local` emulators, `staging`, `prod`).
- [x] **Caching & Privacy:** **Two-Tier Firestore Cache** (24h Canonical Claim Cache + 6h Keyword Evidence Cache) with **`k >= 3` threshold-gated promotion**.
- [x] **Donations & Onboarding:** Install triggers `/welcome` tab on the Landing Page with **Buy Me a Coffee / Ko-fi** embed + subtle footer links.
