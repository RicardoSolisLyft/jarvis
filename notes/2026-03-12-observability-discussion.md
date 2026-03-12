# Observability Discussion

**Date:** 2026-03-12
**Participants:** Eugene Ternovoi, Oleksandr Pokhyl, Anton Petrov, Yuri Istomin, Bob Law, Emily Son, Anton Petrov, Oleksandr Pokhyl, Agustin Jaimes, Ricardo Solís (invited)

## Key Takeaways

- **Grafana selected over Mode + Varit** for observability: single tool, full automation potential, AI-scalable workflows. Mode/Varit splits dashboards and alerts across two tools and isn't scalable.
- **Real-time is not achievable**—analytics SDKs batch events; delivery can range from 1 hour to 30 days. Goal is to get close to real-time; 3-hour aggregation window is acceptable for release regression detection.
- **Cardinality is the main Grafana blocker**: M3 (Grafana’s data source) needs low cardinality. High-cardinality tags (e.g., durations, media player volume, video URLs) hurt performance and M3 ingestion.
- **Normalization requires client-side changes** on iOS and Android; client analytics have strict parameter limits (action, tech, value, result only—5 params), so adding fields is constrained.
- **Roadmap**: Audit events → backend changes (can be AI-assisted) → cover P0 events (impressions, views, viewability, clicks by offer type) → continue with other events. P0 metrics are mostly server-driven and should have acceptable cardinality.

## Discussion Highlights

Eugene outlined observability goals: alerts, dashboard filters (app version, platform, OS version, experiments/feature flags), documented metric definitions, escalation runbooks, and AI-scalable workflows. Business KPIs (impressions, views, CTRs, engagement) and technical health (OMSDK, video buffering, playback start rate) will be tracked.

Grafana enables automation: when a PR adds or changes analytics events, AI can create dashboards and PRs. Alert strategy: backend on-call for most events; for release regressions and mobile-specific issues, notify mobile devs who have time to investigate rather than a formal rotation. Thresholds will be set after dashboards exist and normal values are known.

Cardinality examples: event tags with many unique values (e.g., specific durations, volumes) create separate time series and degrade M3 and dashboard performance. Some fields need normalization; others are unsafe. A 3-hour aggregation window is needed because dependent events (e.g., viewability = views / impressions) may be delivered at different speeds, producing spurious results like 3% viewability.

Oleksandr confirmed Grafana uses M3; Eugene clarified the idea is to normalize existing M3 events. Client analytics parameter limits mean “moving duration to a separate parameter” may not be feasible—each event must be evaluated. Anton proposed starting with P0 metrics in Grafana (impressions, views, viewability, clicks, distribution by offer type); Eugene agreed and noted these are largely server-driven. Anton also stressed client-side metrics are useful for checking logs when server-side alerts show discrepancies.

Eugene has already tested events in Grafana and created a temporary dashboard for the Android Coroutines migration; some events are not compatible today. Eugene and Oleksandr agreed to use Grafana and scheduled a follow-up one-on-one.

## Open Questions

- JSON format for passing tags (Anton raised; Grafana parsing capabilities unclear).
- Client analytics parameter limits may block some normalization approaches; per-event discussion needed.
- Exact threshold values for alerts to be defined after dashboards are built and baseline values observed.
