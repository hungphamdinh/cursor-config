---
name: config-repo-sync
description: Sync live Cursor and Codex configuration into the tracked config repos, then commit and push only the intended config files. Use when the user wants to update cursor-config, codex-config, or both from the current machine without manually running sync scripts.
---

# Config Repo Sync

Use this skill when the user wants Cursor/Codex config changes migrated into the Git-backed config repos and pushed safely.

## Scope

Supported repos:

- `~/Desktop/AI_Agents/cursor-config`
- `~/Desktop/AI_Agents/codex-config`

## Intent

- Pull the latest tracked config from the live machine into the config repo.
- Stage only the intended config files.
- Commit with a focused message.
- Push to the repo remote.
- Avoid staging runtime noise, transcripts, caches, extension payloads, or project state.

## Workflow

### 1. Determine target

Infer whether the user wants:

- `cursor-config`
- `codex-config`
- both repos

If unclear, ask a short clarifying question.

### 2. Run the repo sync helper

For `cursor-config`:

```bash
~/Desktop/AI_Agents/cursor-config/scripts/sync-from-live.sh
```

For `codex-config`:

```bash
~/Desktop/AI_Agents/codex-config/scripts/sync-from-live.sh
```

### 3. Review status narrowly

Check `git status --short` for only the intended config paths.

Allowed `cursor-config` paths:

- `.gitignore`
- `README.md`
- `agents/`
- `skills/`
- `user/`
- `argv.json`
- `mcp.json`
- `scripts/`

Allowed `codex-config` paths:

- `AGENTS.md`
- `config.toml`
- `version.json`
- `skills/`
- `automations/`
- `.cursor/agents/`
- `README.md`
- `scripts/`

If unrelated tracked changes appear outside the allowed paths, stop and report them instead of sweeping them into the commit.

### 4. Stage only intentional files

Use path-limited `git add` commands.

Do not stage:

- `projects/`
- transcripts
- terminals
- extension payloads
- caches
- IDE state databases
- logs

### 5. Commit and push

If there are no relevant changes, report that nothing changed and stop.

Commit message defaults:

- `chore(cursor): sync live config`
- `chore(codex): sync live config`
- `chore(config): sync live config`

Then push to the current default branch.

## Response contract

Always report:

1. Which repo(s) were synced
2. Which paths changed
3. Commit SHA(s)
4. Push result
5. Any skipped or suspicious files

## Guardrails

- Do not commit unrelated dirty files.
- Do not rewrite the repo structure unless the user asked for it.
- Prefer the repo sync scripts over ad hoc copy commands.
- If a repo helper script is missing or stale, patch that first, then continue.
