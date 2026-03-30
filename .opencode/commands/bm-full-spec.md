---
description: "ONE-SHOT: requirements.md + ux_spec.html → PRD + Architecture + Stories ready-to-implement (BMAD)"
---

The user has provided `requirements.md` and `ux_requirements.html` as inputs. Use them as the ONLY source of truth. Do not ask any questions — execute all steps immediately using default BMAD output locations.

## Execution Steps (run all without stopping)

### Step 1 — PRD
Run `bmad-create-prd` using the provided `requirements.md` + `ux_requirements.html`.

### Step 2 — Architecture
Run `bmad-create-architecture` using the PRD from Step 1 + original inputs.

### Step 3 — Stories & Tasks
Run `bmad-create-epics-and-stories` using PRD + Architecture.
- Priority order: DB migrations → Backend API → Frontend components → Integration
- Each task must have acceptance criteria (Given/When/Then) and effort estimate (S/M/L)

### Step 4 — Implementation Readiness Check
Run `bmad-check-implementation-readiness` (or equivalent) to confirm all stories are implementation-ready.

## Project Constraints (inject into every workflow step)

- Tech stack: Next.js App Router (TypeScript) port 3002, FastAPI (Python) port 8002, PostgreSQL via SQLAlchemy async + Alembic
- Reuse shared components: `Sidebar`, `SearchTrigger`, `PageLayout`, `Breadcrumb` — never reinvent them
- Language: Vietnamese for business/requirement content, English for technical specs (DDL, API paths, component names)
- Do not output any explanation until all steps are complete
