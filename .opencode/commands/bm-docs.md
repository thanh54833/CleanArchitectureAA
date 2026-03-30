---
description: Full BMAD discovery — autonomous scan + update docs (no prompts)
---

Run full BMAD project discovery **autonomously without any user prompts**.

## Phase 1: Document Project Scan

1. Execute `bmad-document-project` skill in **full_rescan** mode
2. **ALWAYS select "Re-scan entire project"** (option 1) when prompted about existing docs
3. **ALWAYS select "Start fresh"** (option 2) when prompted about state files
4. Skip any interactive confirmations — proceed automatically

## Phase 2: Project Context Update

1. Execute `bmad-generate-project-context` skill
2. When existing `project-context.md` is found, **select "Update"** mode
3. After discovery, **always select [C] Continue** to generate context
4. Focus on updating these critical sections:
   - Tech stack (add Redis, asyncpg if missing)
   - Backend conventions (add centralized connection management pattern)
   - API endpoints (add new extract router)
   - Anti-patterns (add new findings)

## Phase 3: Key Findings Summary

After both phases complete, report:

1. **New files discovered** (not in previous scan)
2. **Changed patterns** (modified since last scan)
3. **Still-open issues** (known problems not yet fixed)
4. **Recommendation** for next actions

## Execution

Start immediately. Do not ask questions. Archive old state if needed, then proceed with full_rescan → project-context update → summary.
