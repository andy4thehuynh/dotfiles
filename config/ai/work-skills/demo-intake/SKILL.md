---
name: demo-intake
description: Gather demo requirements and propose a narrative arc. Use when scoping a new customer demo, presentation, or technical session. Produces a demo brief consumed by demo-code, demo-deck, and demo-talktrack.
---

# Demo Intake

Produce a complete demo brief plus an approved narrative arc.
Propose nothing until every field is filled.

## Fields (all required)

1. Customer + industry
2. Use case
3. Technical pillars to prove
4. Audience — dev / exec / mixed
5. Time budget
6. Solo or co-presented
7. Success definition — what this demo must earn
8. Competitive angles to hit
9. Existing assets — deck, repo, transcript

## Filling order

- **Auto-fill** from account Project instructions if in one.
  State what was pulled; do not re-ask.
- **Reverse-fill** from an uploaded deck if one exists.
  Present extracted values for confirmation. Skip if no deck.
- **Ask** for remaining fields only. One question at a time.
  Never batch.

Mark any inferred value `[unverified]` until confirmed.

## Arc

After all nine fields are confirmed, propose the narrative arc —
the beat order that carries the customer from problem to proof.

Derive it from requirements, not from a template menu. Apply:
- Open on the customer's problem
- State the thesis early
- Sequence by narrative, not feature list
- Prove, don't assert
- Match audience and time budget
- Close on the stated success definition

Tell-show-tell is mandatory for any live demo segment.

## Gate

Stop after proposing the arc. Do not produce slides, code, or talk
track. Wait for explicit approval, then emit the brief below.

## Output

```
DEMO BRIEF
Customer:
Industry:
Use case:
Pillars:
Audience:
Time budget:
Presenters:
Success definition:
Competitive angles:
Existing assets:

ARC (approved)
1. <beat> — <purpose>
2. ...

OPEN ITEMS
- <unconfirmed or [unverified] values>
```

## Guardrails

- No invented account facts. Ask or leave a placeholder.
- No invented SQL++ or API surface.
- No perf numbers without a cited source.
