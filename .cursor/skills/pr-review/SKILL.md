---
name: pr-review
description: Run a PR review workflow for a repository and branch. Invokes pr-review.sh, reads the diff, generates relevant.md and issues.md. Use when the user asks for a PR review, wants to review a branch, or uses /pr-review, pr-review, or review my PR.
---

# PR Review

Run a full PR review workflow for a repository and branch. The user provides **repository** and **branch** (e.g. `pr-review my-app feature/login` or `pr-review ~/GitHub/Code/my-app feature/login develop`). Optional flags: **deploy-test** (deploy rider app after review) and **-t \<device_id\>** (target device when deploy-test has multiple devices).

## Steps

1. **Parse input**
   - Extract from the user's message:
     - **Repository:** first token (repo name under `~/GitHub/Code/` or a path).
     - **Branch:** second token (branch to review).
     - **Base branch (optional):** third token; if present, use for diff base (default `main`).
     - **Optional flags:**
       - **deploy-test:** deploy rider app to active device after review (step 6).
       - **-t \<device_id\>:** with deploy-test when multiple devices; target device from `adb devices`.
   - If repository or branch is missing, ask the user.

2. **Run the script**
   - From Jarvis project root: `./actions/pr-review.sh <repo> <branch> [base-branch]`
   - If the script fails (repo not found, dirty tree, branch missing), report the error and stop.

3. **Read the diff**
   - Script prints `REVIEW_DIR=...` and `FULL_CHANGES=...`. Use those paths.
   - Read `full-changes.md` from `FULL_CHANGES`.

4. **Generate review files**
   - In the same directory as `full-changes.md` (`REVIEW_DIR`), create:
     - **relevant.md:** Concise summary of important changes (behavior, architecture, risk). High-signal overview.
     - **issues.md:** Issues grouped by severity:
       - **P0 (Critical):** Blocking, security, correctness bugs.
       - **P1 (High):** Important bugs, maintainability, design concerns.
       - **P2 (Low):** Style, nitpicks, minor improvements.

5. **Open and focus**
   - Open the generated files in Cursor and bring focus to this window:
     - Run: `open -a "Cursor" "$REVIEW_DIR/relevant.md" "$REVIEW_DIR/issues.md"`
   - Then report completion and paths to `relevant.md` and `issues.md`.

6. **Deploy-test (optional)**
   - If user included **deploy-test**, deploy rider app to Android device.
   - Run `adb devices`.
   - If one device: deploy to it.
   - If multiple devices: list them and ask user to re-run with `-t <device_id>` (e.g. `-t emulator-5554`). Do not deploy automatically.
   - Deploy from `instant-android` (`~/GitHub/Code/instant-android` or `INSTANT_ANDROID`): use `bazel run` or project install target (e.g. `bazel run //instant-features/rider:app`). Use `adb -s <device_id>` when `-t` is specified.

## Notes

- Repo must have a **clean working tree** before running; script aborts otherwise (user can stash or commit).
- Repo can be short name (e.g. `my-app` → `~/GitHub/Code/my-app`) or full path.
