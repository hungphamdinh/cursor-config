# cursor-config

Personal Cursor configuration source of truth.

## Tracked settings

- `agents/` for reusable global subagents
- `skills/` for personal reusable skills
- `user/settings.json` for Cursor editor preferences
- `user/keybindings.json` for custom keybindings
- `scripts/sync-from-live.sh` to refresh repo contents from the live local Cursor setup
- `.gitignore` as an allowlist for intentional config only

## Intentionally not tracked

- `projects/`, transcripts, terminals, MCP runtime output
- extension install payloads
- IDE state databases and caches
- local sync/runtime files such as `syncLocalSettings.json`
- machine-specific generated metadata unless explicitly promoted into config

## Notes

- Live Cursor user settings are sourced from `~/Library/Application Support/Cursor/User/`.
- Global agents live under `agents/` in this repo and under `~/.cursor/agents` at runtime.

## Sync

Run this from the repo root to refresh tracked settings from the live machine:

```bash
./scripts/sync-from-live.sh
```

This syncs:

- `~/.cursor/agents` -> `agents/`
- `~/.cursor/skills` -> `skills/`
- `~/Library/Application Support/Cursor/User/settings.json` -> `user/settings.json`
- `~/Library/Application Support/Cursor/User/keybindings.json` -> `user/keybindings.json`

It intentionally skips runtime-heavy state such as `projects/`, terminals, transcripts, and extension payloads.
