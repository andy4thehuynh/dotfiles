---
name: flashcard-generator
description: Turns raw verbatim extraction from a Seismic/learning module (pasted from Claude in Chrome or elsewhere) into deduplicated Anki flashcards, mixed cloze and basic, for Couchbase Solutions Engineers building customer-facing fluency. Use this whenever the user pastes module content and asks for flashcards, Anki cards, or says "make cards from this," even if they don't name the skill. Also use when the user has multiple batches of extracted content across a conversation and wants a single final card set once all batches are in.
---

# Flashcard Generator

Converts verbatim learning-module content into Anki-ready flashcards. Assumes extraction already happened elsewhere (typically Claude in Chrome, batched in groups of 4 sections) — this skill does not navigate or extract, only evaluates and generates.

## When content arrives in batches

If the user is pasting content batch-by-batch (e.g., "sections 1-4," then "sections 5-8"), do NOT generate cards after each batch. Acknowledge receipt, note what's captured, and wait until the user signals all batches are in (e.g., "that's everything," "sections X-Y are the last ones") before generating the full card set. Generating early risks duplicate cards across batches that a final dedup pass would have caught.

## Inclusion criteria

Include a card only if it tests something a Couchbase SE would need cold in a customer conversation:
- Named tools, config parameters, env vars, exact flags/syntax
- Definitions of architecture actors/components (e.g., MCP Host, MCP Client)
- Tradeoffs, decisions, "why X over Y" framing
- Anything the module frames as a guardrail, security layer, or enterprise-critical concept
- Numbered/ordered processes (steps, flows, pyramids/layers)

Exclude:
- Marketing language, intro/welcome text, closing/"destination" summaries
- Restated section headers with no new fact
- Video titles/runtimes, callout box names with no retained content
- Anything already covered by an existing card in this set (near-duplicate = same fact tested from a different angle)

## Card style — mixed, judged per fact

- **Cloze** for: single-term recall, exact parameter names/values, "fill in the missing piece of a known structure"
- **Basic Q&A** for: definitions, "what happens when X," multi-part answers, conceptual tradeoffs

Default ratio observed to work well: roughly 60/40 basic-to-cloze, but let the content decide — don't force a ratio.

## Framing for the SE audience

The end user is a Couchbase Solutions Engineer using these cards to build conversational fluency with customers — not passing a trivia quiz. When a fact could be phrased two ways, prefer the phrasing closer to how it'd come up in a customer conversation (e.g., "What's the final gate even if OAuth grants write scope?" over "What is RBAC?").

## Deduplication pass (required, run after full draft)

Before output, review the complete draft set and remove or merge:
- Any two cards testing the same fact even if worded differently
- Any card that is >70% textually similar to another (same subject + same key term + same angle)
- Cross-section duplicates — the same concept (e.g., RBAC-as-final-gate) often appears in multiple sections; keep the clearest single card, drop the rest

State how many cards were cut in dedup and why, briefly.

## Output format

Two separate files, always, formatted for Anki import:

anki_basic_cards.txt — tab-separated, one card per line: Front\tBack

anki_cloze_cards.txt — one card per line, cloze syntax: Text with {{c1::hidden answer}} inline.

Always create and present both files — do not output cards as plain chat text.
