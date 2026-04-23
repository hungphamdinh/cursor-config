---
name: bugfix-workflow
description: Conservative bug-fixing workflow for React Native and web parity tasks. Use when user requests bug fixes, regressions, behavior mismatches, or debugging. Enforces root-cause-first analysis, minimal scoped patching, targeted validation, parity checks, and safe git behavior (no commit/push unless explicitly requested).
---

# Bugfix Workflow (Conservative)

Apply this workflow for bug-fix requests in product codebases, especially React Native + web parity cases.

## Delegation rule

When the active repository defines repo-local subagents under `.cursor/agents/`, use `task-router` first for non-trivial bugfixes. Follow its routing plan and keep delegation narrow.

Typical downstream agents in this repo family:

- `minimal-fix-planner` for root-cause framing and smallest-safe-fix planning.
- `requirement-unit-tests` for TDD-first Jest coverage before production edits.
- `bug-detect` for post-implementation regression review.
- `test-gap-review` when coverage quality is still uncertain after implementation.
- Specialist reviewers such as `navigation-impact-review`, `context-state-audit`, `service-contract-check`, and `offline-db-safety` only when the bug touches those layers.

## Intent

Deliver correct fixes with minimal risk:
- Review first.
- Implement smallest viable patch in allowed scope.
- Validate with targeted checks.
- Report risks clearly.
- Never commit or push unless user explicitly asks.

## Input Contract

Expected user inputs:
- Bug symptom or failure behavior.
- Target module/screen/feature (or enough clues to discover it).
- Any scope constraints (if provided).

If a key input is missing, discover it from the repo first; ask user only when not discoverable.

## Output Contract

Always produce output in this order:
1. Root cause statement first (or clear hypothesis + validation evidence).
2. Minimal patch summary (what changed and why).
3. Validation performed with command names and pass/fail status.
4. Risk/rollback notes for medium/high-risk changes.

Use absolute file references when citing changed code.

## Workflow

### Phase 1: Reproduce and isolate root cause
- Inspect relevant code paths before editing.
- Reproduce from available evidence (logs, conditions, tests, data mappings).
- State the concrete root cause before patching.
- If root cause is uncertain, state top hypothesis and validation plan before editing.

If repo subagents exist and the bug is non-trivial, start with `task-router`, then prefer `minimal-fix-planner` before patching.

### Phase 2: Patch with minimal scope
- Change only files required for the fix.
- Preserve existing architecture and public behavior unless the bug requires a contract change.
- Avoid opportunistic refactors.
- Keep fallback logic explicit and safe.

### Phase 3: Validate incrementally
- Run targeted checks first:
  - Changed-unit tests.
  - Screen/module-specific tests.
  - Focused lint/type checks on touched paths.
- Escalate to broader checks only if risk/coupling requires it.
- Never claim validation passed unless commands actually ran.

### Phase 4: Summarize and hand off
- Provide:
  - Root cause.
  - Behavior change.
  - Files changed.
  - Validation results.
  - Residual risks.
- Keep summary concise and factual.

## Guardrails

### Repository safety
- Stop and report if unrelated tracked changes are detected in the workspace before committing.
- Do not revert unrelated changes.
- Do not perform destructive git actions unless explicitly requested.

### Data integrity
- Do not add broad fallback behavior that can mask bad/missing data unless explicitly required.
- Prefer server/source-of-truth mapping for detail screens.

### Web/mobile parity
- For shared features, compare behavior across web and mobile before finalizing fix.
- Explicitly call out parity differences and whether they are intentional.

### Git behavior
- Do not commit unless user explicitly requests commit.
- Do not push unless user explicitly requests push.
- If requested, stage only relevant files and exclude unrelated/untracked noise.

## Decision Defaults

- Conservative mode by default.
- No auto-refactor.
- No schema/API redesign unless requested.
- No auto-commit/push.

## Trigger Examples

Use this skill for prompts like:
- "Fix this regression in SOR detail"
- "Review this bug only, no edits"
- "Mobile and web behavior mismatch"
- "Why does this status not refresh after sync?"

## Validation Checklist

Before finishing a task, ensure:
- Root cause was stated before fix details.
- Patch is scoped and minimal.
- Validation commands are listed with outcomes.
- Commit/push was done only if explicitly requested.
