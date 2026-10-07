# SFDC SE Related Information & Activity Data — Field Reference

Source: Couchbase Field Engineering "SE Related Information and Activity Data" deck.

## SE Related Information (Opportunity)

- **SE Opp Primary** (lookup) — set by SE Manager. Required at Stage 2+.
- **SE Opp Supporting SE** (lookup) — optional, when another SE measurably contributes.
- **Supporting SE Contribution %** (picklist: 25/50/75/100%) — required Stage 3+ if Supporting SE entered.
- **SE Use Case** (multi-picklist): Cache, Catalogs, Content Management, Customer 360, Data Aggregation, Digital Comms, Edge Apps, Fraud Detection, Internet of Everything, Mainframe Offload, Mobile Apps, NoSQL Offload, Online Transaction Processing, Operational Analytics, Personalization, Profile Management, RDBMS Offload, Real-time Big Data, Training Apps, Other (see win/loss notes). Required Stage 2+.
- **SE Arch & Sizing Validated** (picklist: In Progress, Validated, Customer Declined) — required Stage 2+, should be Validated/Customer Declined before Closed.
- **SE Technical Risk** (picklist):
  - Low: Good To Go — no technical risk, opp is good (default on renewals)
  - Medium: 50/50 — opp has some risk
  - High: No Way — opp has technical risk that requires attention
  - Required Stage 2+. If not Low, describe mitigation in SE Next Steps.
- **SE Technical Champion** (text) — required Stage 2+.
- **SE Product GO Live Date** (date) — optional.
- **SE Product Capability** (multi-picklist): ACID, Analytics, Backup Services, Connectors, Couchbase Lite for Edge, Couchbase Lite for Mobile, Edge Apps, Encryption, Ephemeral Buckets, Eventing, Indexing, Inter Sync Gateway Replication, KV, Multidimensional Scaling, SQL++, Operator, Scopes & Collections, Search, Security, Sync Gateway, Peer-to-Peer Sync, Transactions, Views, XDCR. Required Stage 2+.
- **SE SDK Type** (multi-picklist): .NET, C/C++, GO, Java, Node.js, PHP, Python, Ruby, Scala, Unknown. Required Stage 2+.
- **SE Mobile SDK Type** (multi-picklist): C, C#, Java, Java Android, Javascript, Objective-C, Swift, Unknown. Required Stage 2+ if Couchbase Lite selected.
- **SE Tech Decision Criteria** (picklist): 0-Undefined, 1-Defined not shared with SE, 2-Shared not validated for fit, 3-Shared & Validated for fit. Required Stage 2+; if Formal POC/POV, aim for ≥2.
- **SE Tech Deployments** (multi-picklist): Bare metal, Capella (Hosted), Private Cloud, Public Cloud (IaaS). Required Stage 4+.
- **Blocking CBSE** (text) — links to blocking CBSEs, required if related CBSEs exist.
- **SE Technical Win** (picklist): Yes, No, In Progress, N/A-Services/Training Only.
  - In Progress = SE meaningfully engaged (requirements/scope/success criteria), not just intro calls.
  - Yes/No = customer confirmation Couchbase has/hasn't been selected.
  - Renewals: In Progress while confirming still-in-use/good-standing/no blockers; Yes once confirmed. Engage 90 days before renewal date.
  - N/A only for Type="Services Only".
  - Required Stage 3+ for all non-renewals. Renewals show Red Flag until Yes/No.
- **SE Tech Validation Methods** (multi-picklist): Capella Reviews, Capella Trial, Competitive Overview/Differentiation, Custom Demo, Deployment Sessions, Download CE Version, Formal POC/POV, Joint Partner Presentation/Overviews, Pilot, PM Presentations, Renewal, Roadmap Sessions, Sandbox, Service & Training Presentations, Solution Design Sessions, Standard Demos, Technical Deep Dives, Technical Overviews, Technical Evaluation, Technical Workshops, Trial, Webinars. Renewal is default for renewal opps. Required Stage 2+.
- **SE Technical Win/Loss Notes** (text) — required when Technical Win = Yes/No.
- **SE Next Steps Date Planned On** (date) — optional follow-up reminder date.
- **SE Next Steps** (text) — required at least every 7 days when Stage 2+ and Technical Win = In Progress. Append newest entry to top: `YYYY-MM-DD initials: note`. Describe next steps/risk/blockers. Escalate significant concerns to manager directly, don't rely on this field alone. Can stop weekly updates if truly On Hold (state so), resume when active again.

