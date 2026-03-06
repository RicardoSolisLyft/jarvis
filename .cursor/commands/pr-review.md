# PR Review (/pr-review)

Run a PR review for a repository and branch. The user provides the **repository** and **branch** in the message after the command (e.g. `/pr-review my-app feature/login` or `/pr-review ~/GitHub/Code/my-app feature/login develop`). Optional flags: **deploy-test** (deploy rider app after review) and **-t \<device_id\>** (target device when deploy-test has multiple devices).

## Steps

1. **Parse input**
   - From the user's message after `/pr-review`, extract:
     - **Repository:** first token (repo name under `~/GitHub/Code/` or a path).
     - **Branch:** second token (branch to review).
     - **Base branch (optional):** third token; if present, use it for the diff base (default is `main`).
     - **Optional flags:**
       - **deploy-test:** if present, deploy the rider app to the active device (see step 6).
       - **-t \<device_id\>:** used with deploy-test when multiple devices; target device from `adb devices`.
   - If repository or branch is missing, ask the user to provide them.

2. **Run the script**
   - From the Jarvis project root, run: `./actions/pr-review.sh <repo> <branch> [base-branch]`.
   - If the script fails (e.g. repo not found, dirty working tree, branch missing), report the error and stop.

3. **Read the diff**
   - The script prints lines `REVIEW_DIR=...` and `FULL_CHANGES=...`. Use those paths.
   - Read the contents of `full-changes.md` from the path given in `FULL_CHANGES`.

4. **Generate review files**
   - In the **same** directory as `full-changes.md` (i.e. `REVIEW_DIR`), create two files:
     - **relevant.md:** A concise summary of the most relevant or important changes (high-signal overview for reviewers). Focus on behavior, architecture, and risk, not every line.
     - **issues.md:** Issues found in the diff, grouped by severity:
       - **P0 (Critical):** Blocking issues, security or correctness bugs.
       - **P1 (High):** Important bugs, maintainability or design concerns.
       - **P2 (Low):** Style, nitpicks, minor improvements.
   - Write both files to the review directory.

5. **Confirm**
   - Tell the user the review is done and give the paths to `relevant.md` and `issues.md`.

6. **Deploy-test (optional)**
   - If the user included **deploy-test**, deploy the rider app to an Android device.
   - Run `adb devices` to list connected devices.
   - If exactly one device (excluding "List of devices attached" header): deploy to it.
   - If multiple devices: display the list to the user and ask them to re-run with `-t <device_id>` (e.g. `-t emulator-5554`) to deploy. Do not deploy automatically.
   - Deploy from `instant-android` (default: `~/GitHub/Code/instant-android` or `INSTANT_ANDROID`): use `bazel run` or the project's standard install target for the rider app (e.g. `bazel run //instant-features/rider:app` or equivalent). Use `adb -s <device_id>` when a target device is specified via `-t`.

## Notes

- The target repo should have a **clean working tree** before running; otherwise the script aborts. The user can stash or commit first.
- Repo can be a short name (e.g. `my-app` → `~/GitHub/Code/my-app`) or a full path.
