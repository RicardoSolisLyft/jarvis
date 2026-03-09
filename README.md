# Jarvis

> A personal productivity hub: shell actions for PR reviews, wrap-up commits, todo reminders, snapshot tests, and end-of-day routines. Schedule with launchd or run on demand.

---

## Quick Start

- **Run an action:** `./actions/<script>.sh` from the Jarvis root (e.g. `./actions/show-todo.sh`)
- **CLI from anywhere:** Add Jarvis root to PATH, then run `jarvis agent "your prompt"` (see [Jarvis CLI](#jarvis-cli) below)
- **Schedule with launchd:** Copy a plist from `actions/` into `~/Library/LaunchAgents/`, then `launchctl load` it. Update paths in the plist if the repo moves.

---

## Actions

Scripts in `actions/` you can run directly or via launchd plists:


| Action                 | Description                                                                                                                                                              |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `agent.sh`             | Runs Cursor CLI agent with a prompt. Requires Cursor CLI (`curl https://cursor.com/install -fsS \| bash`). Usage: `agent.sh "prompt"` or `jarvis agent "prompt"`.         |
| `clear-bazel-cache.sh` | Clears Bazel cache (including `~/.cache/bazel`, `~/.bazel_cache`, `~/Library/Caches/Bazel`), quits Android Studio if running, and runs `bazel clean` in instant-android. |
| `end-of-day.sh`        | Runs wrap-up to commit changes, then prompts you to type *"ok, Im leaving"* to close the Terminal window. Meant for launchd at 6 PM on weekdays.                         |
| `pr-review.sh`         | Checks out the given branch in a repo, generates a diff against the base branch, and writes `full-changes.md` under `reviews/<repo>/<branch>/`.                          |
| `show-todo.sh`         | Opens `todo/index.md` in your default markdown viewer. Meant for launchd at 10 AM on weekdays.                                                                           |
| `snapshot_ads.sh`      | Runs snapshot tests in `instant-android` ads/plugins, extracts outputs from the test zip, and reveals the results in Finder.                                             |
| `wrap-up.sh`           | Commits all staged changes with an optional message (or an auto-generated summary), and removes review folders older than 2 days.                                        |


---

## Jarvis CLI

Add the Jarvis root to your PATH to run `jarvis` from anywhere:

```bash
# In ~/.zshrc or ~/.bashrc
export PATH="$HOME/GitHub/Jarvis:$PATH"
```

Then:

```bash
jarvis agent "refactor the auth module to use JWT"
jarvis agent --plan "add authentication"  # plan first, then execute
```

---

## Cursor Skills

Project skills in `.cursor/skills/` teach the agent how to run Jarvis workflows. They apply when you ask for a PR review, wrap-up, or similar tasks.


| Skill       | Description                                                                                                                                                                                                                                                                                                                                        |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `pr-review` | Runs a full PR review workflow: invokes `pr-review.sh`, reads the diff, then generates `relevant.md` (high-signal overview) and `issues.md` (P0/P1/P2 issues) in the review directory. Optional flags: **deploy-test** (deploy rider app to device; use `-t <device_id>` when multiple devices). Usage: `<repo> <branch> [base-branch]` `[deploy-test]` `[-t <device_id>]` |
| `wrap-up`   | Executes `wrap-up.sh` to commit changes and prune stale reviews.                                                                                                                                                                                                                                                                                   |


---

## Scheduled Jobs (launchd)


| Plist                         | Schedule       | Action                                        |
| ----------------------------- | -------------- | --------------------------------------------- |
| `com.jarvis.show-todo.plist`  | Weekdays 10 AM | Opens `todo/index.md` in your markdown viewer |
| `com.jarvis.end-of-day.plist` | Weekdays 6 PM  | Runs wrap-up, then prompts to close Terminal  |


Install: `cp actions/<plist> ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/<plist>`  
Uninstall: `launchctl unload ~/Library/LaunchAgents/<plist>`

---

## Project Structure

- `**todo/`** — Task list; `show-todo.sh` opens `todo/index.md`.
- `**notes/**` — Meeting notes and reference material.
- `**reviews/**` — PR review output (`full-changes.md`, `relevant.md`, `issues.md`) per repo and branch.

