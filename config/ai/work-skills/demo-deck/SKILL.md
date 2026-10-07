---
name: demo-deck
description: Turn an approved demo brief and arc into a slide-by-slide build plan. Use after demo-intake, when needing a deck plan to build by hand from the Couchbase brand template.
---

# Demo Deck

Input: `DEMO BRIEF` + approved `ARC` from demo-intake.
Output: a slide-by-slide plan Andy builds by hand.
Do not generate a .pptx.

## Rules

- Tell-show-tell for every live demo segment
- Bookend: open on the customer's evaluation pillars, close by
  restating what was proved
- No fixed slide count. Length follows the arc and time budget
- Every slide maps to a layout in `brand-template-index.md`
- One slide at a time. Stop for approval before the next
- Offer the batch option: emit all slides at once so Andy can
  build the deck and upload it for a single review pass

## Per-slide output

```
Slide N — <title>
Layout: <template slide # + type>
Purpose: <what this slide does for the arc>
Content: <headline, body, labels, image intent>
Source: <existing deck to pull from, or "new">
```

## Gate

Deck plan only. No talk track — that's demo-talktrack.

## Guardrails

- No invented account facts. Ask or leave a placeholder
- No invented SQL++ or API surface
- No perf numbers without a cited source

## Note

The 2026 template has no architecture/diagram, comparison-table,
or live-demo-transition layout. Adapt existing layouts for now.
Revisit if custom layouts become necessary.
