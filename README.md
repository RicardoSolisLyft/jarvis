# Jarvis

> A personal productivity hub: shell actions for PR reviews, wrap-up commits, todo reminders, snapshot tests, and end-of-day routines. Schedule with launchd or run on demand.

---

## Quick Start

- **Run an action:** `./actions/<script>.sh` from the Jarvis root (e.g. `./actions/show-todo.sh`)
- **Schedule with launchd:** Copy a plist from `actions/` into `~/Library/LaunchAgents/`, then `launchctl load` it. Update paths in the plist if the repo moves.

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
| `/pr-review` | Runs a full PR review workflow: invokes `pr-review.sh`, reads the diff, then generates `relevant.md` (high-signal overview) and `issues.md` (P0/P1/P2 issues) in the review directory. Optional flags: **deploy-test** (deploy rider app to device; use `-t <device_id>` when multiple devices) and **snapshot-test** (run `snapshot_ads.sh`). Usage: `/pr-review <repo> <branch> [base-branch]` |
| `/wrap-up`   | Executes `wrap-up.sh` to commit changes and prune stale reviews.                                                                                                                                                                         |

---

## Scheduled Jobs (launchd)

| Plist                    | Schedule            | Action                                      |
| ------------------------ | ------------------- | ------------------------------------------- |
| `com.jarvis.show-todo.plist` | Weekdays 10 AM      | Opens `todo/index.md` in your markdown viewer |
| `com.jarvis.end-of-day.plist` | Weekdays 6 PM       | Runs wrap-up, then prompts to close Terminal |

Install: `cp actions/<plist> ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/<plist>`  
Uninstall: `launchctl unload ~/Library/LaunchAgents/<plist>`

---

## Project Structure

- **`todo/`** — Task list; `show-todo.sh` opens `todo/index.md`.
- **`notes/`** — Meeting notes and reference material.
- **`reviews/`** — PR review output (`full-changes.md`, `relevant.md`, `issues.md`) per repo and branch.

