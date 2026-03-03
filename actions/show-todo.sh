#!/usr/bin/env bash
# Show todo: read all files from todo/, generate an HTML page, open in Google Chrome.
# Usage: show-todo.sh
# Schedule: use actions/com.jarvis.show-todo.plist with launchd for weekdays at 9 AM.
#   Install: cp actions/com.jarvis.show-todo.plist ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/com.jarvis.show-todo.plist
#   Uninstall: launchctl unload ~/Library/LaunchAgents/com.jarvis.show-todo.plist

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JARVIS_ROOT="${JARVIS_ROOT:-$(git -C "$SCRIPT_DIR/.." rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR/..")}"
JARVIS_ROOT="$(cd "$JARVIS_ROOT" && pwd)"
TODO_DIR="${JARVIS_ROOT}/todo"
OUTPUT_HTML="${TODO_DIR}/generated.html"

if [[ ! -d "$TODO_DIR" ]]; then
  echo "Todo folder not found: $TODO_DIR" >&2
  exit 1
fi

# Collect content from all files under todo/, sorted by path
CONTENT=""
while IFS= read -r f; do
  [[ -f "$f" ]] && CONTENT+="$(cat "$f")
"
done < <(find "$TODO_DIR" -type f ! -name "generated.html" | sort)

# Escape for HTML: & < >
ESCAPED=$(echo "$CONTENT" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

# Generate HTML
cat << EOF > "$OUTPUT_HTML"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Todo</title>
  <style>
    body { font-family: system-ui, -apple-system, sans-serif; margin: 2rem; max-width: 48rem; line-height: 1.5; background: #fafafa; color: #111; }
    pre { white-space: pre-wrap; word-wrap: break-word; margin: 0; }
    h1 { font-size: 1.25rem; margin-bottom: 1rem; }
  </style>
</head>
<body>
  <h1>Todo</h1>
  <pre>${ESCAPED}</pre>
</body>
</html>
EOF

open -a "Google Chrome" "file://${OUTPUT_HTML}"
