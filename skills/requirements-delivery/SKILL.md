---
name: requirements-delivery
description: >-
  End-to-end delivery from BA/user requirements through multi-phase work: readonly
  exploration, Jest-only test updates, minimal implementation, and regression review.
  Use for React Native and business-logic-heavy changes, new features, change requests,
  bugfix specs, or when the user asks for requirements delivery, phased workflow, or
  explorer/tester/reviewer passes. Orchestrates focused passes (explore, tests, review)
  plus a single minimal final patch.
---

# Requirements Delivery (multi-phase)

Use this workflow when a request includes new requirements, CRs, acceptance criteria, non-trivial bugfixes, or cross-cutting RN/state/API work.

**Trivial tasks** (single obvious file, typo, one-liner): skip phased passes; implement directly and still follow project rules.

## Delegation rule

When the active repository defines repo-local subagents under `.cursor/agents/`, use `task-router` first for complex or cross-cutting tasks. Follow its routing plan and prefer the minimum useful set of downstream passes.

Typical downstream agents in this repo family:

- `acceptance-criteria-writer` when the request is still vague.
- `requirements-workflow` for readonly requirements and impact exploration.
- `requirement-unit-tests` for Jest-first test authoring.
- `bug-detect` for post-implementation regression review.
- Specialist reviewers such as `navigation-impact-review`, `context-state-audit`, `service-contract-check`, and `offline-db-safety` only when the touched area justifies them.

## Gate 0 — Project rules

1. Read **`AGENTS.md`** and **`.cursor/rules`** if present; treat them as binding unless the user overrides.
2. Restate the goal in one paragraph and split into **3–4 subtasks** when the work is non-trivial.

## Required inputs

Collect from the prompt or repo context:

- Requirement text (scope, expected behavior, out-of-scope)
- Targets (e.g. iOS/Android, screens affected)
- Acceptance criteria and risk notes
- Constraints (API contracts, backward compatibility, flags)

If a critical detail is missing and risky to assume, state the **assumption** before implementation.

## Phased delivery

Run phases **in order**. After each focused pass, carry the **handoff block** forward before continuing.

### 1) Read and normalize requirements (main)

- Concise checklist of expected outcomes; separate functional, non-functional, edge cases.
- Note ambiguities; safest assumption if clarification unavailable.

If repo subagents exist and the task is complex, start with a `task-router` pass before finalizing this checklist.

**Artifact:** `Requirements Checklist` (numbered, testable).

### 2) Impact sketch (main, brief)

- Map checklist items to layers: UI, state, API, data, permissions, analytics, tests.
- Regression, migration, environment risk; flags, config, backend dependencies.

**Artifact:** `Impact Analysis` (initial).

### 3) Explorer phase (readonly)

**Purpose:** execution path, impacted files, **root cause only** (bugs); no production edits.

**How:** Readonly search and read; no patch. Prefer an isolated readonly exploration pass when the tool allows.

**Handoff block:**

```markdown
### Explorer handoff
- Execution path: …
- Impacted files: …
- Root cause / hypothesis: …
- Notes for implementer: …
```

Refine `Impact Analysis` if explorer contradicts the sketch.

**Artifact:** `Related Code Map` (files + relevance).

### 4) Implementation plan (main)

- Minimal ordered steps with checkpoints; acceptance mapping per step.
- Test strategy before coding.

**Artifact:** `Implementation Plan`.

### 5) Tester phase (Jest only)

**Purpose:** define/update **Jest** tests; **no production source edits**.

**Handoff block:**

```markdown
### Tester handoff
- Tests added/updated: …
- Behaviors covered: …
- Gaps / not covered yet: …
```

Skip when the user wants implementation-first or the change is non-code.

### 6) Implement phase (minimal patch)

Smallest complete change; match existing style; avoid unrelated edits; prefer **hook extraction** only when it clearly simplifies.

### 7) Reviewer phase (readonly)

**Purpose:** regressions, business rules, missing edge cases. **No edits**—findings only.

**Handoff block:**

```markdown
### Reviewer handoff
- Regression risks: …
- Business rule gaps: …
- Missing edge cases: …
- Recommended fixes (by priority): …
```

### 8) Main: integrate and finalize

One coherent minimal diff; address reviewer must-fix items. Trace requirement → code → tests.

### 9) Validate

- **Do not** run build, test, lint, or long jobs **by default** unless the user explicitly asks.
- Provide manual verification checklist and recommended commands.
- If commands were run, record exact commands and outcomes.

**Artifact:** `Validation Results`.

### 10) Delivery summary

**Artifact:** `Delivery Notes` (PR/Jira-ready).

## Response template

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

- Traceability: requirement item → code change → validation evidence.
- Do not assign owner without signal; use `Owner: Unknown` when unclear.
- Prefer concrete file references and explicit commands.
- Do not execute validation/build jobs unless explicitly requested by the user.
- Call out blockers immediately with the minimal decision needed to proceed.
- Phase boundaries: explorer/reviewer **readonly**; tester **tests only**.
