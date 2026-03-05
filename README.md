# Jarvis

> A personal productivity hub: shell actions for PR reviews, wrap-up commits, todo reminders, snapshot tests, and end-of-day routines. Schedule with launchd or run on demand.

---

## Actions

Scripts in `actions/` you can run directly or via launchd plists:


| Action                 | Description                                                                                                                                                              |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `clear-bazel-cache.sh` | Clears Bazel cache (including `~/.cache/bazel`, `~/.bazel_cache`, `~/Library/Caches/Bazel`), quits Android Studio if running, and runs `bazel clean` in instant-android. |
| `end-of-day.sh`        | Runs wrap-up to commit changes, then prompts you to type *"ok, Im leaving"* to close the Terminal window. Meant for launchd at 6 PM on weekdays.                         |
| `pr-review.sh`         | Checks out the given branch in a repo, generates a diff against the base branch, and writes `full-changes.md` under `reviews/<repo>/<branch>/`.                          |
| `show-todo.sh`         | Opens `todo/index.md` in your default markdown viewer. Meant for launchd at 10 AM on weekdays.                                                                           |
| `snapshot_ads.sh`      | Runs snapshot tests in `instant-android` ads/plugins, extracts outputs from the test zip, and reveals the results in Finder.                                             |
| `wrap-up.sh`           | Commits all staged changes with an optional message (or an auto-generated summary), and removes review folders older than 2 days.                                        |


---

## Cursor Commands

Custom commands in `.cursor/commands/` to use with the Cursor AI:


| Command      | Description                                                                                                                                                                                                                              |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/pr-review` | Runs a full PR review workflow: invokes `pr-review.sh`, reads the diff, then generates `relevant.md` (high-signal overview) and `issues.md` (P0/P1/P2 issues) in the review directory. Usage: `/pr-review <repo> <branch> [base-branch]` |
| `/wrap-up`   | Executes `wrap-up.sh` to commit changes and prune stale reviews.                                                                                                                                                                         |


