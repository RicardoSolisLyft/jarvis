---
name: meeting-notes-extractor
description: >
  Process Google Meet transcripts and meeting notes to extract summaries and action items.
  Use this skill whenever the user uploads, pastes, or references a Google Meet transcript,
  meeting recording notes, or says things like "process my meeting", "extract action items",
  "summarize this meeting", "meeting notes", "meeting transcript", or "what came out of the meeting".
  Also trigger when the user mentions "Jarvis notes", "Jarvis todos", or references
  ~/GitHub/Jarvis/notes or ~/GitHub/Jarvis/todo. This skill handles the full pipeline:
  reading the transcript, generating a high-value summary, and appending structured
  action items with smart due-date defaults.
---

# Meeting Notes Extractor

This skill processes Google Meet transcripts and extracts two deliverables:

1. **A meeting summary** — saved as a markdown file in `~/GitHub/Jarvis/notes/`
2. **Action items** — appended to `~/GitHub/Jarvis/todo/index.md`

---

## Step 1: Identify the transcript

The input will be a Google Meet auto-generated transcript. It may come as:
- An uploaded file (`.txt`, `.vtt`, `.sbv`, `.srt`, or `.docx`)
- Text pasted directly into the conversation
- A file already on disk that the user points to

If the transcript is uploaded, find it in `/mnt/user-data/uploads/`. If it's pasted inline, work from the conversation content directly.

## Step 2: Determine the meeting date and topic

- **Meeting date**: Extract from the transcript metadata, filename, or content. If unclear, ask the user. Use `YYYY-MM-DD` format.
- **Meeting topic**: Infer from the main subject discussed. Keep it short and slug-friendly (lowercase, hyphens, no special characters). Examples: `quarterly-planning`, `api-redesign`, `onboarding-flow`.

These are used to name the summary file: `{date}-{topic}.md`

## Step 3: Generate the summary

Read through the entire transcript carefully. The summary should capture the **most valuable information** — not a blow-by-blow of the conversation, but the insights, decisions, and context that someone would actually want to reference later.

Structure the summary file like this:

```markdown
# {Meeting Topic — Title Case}

**Date:** {YYYY-MM-DD}
**Participants:** {comma-separated list of speakers identified in the transcript}

## Key Takeaways

{3–7 bullet points of the most important insights, decisions, and conclusions.
Each bullet should be a self-contained, useful piece of information.
Favor specifics over vague statements.}

## Discussion Highlights

{A concise narrative (2–4 paragraphs) covering the main threads of the conversation.
Focus on context, reasoning, and nuance that the bullet points above don't capture.
This section gives future-you the "why" behind the decisions.}

## Open Questions

{Any unresolved questions, parking-lot items, or topics deferred to a future meeting.
If none, omit this section entirely.}
```

Guidelines for a good summary:
- Be opinionated about what matters. Skip small talk, tangents, and filler.
- Use the speakers' actual words/phrasing when it captures something important, but paraphrase freely otherwise.
- If numbers, dates, URLs, or specific names were mentioned, include them — these are the details that are hardest to remember.
- Keep the total summary to roughly 300–600 words. Long enough to be useful, short enough to actually read.

Save the file to: `~/GitHub/Jarvis/notes/{date}-{topic}.md`

Ensure the `~/GitHub/Jarvis/notes/` directory exists (create it if it doesn't).

## Step 4: Extract action items

Go through the transcript again (or use your notes from the first pass) and identify action items. Cast a wide net — action items are not only explicit task assignments. They also include:
- Direct assignments ("Ricardo, can you handle the migration?")
- Soft commitments ("I'll take a look at that this week")
- Suggestions and wishes ("it would be good to have a dashboard for this", "we should probably update the docs")
- Group agreements ("let's aim to ship this before the demo")

Basically, if something was identified as worth doing, capture it.

### Filtering: only Ricardo's and unassigned items

Only include an action item if one of these is true:
- The assignee is **Ricardo Solís** (or clearly refers to him — "Ricardo", "Ricky", etc.)
- The assignee is **unclear or unspecified** (the item was mentioned generally, or no one was explicitly named)

Skip action items that are clearly assigned to someone else.

### What to capture per item

For each action item that passes the filter, capture:
- **Task** — a clear, actionable description
- **Due date** — the explicit date if one was mentioned in the meeting
- **Priority** — `P0`, `P1`, or `P2` if the urgency/importance is clear from context. Leave empty if unclear. P0 is the highest priority (critical/blocking), P1 is important, P2 is nice-to-have.

### Due date defaults (when no explicit date is given)

When the transcript does not specify a due date for an action item:
- The **first** undated action item gets a due date of **1 week after the meeting date**
- Each **subsequent** undated action item gets a due date **4 days after the previous item's due date**
- Items that DO have an explicit due date mentioned in the meeting keep that date and do NOT affect the spacing of undated items

Example: Meeting on 2025-03-10 with 4 action items, none with explicit dates:
- Item 1 → due 2025-03-17 (meeting + 7 days)
- Item 2 → due 2025-03-21 (previous + 4 days)
- Item 3 → due 2025-03-25 (previous + 4 days)
- Item 4 → due 2025-03-29 (previous + 4 days)

### Append to todo: use the action-items skill

**Invoke the action-items skill** to add the extracted items to `~/GitHub/Jarvis/todo/index.md`.

- **Section name:** Always provide a section name derived from the meeting: `{Meeting Topic — Title Case} ({YYYY-MM-DD})`. Example: `Vertical Video Extension CPR (2026-03-11)`.
- Pass the list of items (Task, Due, Priority) to the action-items skill. It handles ID assignment, table format, and appending.

## Step 5: Confirm to the user

After processing, report back with:
1. The path to the saved summary file
2. A brief preview of the key takeaways (3–4 lines max)
3. The number of action items extracted and where they were appended
4. A quick list of the action items with their due dates

Keep the confirmation concise — the user can open the files to see the full details.
