---
name: sfdc-extract
description: Extract Salesforce "SE Related Information" opportunity fields and SE activity/event log entries from a meeting transcript, call notes, or other source text. Use this whenever the user pastes a meeting summary/transcript/notes about a customer/opportunity and wants Salesforce fields filled in, or explicitly asks to "extract SFDC fields," "pull SE fields," "log this to Salesforce," "fill in SE Related Information," or similar — even if they don't name the skill. Also trigger for POC-related opportunities needing SE POC Stage/Start/End, and for logging SE Activity events (Discovery, Demo, POC Scoping, POC Execution, Sizing, etc.). Do NOT log prep time, demo-build time, or internal-only work as activity.
---

# SFDC Extract

Turns meeting transcripts, call notes, or other freeform source text into ready-to-paste Salesforce field values, following Couchbase's SE Related Information and Activity Data rules (see `references/sfdc-fields.md` for the full field definitions, picklist values, and stage requirements).

## Workflow

1. **Read the source.** Identify: opportunity/account name, whether it's a Renewal or New Business, whether a POC is involved, and any dates/durations of specific engagements (calls, demos, onsite work).
2. **Check `references/sfdc-fields.md`** for the exact picklist options and stage-gating rules before filling any field. Never invent picklist values — only choose from the documented options.
3. **Extract only what's supported by the source.** If a field isn't addressed in the source, leave it blank rather than guessing. Mark any inferred (not explicitly stated) value with `[unverified]`.
4. **Output format** — simple `Field Name: value` lines, grouped under these headers as applicable:
   - `**Opportunity — SE Related Information**`
   - `**POC Fields (if Formal POC/POV)**` — only include this section if a POC is present
   - `**Activity/Event (per logged item)**` — one block per loggable event; skip prep/build time per rules
   - `**SE Next Steps — exec format**` — see rule below
5. **SE Next Steps rule:** Always write this for an executive-leader audience — succinct, no internal jargon, no rambling narrative. Format: `YYYY-MM-DD [initials]: <status/risk in one line>. <one concrete next step + timing>.` Never exceed ~2 sentences.
6. **Renewals default:** Technical Validation Method = Renewal, Technical Risk defaults to Low unless the source indicates otherwise.
7. **If the source is ambiguous** about which SE Activity Type fits (e.g., a general check-in call doesn't map cleanly to Discovery/Demo/POC Scoping/etc.), say so explicitly rather than forcing a picklist value.

## Notes

- This skill produces field values only — it does not write directly into Salesforce.
- If the user provides a new PDF/reference with updated field rules, update `references/sfdc-fields.md` accordingly before extracting.
