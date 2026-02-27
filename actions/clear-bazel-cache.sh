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

# Close Android Studio first (macOS)
if pgrep -x "studio" > /dev/null 2>&1; then
  echo "Quitting Android Studio..."
  osascript -e 'quit app "Android Studio"' 2>/dev/null || true
  echo "Waiting for Android Studio to close..."
  sleep 3
else
  echo "Android Studio is not running."
fi

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

# Run bazel clean in the instant-android project (blocks until finished; may take several minutes)
INSTANT_ANDROID="/Users/ricardosolis/Projects/instant-android"
if [[ -d "$INSTANT_ANDROID" ]]; then
  echo "Running 'bazel clean' in $INSTANT_ANDROID... (this may take several minutes)"
  (cd "$INSTANT_ANDROID" && bazel clean)
  echo "Done."
else
  echo "Skipping bazel clean: $INSTANT_ANDROID not found."
fi
