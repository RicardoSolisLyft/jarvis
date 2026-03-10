#!/usr/bin/env bash
# End-of-day: run wrap-up.sh, then prompt to type "ok, Im leaving" to close the window.
# Schedule: use actions/com.jarvis.end-of-day.plist with launchd for weekdays at 4 PM.
#   Install: cp actions/com.jarvis.end-of-day.plist ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/com.jarvis.end-of-day.plist
#   Uninstall: launchctl unload ~/Library/LaunchAgents/com.jarvis.end-of-day.plist

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JARVIS_ROOT="${JARVIS_ROOT:-$(git -C "$SCRIPT_DIR/.." rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR/..")}"
JARVIS_ROOT="$(cd "$JARVIS_ROOT" && pwd)"

cd "$JARVIS_ROOT"
./actions/wrap-up.sh || true

osascript -e 'tell application "Terminal" to activate'
echo ""
echo "The day is over. Type 'ok, Im leaving' to close this window."
echo ""

while true; do
  read -r line
  line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  if [[ "$line" == "ok, Im leaving" ]]; then
    osascript -e 'tell application "Terminal" to close front window'
    exit 0
  fi
  echo "nuh uh, try again"
done
