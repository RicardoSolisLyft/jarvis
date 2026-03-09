---
name: wrap-up
description: Runs wrap-up routine to commit changes and prune stale reviews. Use when the user asks for wrap-up, wants to commit and push changes, or mentions ending the day / cleaning up.
---

# Wrap-up

Executes the wrap-up routine: commits staged changes, removes stale review folders, and pushes to remote.

## What it does

1. **Prunes reviews:** Removes branch folders under `reviews/` where files are older than 2 days.
2. **Commits:** If there are uncommitted changes, stages all and commits with an optional message or auto-generated summary (e.g. "Add foo; Update bar; Remove baz").
3. **Pushes:** Pushes to remote.

## How to run

From the Jarvis project root:

```bash
./actions/wrap-up.sh
```

With an explicit message:

```bash
./actions/wrap-up.sh "Fix typo in README"
```

## Notes

- If there are no changes, prints "No changes to commit." and still pushes.
- Auto-generated messages are built from `git status --porcelain` (additions, modifications, deletions).
