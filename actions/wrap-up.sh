#!/usr/bin/env bash
# Commit all changes with an optional message.
# Usage: wrap-up [message]
#   If message is omitted, generates a short summary from the changes.

set -e

INFO_PREFIX=$'\033[33mJarvis-INFO:\033[0m '
cd "$(git rev-parse --show-toplevel)"

# Remove branch folders under reviews/ where any file was last modified 2+ days ago
REVIEWS_DIR="reviews"
if [[ -d "$REVIEWS_DIR" ]]; then
  while IFS= read -r dir; do
    # Guard: never remove reviews/ itself, only subdirs (branch folders)
    [[ "$dir" != "$REVIEWS_DIR" && "$dir" == "$REVIEWS_DIR"/* ]] || continue
    rm -rf "$dir"
    echo "${INFO_PREFIX}Removed stale review: $dir"
  done < <(find "$REVIEWS_DIR" -type f -mtime +1 -exec dirname {} \; | sort -u)
fi

# Remove note files older than 10 days (keep index.md)
NOTES_DIR="notes"
if [[ -d "$NOTES_DIR" ]]; then
  while IFS= read -r f; do
    rm -f "$f"
    echo "${INFO_PREFIX}Removed stale note: $f"
  done < <(find "$NOTES_DIR" -type f -mtime +10 ! -name 'index.md')
fi

if [[ -n "$(git status --porcelain)" ]]; then
  if [[ -n "$1" ]]; then
    MSG="$*"
  else
    ADDED=()
    MODIFIED=()
    DELETED=()
    while IFS= read -r line; do
      status="${line:0:2}"
      path="${line:3}"
      name=$(basename "$path" | sed 's/\.[^.]*$//' | tr ' ' '-')
      case "$status" in
        \?\?|A ) ADDED+=("$name") ;;
        M | M?| M) MODIFIED+=("$name") ;;
        D | D?| D) DELETED+=("$name") ;;
        *) MODIFIED+=("$name") ;;
      esac
    done < <(git status --porcelain)
    PARTS=()
    [[ ${#ADDED[@]} -gt 0 ]] && PARTS+=("Add ${ADDED[*]}")
    [[ ${#MODIFIED[@]} -gt 0 ]] && PARTS+=("Update ${MODIFIED[*]}")
    [[ ${#DELETED[@]} -gt 0 ]] && PARTS+=("Remove ${DELETED[*]}")
    MSG=$(IFS='; '; echo "${PARTS[*]}")
    [[ -z "$MSG" ]] && MSG="Update repo"
  fi
  git add -A
  git commit -m "$MSG"
  echo "${INFO_PREFIX}Committed: $MSG"
else
  echo "${INFO_PREFIX}No changes to commit."
fi

git push
echo "${INFO_PREFIX}Pushed to remote."
