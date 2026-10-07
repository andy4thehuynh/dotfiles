# Andy's Talk Track Voice

Distilled from NOV RAG/CAM demo and Couchbase Developer Day.

## Structure

Two nested patterns. Both are load-bearing.

**Tell-show-tell** — deck level. Say what you'll prove, prove it
live, restate what was proved. Bookend on the customer's own
requirements.

**P → S → V** — slide level, for capability slides:
- **P** — the problem, in the customer's world
- **S** — what Couchbase does, one sentence, mechanism named
- **V** — what it means for *them*, in their terms

Not every slide needs all three. Concept slides often skip P.

## Sentence craft

- Short declaratives. Break long thoughts across lines
- Second person, always. "Your documents," "your developers"
- Name the mechanism, then translate it. "GSI-backed — that means
  SQL++, not a proprietary query language"
- Concrete over abstract. Real doc names, real personas, real specs
- Analogies for hard concepts: XDCR as a shared Google Doc,
  Channels as security badges on a rig

## Openers and transitions

- "Here's what's actually happening under the hood"
- "Let me show you this live"
- "Let's see it in action"
- "To bring it all together"
- "The key takeaway from this slide is..."
- Section dividers get one sentence, then advance. Never linger

## Signature moves

- **Land the thesis, then pause.** Big claims get silence after
- **Contrast pairs.** Stateless slide made painful, stateful slide
  as relief — same scenarios, opposite outcome
- **Always tie back to their use case.** Every capability ends in
  "for your <customer use case>, this means..."
- **Acknowledge breadth, don't explain it.** On dense architecture
  slides: gesture at the two areas in scope, defer the rest to Q&A
- **Cost and risk framing for builders.** Token spend, infra to
  manage, licensing, ops overhead
- **Comparison tables: never read the cells.** Hit two or three
  rows that matter, land the single-platform point

## Audience engagement

- Show-of-hands questions to open a section: "Who here is familiar
  with Couchbase?"
- Invite interruption early: "Ask questions throughout"
- Self-aware asides are allowed and land well ("mouthful")

## Banned

- Reading slides aloud
- Walking through every numbered step on a dense diagram
- Feature lists without a customer translation
- Superlatives without proof

## Contingencies

Write fallback lines for live demos — what to say if ingestion is
slow, if a query lags, if something fails. The NOV deck did this
and it saved the segment.