### Autofill fields (do not set manually)
SE Technical Win Date, SE Time to Technical Win (days), SE Tech In Progress Date, SE Next Steps Last Updated On, SE Next Steps Last Updated Days, SE Time Tech Win In Progress (days).

### Carry-over fields (Closed Won → Renewal opp)
SE Use Case, SE Technical Champion, SE Product Capabilities, SE SDK Type, SE Mobile SDK Type, SE Tech Decision Criteria, SE POC Win/Loss Notes, SE Tech Win/Loss Notes, SE Next Steps, SE CE/EE Conversion (defaults to No on renewals).

## POC Fields (only if Formal POC/POV in Tech Validation Methods)

- **SE POC Stage** (picklist): Scoping, In Delivery, Evaluating Results, On Hold, Won, Lost. Required Stage 2+ when Formal POC/POV selected; above Stage 2 only Won/Lost valid.
- **POC Scoping Doc** (link) — attach.
- **SE POC Start Date** — enter as soon as estimated, even if it may change.
- **SE POC End Date** — enter at start of POC to set expectations; keep updated.
- **POC Implementer** (picklist): Customer, Partner, PS, SE. Required Stage 3+ if Formal POC/POV.
- **SE POC Win/Lost Notes** (text) — required Stage 3+ when POC Stage = Won/Lost.
- **SE POC Days Open** (autofill) — from Start/End Date; On Hold doesn't pause it.
- **SE POC Eng Support Req** (checkbox) — flag if POC needs Field Engineering attention.
- **SE Manager Email** — required if Eng Support Req checked.

## Forecast-call summary fields (context only, not SE-entered directly each time)
SE Technical Win, POC Stage, POC Start/End Date, SE Next Steps — reviewed every forecast call as the primary signal of opportunity health/risk.

## Activity Data Collection (Events)

**General rule:** Log SE Activity Type + duration + Location on the Opportunity (selling) or Account (non-opportunity: marketing/post-sales). Never log prep time or demo-build time.

### Selling (Opportunity-based) — SE Activity Type options
Discovery, Demo, Architecture Discussion, POC Scoping, POC Execution, Sizing (+ None)

| Activity | Logging |
|---|---|
| 45-min discovery call | Discovery – 1 hr; Remote |
| 90-min customer meeting w/ demo | Demo – 1–2 hrs; Remote |
| 1-hr POC scoping | POC Scoping – 1 hr; Remote (repeatable) |
| 1-day hands-on POC work onsite | POC Execution – 8 hrs; Onsite |
| 2-day demo build | **Do not log** |
| 1-hr sizing discovery + 1-hr calc | Sizing – 1 hr; Remote (calc/prep not logged) |
| Scoping call remote – 1 hr | Scoping – 1 hr; Remote |
| Internal scoping/prep – 4 hrs | **Do not log** |
| POC wrap-up meeting onsite – 90 min | POC Execution – 1–2 hrs on date it happens; Onsite |

### Not tied to an existing Opportunity (Account-based) — e.g. Marketing/Post-Sales — SE Activity Type options
Enablement, What's New/Roadmap, Marketing Events, Partner Events, Support, Services Work (+ None)

| Activity | Logging |
|---|---|
| 45-min support (video call) | Support – 45 min (round up to 1 hr); Remote |
| 10–15 min support | **Don't log** — too insignificant |
| 3 hrs email support | Support – 3 hrs; Remote |
| 90-min What's New/roadmap onsite | What's New/Roadmap – 90 min; Onsite |
| 4-hr conference | **Don't log** — not account-specific |
| 2-hr partner overview remote | Partner Events – 2 hrs; Remote |
| 8-hr tech day onsite | Enablement – 8 hrs; Onsite |
| 2-hr customer dinner (not tied to active new-biz opp) | Marketing Events – 2 hrs; Onsite |
| 4-hr upgrade guidance onsite | Services Work – 4 hrs; Onsite |
| 2-day remote migration help | Services Work – 16 hrs; Remote |

### Event fields
- Subject (free text)
- SE Activity Type (dropdown, see above)
- Start/End date + time — date must be accurate; exact time doesn't matter, only duration
- Name / Related To Case — usually auto-populated
- Assigned To — auto-populated
- Location — "Onsite" or "Remote"

## Guiding principle (not a performance-management tool)
Activity data isn't about accounting for every hour. For sales activities, volume/location of activity matters more than duration. For post-sales (support/CS/services), duration matters — the goal is reducing total post-sales hours. Performance is measured primarily by revenue contribution; activity data adds context.
