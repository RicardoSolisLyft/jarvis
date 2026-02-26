# Media Mobile Community — Meeting Notes

**Meeting:** [🍏+🤖] Media Mobile Community - Whole Team  
**Date:** Feb 26, 2026

---

## Integration of mobile engineers

**Main takeaway:** Joining with 6 mobile engineers (3 Android, 3 iOS) from the business team has no code overlap but enables shared practices, knowledge, and more eyes on PRs. Keep integration cadence light (quarterly demos or at most monthly).

---

## Meeting cadence for joined teams

**Main takeaway:** Use a dedicated, demo-heavy meeting (e.g. quarterly or at most monthly). Current team stays bi-weekly; separate cross-team sync even every other month adds useful per-platform support.

---

## Client health improvements

**Main takeaway:** Client logs are the “second border” to catch server gaps. A recent server-side JS link validation failure cost ~1.5M impressions. Need dashboards and metrics for client-side health (impression firing, DTO handling, alignment with server impressions).

---

## Tooling for client health monitoring

**Main takeaway:** Use client-side analytics as the source, then Mode dashboards and Varity alerts. Grafana can’t be sent to directly from the client; a draft one-pager is in progress.

---

## Alerting systems

**Main takeaway:** Rely on proactive alerting (e.g. Slack), not only Sentry assignments. A critical issue was missed on vacation because the Sentry ticket was only assigned to one person. This is especially important for upcoming Android migrations.

---

## Observability dashboards strategy

**Main takeaway:** Balance “one source of truth” with different dashboard purposes (e.g. migration/error alerts vs feature-level flows). Allocate time for engineers to build a feature-specific dashboard as part of the feature work. Combine high-level overview with breakdowns by feature/format.

---

## AI skills for text specs

**Main takeaway:** Cursor was used successfully to generate a markdown text spec from Google Docs (e.g. plug-in refactor). Consider PD docs and templates as context. Review options: copy back to Google Docs, GitHub PRs with inline comments (then address in Cursor), or store final specs in a documentation repo.

---

## Markdown text spec storage and review

**Main takeaway:** Options include platform-specific repos (to feed code generation), or a shared docs repo for finalized text packs (searchable, doubles as documentation). GitHub PR review on the markdown diff is a viable workflow; confirm security and tool approval before using external collaborative tools.

---

## OMSDK testing (Charles)

**Main takeaway:** Charles setup for OMSDK (e.g. poster visibility) is non-trivial and differs for iOS vs Android. Schedule a short live session (10–15 min) with the team to debug; the person most familiar with the non-standard Charles setup is currently unavailable.
