#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURSOR_HOME="${CURSOR_HOME:-$HOME/.cursor}"
CURSOR_USER_DIR="${CURSOR_USER_DIR:-$HOME/Library/Application Support/Cursor/User}"

mkdir -p \
  "$REPO_ROOT/agents" \
  "$REPO_ROOT/skills" \
  "$REPO_ROOT/user"

if [ -d "$CURSOR_HOME/agents" ]; then
  rsync -a --delete "$CURSOR_HOME/agents/" "$REPO_ROOT/agents/"
fi

if [ -d "$CURSOR_HOME/skills" ]; then
  rsync -a --delete "$CURSOR_HOME/skills/" "$REPO_ROOT/skills/"
fi

if [ -f "$CURSOR_USER_DIR/settings.json" ]; then
  cp "$CURSOR_USER_DIR/settings.json" "$REPO_ROOT/user/settings.json"
fi

if [ -f "$CURSOR_USER_DIR/keybindings.json" ]; then
  cp "$CURSOR_USER_DIR/keybindings.json" "$REPO_ROOT/user/keybindings.json"
fi

echo "Synced tracked Cursor config from live environment."
git -C "$REPO_ROOT" status --short -- agents skills user README.md .gitignore scripts
