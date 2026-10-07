---
name: demo-talktrack
description: Write slide-by-slide talk tracks in Andy's voice from an approved deck plan. Use after demo-deck, when slides exist and the spoken narrative is needed.
---

# Demo Talk Track

Input: approved deck plan from demo-deck, or an existing deck.
Output: talk track per slide, in Andy's voice.

## References

Read before writing any talk track:

- `voice.md` — voice rules. Structure, sentence craft, banned moves
- `nov_talk_tracks.md` — format exemplar. Solo, 30-min, tagged
- `devday_talk_tracks.md` — voice exemplar. Multi-presenter, 3-hour

## Tags

- `[tt]` — spoken talk track
- `[👉]` — presenter or demo action. Max 7 words
- `[🙋‍♀️]` — audience question to keep the room engaged

Bold the key beats inside `[tt]` so they scan at a glance.

## Per-slide output

```
Slide N — <title>
[tt] <talk track, key beats bolded>
[👉] <action, ≤7 words>
[🙋‍♀️] <audience question, when it earns its place>
Timing: <estimate>
```

`[👉]` and `[🙋‍♀️]` are optional per slide. Do not force them.

## Rules

- One slide at a time. Stop for approval before the next
- Tell-show-tell for every live demo segment
- Co-presented decks: write all presenters' lines in Andy's voice
- Audience questions stay tasteful and tailored — spread them,
  never stack them back to back
- Sum timing against the brief's time budget. Flag overruns

## Guardrails

- No invented account facts. Ask or leave a placeholder
- No invented SQL++ or API surface
- No perf numbers without a cited source
