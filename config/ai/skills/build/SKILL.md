---
name: build
description: Build from a plan in docs/plans/. Tracer bullet first, builder subagents for independent tasks, the reviewer agent at each milestone, then /compound. Use when the user says "build" or asks to implement a plan.
argument-hint: "[plan path, or blank for the plan with unchecked tasks]"
---

# build — tracer bullet, tasks, review, compound

Runs without the user once started. Stop and ask only when a plan decision turns out wrong, or a task needs something the plan doesn't give (secrets, access, a scope change).

## 1. Load the plan

Use the path given, or the doc in `docs/plans/` with unchecked tasks. No plan → stop and suggest `/grill-me` to shape one, then write it to `docs/plans/`.

Read Goal and Decisions first. Decisions are settled; a rejected option is not something to revisit mid-build. Assume the plan gives everything needed — do not re-derive it with extra reasoning; toggle `/thinking` up only when a task genuinely warrants it.

## 2. Branch

Follow the git rules in CLAUDE.md before the first commit.

## 3. Tracer bullet

If no task is checked yet, the first task must be the thinnest slice that runs end to end through every layer, and that a person can operate. If the plan lacks one, add it as the first task.

Use it as a user would before moving on. A passing test is not a use.

## 4. Work the tasks

In order, one at a time:

- **Independent tasks** — marked `(parallel)`, touching no shared files — may go to general-purpose subagents at once. Give each the plan path, its task, and the files it owns. Everything else runs in this session.
- **Verify** with the linter, the tests, and by running the thing.
- **Commit** through `smart-commit`, ticking the task's box in the plan in the same commit.

## 5. Review each milestone

A milestone is the tracer bullet, then each `### Milestone` heading under Tasks.

Delegate to the `reviewer` agent with the diff base and the plan path. Then:

- Fix confirmed findings in severity order. Write the failing test first where a test is the right proof.
- A finding you choose not to fix goes under Decisions with the reason. Never drop one silently.
- Re-run the suite and the primary path after fixing.

## 6. Keep the docs true

- Build diverged from the plan → update Decisions now. A plan that disagrees with the code misleads the next session.
- Create or update `docs/architecture.html` per CLAUDE.md.

## Done

Every box ticked, suite green, the primary path used by hand, every reviewer finding fixed or recorded. Then run `/compound`.
