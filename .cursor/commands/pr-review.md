# PR Review (/pr-review)

Run a PR review for a repository and branch. The user provides the **repository** and **branch** in the message after the command (e.g. `/pr-review my-app feature/login` or `/pr-review ~/GitHub/Code/my-app feature/login develop`).

## Steps

1. **Parse input**
   - From the user's message after `/pr-review`, extract:
     - **Repository:** first token (repo name under `~/GitHub/Code/` or a path).
     - **Branch:** second token (branch to review).
     - **Base branch (optional):** third token; if present, use it for the diff base (default is `main`).
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

## Notes

- The target repo should have a **clean working tree** before running; otherwise the script aborts. The user can stash or commit first.
- Repo can be a short name (e.g. `my-app` → `~/GitHub/Code/my-app`) or a full path.
