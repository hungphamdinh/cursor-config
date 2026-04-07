---
name: requirements-delivery
description: >-
  End-to-end delivery from BA/user requirements through multi-phase work: readonly
  exploration, Jest-only test updates, minimal implementation, and regression review.
  Use for React Native and business-logic-heavy changes, new features, change requests,
  bugfix specs, or when the user asks for requirements delivery, phased workflow, or
  explorer/tester/reviewer passes. Orchestrates subagents (explore, requirement-unit-tests,
  bug-detect) plus a single minimal final patch.
---

# Requirements Delivery (multi-phase)

Use this workflow when the ask includes new requirements, CRs, acceptance criteria, non-trivial bugfixes, or cross-cutting RN/state/API work.

**Trivial tasks** (single obvious file, typo, one-liner): skip subagent phases; implement directly and still follow project rules.

## Gate 0 — Project rules

1. Read **`AGENTS.md`** and **`.cursor/rules`** if present; treat them as binding unless the user overrides.
2. Restate the goal in one paragraph and split into **3–4 subtasks** when the work is non-trivial.

## Required inputs

From the prompt or repo context:

- Requirement text (scope, expected behavior, out-of-scope)
- Targets (e.g. iOS/Android, screens affected)
- Acceptance criteria and risk notes
- Constraints (API contracts, backward compatibility, flags)

If something critical is missing, state the **assumption** before coding.

## Phased delivery

Run phases **in order**. After each subagent phase, paste the **handoff block** into the main thread before continuing.

### 1) Read and normalize requirements (main)

- Checklist of expected outcomes; separate functional, non-functional, and edge cases.
- Note ambiguities; use safest assumption if unclear.

**Artifact:** `Requirements Checklist` (numbered, testable).

### 2) Impact sketch (main, brief)

- Map checklist items to layers: UI, state, API, data, permissions, analytics, tests.
- Initial risk: `low|medium|high` per area; flags, config, backend dependencies.

**Artifact:** `Impact Analysis` (initial).

### 3) Explorer phase (readonly)

**Purpose:** execution path, impacted files, **root cause only** (for bugs); no production edits.

**How:** Run a **readonly** exploration pass (e.g. Task `explore` with `readonly: true`). Search and read files; do not patch.

**Handoff block (required):**

```markdown
### Explorer handoff
- Execution path: …
- Impacted files: …
- Root cause / hypothesis: …
- Notes for implementer: …
```

Refine `Impact Analysis` if explorer contradicts the sketch.

**Artifact:** `Related Code Map` (files + why each matters).

### 4) Implementation plan (main)

- Minimal ordered steps and checkpoints; map steps to acceptance criteria.
- Test strategy before coding (unit/integration/manual as the repo expects).

**Artifact:** `Implementation Plan`.

### 5) Tester phase (Jest only)

**Purpose:** define or update **Jest** tests; **no production source edits**.

**How:** Dedicated pass (e.g. Task `requirement-unit-tests`) scoped to test files only.

**Handoff block:**

```markdown
### Tester handoff
- Tests added/updated: …
- Behaviors covered: …
- Gaps / not covered yet: …
```

Skip this phase only when the user explicitly wants implementation-first or the change is non-code.

### 6) Implement phase (minimal patch)

**Purpose:** smallest complete change that satisfies requirements.

**How:** Prefer **main agent** or one focused Task (`generalPurpose`) with a tight brief: match existing patterns, avoid unrelated edits, prefer **hook extraction** only when it clearly reduces complexity.

**Rules:** Preserve architecture unless the requirement demands otherwise; concise comments only for non-obvious logic.

### 7) Reviewer phase (readonly)

**Purpose:** regressions, business rules, missing edge cases.

**How:** Readonly review (e.g. Task `bug-detect` or second readonly pass). **No edits** in this phase—only findings.

**Handoff block:**

```markdown
### Reviewer handoff
- Regression risks: …
- Business rule gaps: …
- Missing edge cases: …
- Recommended fixes (by priority): …
```

### 8) Main: integrate and finalize

- Merge into **one coherent minimal diff**; address reviewer must-fix items.
- Keep traceability: requirement item → code → tests.

### 9) Validate

- **Do not** run build, test, lint, or long jobs **by default** unless the user explicitly asks.
- Provide a **manual verification checklist** and **recommended commands** for the user.
- If commands were run, record exact commands and outcomes.

**Artifact:** `Validation Results` (per command or `Not run (user will execute)`).

### 10) Delivery summary

**Artifact:** `Delivery Notes` (PR/Jira-ready).

## Response template

Use this section order for requirement-delivery tasks:

1. `Requirements Checklist`
2. `Impact Analysis` (refined after explorer if needed)
3. `Related Code Map`
4. `Implementation Plan`
5. `Phase handoffs` (explorer, tester, reviewer) — omit only for trivial tasks
6. `Code Changes` (files + rationale)
7. `Validation Results`
8. `Test Notes`
9. `Open Risks / Follow-ups`

## Quality rules

- Traceability: requirement → change → validation evidence.
- Do not invent owners; use `Owner: Unknown` when unclear.
- Prefer concrete paths and explicit commands over vague summaries.
- Call out blockers early with the **smallest decision** needed to proceed.
- Subagents **must** respect phase boundaries: explorer/reviewer **readonly**; tester **tests only**.
