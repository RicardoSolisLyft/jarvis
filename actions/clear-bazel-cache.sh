#!/usr/bin/env bash
# Clears all Bazel cache files and directories.
# Usage: ./clear-bazel-cache.sh

set -e

CLEANED=0

remove_if_exists() {
  if [[ -e "$1" ]]; then
    echo "Removing: $1"
    rm -rf "$1"
    CLEANED=1
  fi
}

echo "Clearing Bazel caches..."

# User-specified cache directory
remove_if_exists "$HOME/.bazel_cache"

# Default Bazel cache (output user root)
remove_if_exists "$HOME/.cache/bazel"

# macOS: Bazel may also use Library Caches
remove_if_exists "$HOME/Library/Caches/Bazel"

if [[ $CLEANED -eq 0 ]]; then
  echo "No Bazel cache directories found."
else
  echo "Bazel cache cleared."
fi

# Run bazel clean in the instant-android project
INSTANT_ANDROID="/Users/ricardosolis/Projects/instant-android"
if [[ -d "$INSTANT_ANDROID" ]]; then
  echo "Running 'bazel clean' in $INSTANT_ANDROID..."
  (cd "$INSTANT_ANDROID" && bazel clean)
  echo "Done."
else
  echo "Skipping bazel clean: $INSTANT_ANDROID not found."
fi
