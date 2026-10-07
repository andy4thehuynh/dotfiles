---
name: demo-code
description: Build the working demo application from an approved demo brief. Searches existing Couchbase repos, scores fit, proposes approaches, builds, verifies against a live cluster, and outputs a demo runbook. Runs in Claude Code — needs filesystem, gh auth, and a local Couchbase cluster.
---

# Demo Code

Input: `DEMO BRIEF` + approved `ARC` from demo-intake.
Output: working demo app, verification checklist, demo runbook.

Runs **before** demo-deck and demo-talktrack. Slides and talk
track describe what this Skill actually built.

## 1. Tighten the brief

Read the brief. Ask clarifying questions — one at a time, never
batched — until requirements are 95/100 tight. Cover at minimum:

- Data source: customer-supplied docs, synthetic, or public
- Cluster: version, self-managed vs Capella, services enabled
- LLM and embedding model
- What must be visible on screen for each pillar
- Failure tolerance: live cluster vs pre-seeded

Do not proceed while any answer is a guess.

## 2. Find existing repos

Public — search `couchbase-examples` and `couchbaselabs` directly.
Score each candidate /100 against the brief. Report only those
scoring 80+. If more than 5 qualify, keep the top 5.

Score on: pillar coverage, stack match, data-swap effort,
UI suitability for live demo, maintenance state.

Private — output exactly 4 concise `gh` search queries for Andy
to run himself:

```bash
gh search repos --owner couchbaselabs "<terms>"
```

Assume any repo needs tailoring to reach 100 for this demo.

## 3. Propose approaches

Propose 5 demo approaches. Score each /100 for fit to the brief.
Per approach: base repo (or scratch), what gets built, what gets
cut, effort, risk.

Stop. Andy picks one.

## 4. Build

Build the selected approach. One component at a time.

## 5. Verify

Run against the live cluster. Output a verification checklist:
every query, every result, every UI state that must work on demo
day — with expected output. Include timing for anything slow.

## 6. Runbook

Output the demo runbook:

- Tell-show-tell outline per segment
- **Money moments** — the exact beats that land the point.
  What's on screen, what makes it land
- Anticipated questions with answers, grouped by pillar
- Fallback lines for slow or failed steps

## Guardrails

- No invented account facts. Ask or leave a placeholder
- No invented SQL++ or API surface — verify against docs
- No perf numbers without a cited source
- Never claim a step works without running it
