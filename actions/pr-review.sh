#!/usr/bin/env bash
# PR review: checkout branch, create review dir, write full diff to full-changes.md.
# Usage: pr-review.sh <repo> <branch> [base-branch]
#   repo: repo name (e.g. my-app) or full path; names resolve to ~/GitHub/Code/<repo>
#   branch: branch to review (will be checked out)
#   base-branch: optional; default main (diff is base...branch)
# Output: creates JARVIS_ROOT/reviews/<repo_name>/<branch>/full-changes.md and prints paths.

set -e

INFO_PREFIX=$'\033[33mJarvis-INFO:\033[0m '
if [[ $# -lt 2 ]]; then
  echo "${INFO_PREFIX}Usage: $0 <repo> <branch> [base-branch]" >&2
  echo "${INFO_PREFIX}  repo: repo name or path (names resolve to ~/GitHub/Code/<repo>)" >&2
  echo "${INFO_PREFIX}  branch: branch to review" >&2
  echo "${INFO_PREFIX}  base-branch: optional, default main" >&2
  exit 1
fi

REPO_ARG="$1"
BRANCH="$2"
BASE_BRANCH="${3:-main}"

# JARVIS_ROOT: Jarvis repo root (where reviews/ lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JARVIS_ROOT="${JARVIS_ROOT:-$(git -C "$SCRIPT_DIR/.." rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR/..")}"
JARVIS_ROOT="$(cd "$JARVIS_ROOT" && pwd)"

# Resolve repo path
if [[ -d "$REPO_ARG" ]]; then
  REPO_PATH="$(cd "$REPO_ARG" && pwd)"
else
  CODE_ROOT="${HOME}/GitHub/Code"
  REPO_PATH="${CODE_ROOT}/${REPO_ARG}"
  if [[ ! -d "$REPO_PATH" ]]; then
    echo "${INFO_PREFIX}Error: repo not found: $REPO_ARG (tried $REPO_PATH)" >&2
    exit 1
  fi
  REPO_PATH="$(cd "$REPO_PATH" && pwd)"
fi

if ! git -C "$REPO_PATH" rev-parse --git-dir >/dev/null 2>&1; then
  echo "${INFO_PREFIX}Error: not a git repository: $REPO_PATH" >&2
  exit 1
fi

if [[ -n "$(git -C "$REPO_PATH" status --porcelain)" ]]; then
  echo "${INFO_PREFIX}Error: working tree is dirty in $REPO_PATH. Stash or commit first." >&2
  exit 1
fi

REPO_NAME="$(basename "$REPO_PATH")"
BRANCH_SANITIZED="${BRANCH//\//-}"
REVIEW_DIR="${JARVIS_ROOT}/reviews/${REPO_NAME}/${BRANCH_SANITIZED}"
mkdir -p "$REVIEW_DIR"

git -C "$REPO_PATH" fetch origin 2>/dev/null || true
git -C "$REPO_PATH" checkout "$BRANCH" 2>/dev/null || { echo "${INFO_PREFIX}Error: could not checkout branch: $BRANCH" >&2; exit 1; }

HEADER="<!-- PR Review: ${REPO_NAME} | branch: ${BRANCH} | base: ${BASE_BRANCH} | $(date -u +%Y-%m-%dT%H:%M:%SZ) -->"
{
  echo "$HEADER"
  echo ""
  git -C "$REPO_PATH" diff "${BASE_BRANCH}...${BRANCH}" --
} > "${REVIEW_DIR}/full-changes.md"

echo "${INFO_PREFIX}REVIEW_DIR=${REVIEW_DIR}"
echo "${INFO_PREFIX}FULL_CHANGES=${REVIEW_DIR}/full-changes.md"
