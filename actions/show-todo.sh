#!/usr/bin/env bash
# Show todo: open the main markdown file in the default markdown viewer.
# Usage: show-todo.sh
# Schedule: use actions/com.jarvis.show-todo.plist with launchd for weekdays at 10 AM.
#   Install: cp actions/com.jarvis.show-todo.plist ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/com.jarvis.show-todo.plist
#   Uninstall: launchctl unload ~/Library/LaunchAgents/com.jarvis.show-todo.plist

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JARVIS_ROOT="${JARVIS_ROOT:-$(git -C "$SCRIPT_DIR/.." rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR/..")}"
JARVIS_ROOT="$(cd "$JARVIS_ROOT" && pwd)"
TODO_DIR="${JARVIS_ROOT}/todo"
TODO_MD="${TODO_DIR}/index.md"

if [[ ! -f "$TODO_MD" ]]; then
  echo "Todo file not found: $TODO_MD" >&2
  exit 1
fi

open "$TODO_MD"
