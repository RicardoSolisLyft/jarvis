#!/usr/bin/env bash
# Clears all Bazel cache files and directories.
# Usage: ./clear-bazel-cache.sh

set -e

INFO_PREFIX=$'\033[33mInfo:\033[0m '
CLEANED=0

remove_if_exists() {
  if [[ -e "$1" ]]; then
    echo "${INFO_PREFIX}Removing: $1"
    rm -rf "$1"
    CLEANED=1
  fi
}

echo "${INFO_PREFIX}Clearing Bazel caches..."

# Close Android Studio first (macOS)
if pgrep -x "studio" > /dev/null 2>&1; then
  echo "${INFO_PREFIX}Quitting Android Studio..."
  osascript -e 'quit app "Android Studio"' 2>/dev/null || true
  echo "${INFO_PREFIX}Waiting for Android Studio to close..."
  sleep 3
else
  echo "${INFO_PREFIX}Android Studio is not running."
fi

# User-specified cache directory
remove_if_exists "$HOME/.bazel_cache"

# Default Bazel cache (output user root)
remove_if_exists "$HOME/.cache/bazel"

# macOS: Bazel may also use Library Caches
remove_if_exists "$HOME/Library/Caches/Bazel"

if [[ $CLEANED -eq 0 ]]; then
  echo "${INFO_PREFIX}No Bazel cache directories found."
else
  echo "${INFO_PREFIX}Bazel cache cleared."
fi

# Run bazel clean in the instant-android project (blocks until finished; may take several minutes)
INSTANT_ANDROID="/Users/ricardosolis/GitHub/Code/instant-android"
ADS_MODULE="/instant-features/rider/active-ride/display-components/panel/ads/plugins"
if [[ -d "$INSTANT_ANDROID" ]]; then
  echo "${INFO_PREFIX}Running 'bazel clean' in $INSTANT_ANDROID... (this may take several minutes)"
  (cd "$INSTANT_ANDROID" && bazel clean)
  # Build the ads/plugin module only if the cache was actually cleared
  echo "${INFO_PREFIX}Building ads/plugin module..."
  (cd "$INSTANT_ANDROID$ADS_MODULE" && bazel build)
  echo "${INFO_PREFIX}Build complete."
else
  echo "${INFO_PREFIX}Skipping bazel clean: $INSTANT_ANDROID not found."
fi
