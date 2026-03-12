# Viewability CPR (2 Initiatives)

**Date:** 2026-03-11
**Participants:** Miranda Priestly (NYC), Vishal Murali, Carlos Cabrera, Aparna Gangwar, Agustin Jaimes, Carol Guo, Marc Milberg, Roman Belopolsky, Alexus Strong, Eugene Ternovoi, Yuri Istomin, Zidne Islam, Ricardo Solís

## Key Takeaways

- **Monitored rollout for beta**: Vishal will confirm with Carol whether a monitored rollout is needed for features already in beta (belief: only production needs it). If Carol agrees to roll out to everyone, someone can put up a PR for approval to roll out on beta.
- **Observability dashboards**: Miranda will set up dashboards for crashes, viewability, and period ratio, aiming for the 3/18 start.
- **P1 improvements**: Three-track plan—(1) straightforward fix: enable Direct Carousel and Rock Carousel calculations on iOS (this sprint); (2) split calculation logic by ad type so DAC or others can be enabled independently (~1 sprint); (3) map consideration (~1–2 sprints). Planning assigned to Miranda, Alex, and Aparna.
- **Door Dash campaign (3/14)**: Two parts—sponsored modes (unified messaging, Andrew/Aparna) and post-request OM SDK test with IAS and DV tags on poster only. Carlos helping with setup. Universal deep-link messaging ("link your accounts here for everyone") chosen as lowest risk; Vishal to respond to partner marketing. Coupon validation fix (optional when no code) deploying 3/12.
- **Driver arrive card**: Server change to 60 points (50% in view) under review, expected production EOD 3/11; must be live for Saturday 3/14.
- **Degradation testing (3/23 start)**: Vishal provided list of poster campaigns without DV/IAS tags (from Salesforce). Need to translate campaigns to ride volume to hit 4.8M rides; Vishal will investigate.

## Discussion Highlights

The Door Dash campaign setup involves filling fields, inserting IAS and DV tags (Agustin posting DV tags in channel; IAS already available), and coordinating with Alexis for assets. Carlos is also handling Schwab (live Monday) and the coupon fix to make validation optional when there's no coupon code—needed for pre-request dogfooding. Aparna is running a staging test; Andrew asked to reuse the Schwab dogfooding campaign; Carlos agreed, excluding the TTR portion.

Agustin will run a test plan for both platforms while setting up campaigns in staging, and has updated ads docs for impressions and OM SDK plus submitted the first PRR revision for review. Carlos will work on general metrics and dashboards after Door Dash and Schwab.

## Open Questions

- Whether monitored rollout is required for beta (Vishal confirming with Carol).
- Best way to translate the degradation-test campaign list into ride amounts to reach 4.8M rides (Vishal investigating).
