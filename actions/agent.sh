#!/usr/bin/env bash
# Run Cursor CLI agent with a prompt. Requires Cursor CLI installed: curl https://cursor.com/install -fsS | bash
# Usage: agent.sh "your prompt here" [--mode ask|plan] [-c] ...
#   Runs agent in print mode by default (output to console, non-interactive).
#   Passes all arguments to the Cursor agent command, with -p prepended.
#   Examples:
#     agent.sh "refactor the auth module"
#     agent.sh --plan "add JWT auth"  # plan first, then execute

set -e

if ! command -v agent &>/dev/null; then
  echo "Cursor CLI not found. Install with: curl https://cursor.com/install -fsS | bash" >&2
  exit 1
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

agent -p "$@" > "$tmp" 2>&1 &
pid=$!
trap 'kill "$pid" 2>/dev/null; rm -f "$tmp"; exit 130' INT

exit_code=0
i=0

while kill -0 "$pid" 2>/dev/null; do
  if [[ -s "$tmp" ]]; then
    printf '\r%-20s\r' ''
    tail -f "$tmp" 2>/dev/null &
    tail_pid=$!
    wait "$pid" 2>/dev/null
    kill "$tail_pid" 2>/dev/null
    exit_code=$?
    exit "$exit_code"
  fi
  dots=$(printf '.%.0s' $(seq 1 $(( (i % 3) + 1)) 2>/dev/null) || echo ".")
  printf '\rThinking%s   ' "$dots"
  i=$((i + 1))
  sleep 0.3
done

printf '\r%-20s\r' ''
cat "$tmp"
wait "$pid" 2>/dev/null
exit_code=$?
exit "$exit_code"
