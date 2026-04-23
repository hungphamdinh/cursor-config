---
name: release-merge-flow
description: Merge multiple ticket branches into the current release/pre-deploy branch by ticket IDs. Finds matching branches by ID, merges one-by-one, and stops immediately on conflicts for manual resolution.
---

# Release Merge Flow

Use this skill when the user asks to merge multiple tickets into the **current branch** (typically pre-release/prod release branch).

## Goal

Given a list of ticket IDs (e.g. `P3-56920`, `P3-55300`):

1. Find matching git branches for each ticket ID.
2. Merge each matched branch into the current branch, one-by-one.
3. If any merge conflict occurs, **stop immediately** and wait for user to resolve.
4. Do **not** auto-resolve conflicts.

## Required Behavior

- Always merge into `HEAD` current branch (never change merge target unless user asks).
- Never use destructive commands (`reset --hard`, force checkout cleanup, etc.).
- Never auto-resolve conflicts.
- Default to **origin-only merges**: merge only branches that exist under `origin/...`.
- If a ticket has only local matches and no `origin/...` match, report it as skipped (local-only).
- If multiple remote candidates match one ticket ID, ask user to choose.
- If no branch matches a ticket ID, report it clearly and continue with others unless user says stop.

## Branch Discovery

For each ticket ID:

1. Refresh refs first:
   - `git fetch --all --prune`
2. Search local + remote branches containing that ticket ID (case-insensitive):
   - `git branch -a | rg -i "<TICKET_ID>"`
3. Normalize candidate names and keep remote `origin/...` candidates as merge-eligible by default.
4. Mark local-only candidates as non-eligible unless user explicitly asks to include local branches.

### Candidate Selection Priority

When exactly one remote candidate exists, use it directly.

When multiple remote candidates exist, prefer in this order:

1. `origin/features/...<ID>...`
2. `origin/feature/...<ID>...`
3. `origin/bugfix/...<ID>...`
4. other `origin/...` branches

If still ambiguous, ask user which exact remote branch to merge.

## Merge Execution

For each selected branch:

1. Ensure clean working tree before merge:
   - `git status --porcelain`
   - If dirty, stop and ask user how to proceed.
2. Merge with a normal merge commit strategy (no squash/rebase unless requested):
   - `git merge --no-ff <branch>`
3. On success:
   - record merged branch + merge commit SHA.
4. On conflict:
   - stop immediately
   - report conflicted files (`git status --short`)
   - wait for user to resolve and continue.

## Reporting Format

After processing:

- Current target branch
- Ticket IDs requested
- Merged successfully (ticket ID -> branch)
- Missing branch matches
- Local-only skipped tickets
- Conflicts encountered (if any)
- Next action expected from user

## Guardrails

- Do not push unless user explicitly asks.
- Do not amend existing commits unless user explicitly asks.
- Keep merge log concise and factual.
