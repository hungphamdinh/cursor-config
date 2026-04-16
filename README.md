# cursor-config

Personal Cursor configuration source of truth.

## Tracked settings

- `agents/` for reusable global subagents
- `skills/` for personal reusable skills
- `user/settings.json` for Cursor editor preferences
- `user/keybindings.json` for custom keybindings
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
