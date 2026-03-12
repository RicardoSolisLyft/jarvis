# Vertical Video Extension CPR

**Date:** 2026-03-11
**Participants:** Miranda Priestly (NYC), Fernando Rangel, Vishal Murali, Ricardo Solís, Yuri Istomin, Aparna Gangwar, Carol Guo, Shash Mehrotra, Marc Milberg

## Key Takeaways

- **Server-side PRs**: Fernando is splitting the server PRs—core logic integration vs. shadow logging for the right predictions API. The initial PR will be ready for external review by tomorrow (2026-03-12).
- **Vertical video eligibility**: Team agreed with Ryder that vertical video should eventually be eligible for *all* wait stages across all ride modes, excluding premium modes (Black, Extra Comfort, Priority Pickup). Currently it's only on wait-and-save.
- **Amazon campaign (4/1)**: If the Amazon deal is secured, the vertical video campaign starts April 1. This would require setting up the format as an experiment for all Amazon inventory to validate degradation on standard modes. Deal status is still pending.
- **Ride stage change interruption event**: Ricardo's PR for the new interruption event (to measure how often video stops due to ride stage change) is up but not yet merged. Critical for identifying fast matching; standard rides are expected to fast-match more than wait-and-save. P1 follow-on—not blocking Amazon launch since VCR metric exists, but should be done.
- **Exposure numbers**: Carol's original experiment design was from September; Vishal will rerun the power analysis—baseline metrics and seasonal effects may have changed, and the Bayesian system was implemented since then.

## Discussion Highlights

Server-side and client-side work are largely complete. Fernando validated the click functionality (URL) via the bubble snippet; the change works on staging for both Android and iOS. One gap: the transition from video end → accepted state → poster needs an end-to-end test. Fernando will create and share an offload from staging to enable this, since the bubble snippet cannot fully exercise that flow.

The vertical video experiment extension to standard modes has been delayed by months. Ryder was initially sensitive ("too in your face for an ad") and alignment took until October, including requested changes. The Amazon campaign, if it lands, becomes the vehicle to test vertical video on standard modes and potentially expand eligibility broadly.

The new ride stage change interruption event fires when a ride stage changes while the video is still playing (didn't finish), allowing measurement of fast-match interrupts. Ricardo has a PR ready; Fernando created tickets for Android and iOS. The team agreed to track this as a P1 follow-on rather than blocking the Amazon launch.

## Open Questions

- **Amazon deal status**: No update yet. Chris and Jack are following up; the team will notify once there's direction.
- **Exposure numbers**: Vishal will redo the power analysis with updated baselines and seasonal assumptions; results may reduce the required sample size.
