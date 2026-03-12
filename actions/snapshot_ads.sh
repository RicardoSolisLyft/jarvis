#!/usr/bin/env bash
# Snapshot ads: run snapshot tests in ads/plugins, extract outputs, reveal in Finder.
# Usage: ./snapshot_ads.sh

set -e

INFO_PREFIX=$'\033[33mInfo:\033[0m '
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTANT_ANDROID="${INSTANT_ANDROID:-/Users/ricardosolis/GitHub/Code/instant-android}"
OUTPUTS_ZIP="${INSTANT_ANDROID}/bazel-testlogs/instant-features/rider/active-ride/display-components/panel/ads/plugins/test/test.outputs/outputs.zip"
EXTRACT_DIR="${TMPDIR:-/tmp}/snapshot_ads_outputs"

if [[ ! -d "$INSTANT_ANDROID" ]]; then
  echo "${INFO_PREFIX}Error: instant-android not found at $INSTANT_ANDROID" >&2
  exit 1
fi

echo "${INFO_PREFIX}Running snapshot tests in ads/plugins..."
(cd "$INSTANT_ANDROID" && bazel test //instant-features/rider/active-ride/display-components/panel/ads/plugins:test) || true

if [[ ! -f "$OUTPUTS_ZIP" ]]; then
  echo "${INFO_PREFIX}Error: outputs.zip not found at $OUTPUTS_ZIP" >&2
  exit 1
fi

echo "${INFO_PREFIX}Extracting outputs..."
rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"
unzip -q -o "$OUTPUTS_ZIP" -d "$EXTRACT_DIR"

echo "${INFO_PREFIX}Opening in Finder..."
open "${EXTRACT_DIR}/SnapshotTests"

echo ""
echo "${INFO_PREFIX}Press Enter to finish, or 'd' to delete outputs."
read -r cmd

if [[ "$cmd" == "d" || "$cmd" == "D" ]]; then
  rm -rf "$EXTRACT_DIR"
fi
