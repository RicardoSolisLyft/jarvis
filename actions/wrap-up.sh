#!/usr/bin/env bash
# Commit all changes with an optional message.
# Usage: wrap-up [message]
#   If message is omitted, generates a short summary from the changes.

set -e

cd "$(git rev-parse --show-toplevel)"

# Remove branch folders under reviews/ where any file was last modified 10+ days ago
REVIEWS_DIR="reviews"
if [[ -d "$REVIEWS_DIR" ]]; then
  while IFS= read -r dir; do
    # Guard: never remove reviews/ itself, only subdirs (branch folders)
    [[ "$dir" != "$REVIEWS_DIR" && "$dir" == "$REVIEWS_DIR"/* ]] || continue
    rm -rf "$dir"
    echo "Removed stale review: $dir"
  done < <(find "$REVIEWS_DIR" -type f -mtime +9 -exec dirname {} \; | sort -u)
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
  echo "Committed: $MSG"
else
  echo "No changes to commit."
  exit 0
fi
