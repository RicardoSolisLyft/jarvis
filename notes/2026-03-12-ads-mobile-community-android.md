# Ads Mobile Community — Android

**Date:** 2026-03-12
**Participants:** Emily Son, Oleksandr Pokhyl, Ricardo Solís, Eugene Ternovoi (Anton Petrov invited)

## Key Takeaways

- **On-call process**: Handoff Monday mornings; main duties are plus-oneing production rollouts (25%, 50%) using Graphana dashboards, responding to family-bot threads, investigating Sentry, and approving cherrypicks. Schedule: 10:00 a.m.–2:00 a.m. NY time (Europe covers the gap). Mobile operations channel posts warnings/criticals; on-call monitors that rather than Sentry directly.
- **Rider vs. driver on-call**: Emily will clarify whether mobile Android on-call is responsible for both rider and driver, or if there is a separate rider/server on-call.
- **Ad format review skill**: Ricardo built a skill that checks ad formats against basic requirements (no legacy, correct impressions/events). It produces a summary of issues (e.g., video not reporting analytics for resource fetching). Useful for new formats, but creating formats is infrequent—questionable ROI for this skill.
- **Skill storage**: Options discussed: (1) separate ads-only repo for Android/iOS/backend skills, (2) Google Doc (no version control), (3) project-level if infra approves. Oleksandr suggested discussing with mobile infra or Denise Nikki (skill author).
- **Project Humung alignment**: Ricardo noted the skill is a *code review* tool, whereas Project Humung is about *AI execution + human review*. Might be better to break it into execution-focused skills (e.g., “add viewability to a format”) rather than a review-only skill.
- **Cloud Code feedback**: Eugene used Claude for coroutine migration—automatic migration plan, PR creation via `gh`, agent device skill for video recording/attachments (manual upload still needed). Cursor vs. Claude: comparable code quality; Cursor better UX (more detailed, tables, links). Both can use GitHub CLI for PRs. Claude installed `gh` for Eugene when he asked to create a PR.

## Discussion Highlights

Emily shared her first on-call experience so far: process is smooth, with daily async updates from the engineer she’s shadowing. She’ll do another share after a full sync with him, and will clarify rider vs. driver on-call ownership.

Ricardo demoed his ad format review skill: it scans a given format and outputs a concise report of everything that’s wrong. Oleksandr found it useful for new formats and asked Ricardo to share the PR. Storage of ads-specific skills sparked debate—whether to keep them separate or merge at project level. Eugene and Oleksandr suggested merging if mobile infra approves; Oleksandr recommended talking to Denise Nikki, who has authored skills.

Cloud Code discussion: Eugene’s coroutine migration workflow showed strong automation (plan, migration, PRs, video tests). Bottleneck: GitHub CLI can’t attach files to PRs; manual upload required. Emily noted Cursor feels more conversational and closer to Android Studio; Oleksandr said Cursor gives more visual, detailed answers than Claude.

## Open Questions

- Whether mobile Android on-call includes rider or only driver, and how that relates to “rider on call.”
- Where to host ads-specific skills long-term (separate repo vs. project-level vs. other).
