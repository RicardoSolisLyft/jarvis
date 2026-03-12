---
name: action-items
description: >
  Add action items to ~/GitHub/Jarvis/todo/index.md. Use when the user wants to
  create todos, add tasks, capture action items, or "add these to my todo" —
  without necessarily providing meeting notes or a transcript. Can be invoked
  standalone or from other skills (e.g. meeting-notes-extractor).
---

# Action Items

This skill appends action items to `~/GitHub/Jarvis/todo/index.md`. It handles ID assignment, table formatting, placement based on whether a section name is provided, and ordering by priority.

---

## Where to add: section name rule

- **No specific name provided** → Add rows directly to the main **Todo** table (the table under `# Todo`). Insert new rows after the last row of that table, before any `##` section.
- **Specific name provided** → Add under a new `## {Name}` section at the end of the file. Use when the items belong to a specific context (e.g. meeting name and date from meeting-notes-extractor: `## {Meeting Topic — Title Case} ({YYYY-MM-DD})`).

---

## Input

You need a list of action items. Each item has:
- **Task** — a clear, actionable description
- **Due date** — `YYYY-MM-DD` format
- **Priority** — `P0`, `P1`, or `P2` (optional; P0 = highest). Leave empty if unclear.

The user may provide these in freeform (e.g. "add: review the API by Friday, P1" or a bullet list). Parse and normalize.

---

## Due date defaults (when not provided)

If the user does not specify due dates:
- The **first** undated item gets **today + 7 days**
- Each **subsequent** undated item gets **previous item's due date + 4 days**

---

## ID assignment

**Before adding:** Read `~/GitHub/Jarvis/todo/index.md` and find the highest ID used anywhere (main table and all sections). Assign IDs sequentially: maxID+1, maxID+2, …

---

## Format: main Todo table (no section name)

When adding to the main Todo table:

| ID | Task | DUE date | Priority |
|----|------|----------|----------|
| {next ID} | {Task description} | {Weekday, Month D, YYYY} | {P0/P1/P2 or empty} |

- Use human-readable date: `Monday, March 3, 2025` (convert from YYYY-MM-DD if needed).
- Leave Priority empty when not specified.

**Insertion:** Place new rows so the main Todo table stays ordered by priority (P0, P1, P2, empty). Merge new items with existing rows and ensure the full table is sorted by priority (P0 first, then P1, then P2, then empty). If the file has sections, keep the sorted table before the first `##`.

---

## Format: named section (with section name)

When adding under a named section:

```markdown

## {Section Name}

| ID | Task | Due | Priority |
|----|------|-----|----------|
| {next ID} | {Task description} | {YYYY-MM-DD} | {P0/P1/P2 or empty} |
```

- Use `YYYY-MM-DD` for Due.
- Leave Priority empty when not specified.
- **Ordering:** List items by priority (P0, P1, P2, empty) within the section.
- **Append** at the very end of the file. Never modify existing entries.
- Always leave a blank line before the section heading.

---

## File setup

- If `~/GitHub/Jarvis/todo/index.md` does not exist, create it with:
  ```markdown
  # Todo


  | ID | Task | DUE date | Priority |
  | --- | --- | --- | --- |
  ```
- Ensure `~/GitHub/Jarvis/todo/` exists (create if needed).

---

## Confirmation

After adding, report back:
1. Where items were added (main Todo table or section name)
2. Number of items and their IDs
3. Quick list of tasks with due dates
