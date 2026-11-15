# Project Portfolio & Living Specs Index

This is the master index of all projects and their **Hierarchical Living Spec Trees**. Every project progresses through four living specification stages—**Overview**, **Design**, **Testing Playbook**, and **Implementation Stage**—plus modular child specs under `modules/`.

> **Living Spec Rule:** Whenever any project's requirements, architecture, API contracts, testing scenarios, or implementation progress changes, update its spec tree under `specs/projects/<project-slug>/`, update its status row below, and sync to GitHub via `./scripts/sync-to-github.sh`.

---

## Active & Planned Projects

| Project ID (`slug`) | Project Name | Current Stage | Tech Stack | Spec Tree Root | Workspace / Repo | Last Updated |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| *(none yet — run `./scripts/init-project-spec.sh <slug> "<Name>" "<Stack>"` to scaffold your first project)* | — | — | — | — | — | — |

---

## Stage Definitions & Gate Criteria

| Stage | Spec Node | Exit / Gate Criteria |
| :--- | :--- | :--- |
| **1. Overview** | `00-overview.md` | Objectives, measurable success criteria, explicit assumptions, Capability Map (module tree), and Always/Ask/Never boundaries approved. |
| **2. Design** | `01-design.md` | System architecture, database schema/migrations, cross-layer API contracts (Kotlin DTOs ↔ TypeScript interfaces), and ADRs locked. |
| **3. Testing Playbook** | `02-testing-playbook.md` | Unit (JUnit/MockK, Vitest/RTL), Slice (`@WebMvcTest`, Testcontainers), edge-case matrix, and mobile UX verification playbooks defined. |
| **4. Implementation** | `03-implementation-stage.md` | Disjoint vertical slices assigned to model tiers (`flash_lite` / `flash` / `pro`), tasks checked off with passing verification commands, and rulings logged. |
