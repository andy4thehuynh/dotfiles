---
name: grill-me
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

## Reasoning effort

Default the session to **high** thinking (`/thinking high`) for the whole grill — stress-testing a plan benefits from deep reasoning. Announce the level change in one line, then proceed. The user toggles it manually when they want otherwise.

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet.

**Ask exactly one question per message.** Never batch. Compute the frontier, pick the highest-leverage question on it, ask that one, and wait for the answer. No preamble, no summary of what's coming.

Show a counter so the user knows how much runway is left: `🙋 N of M` where M is the number of questions currently on the frontier, including this one. If M is a moving estimate, use `🙋 N — ~M more` and revise it as the tree resolves.

Format a single question like so:

```
🙋 2 of 5

❓ **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each answer reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier after every answer, then ask the next single question. A question whose answer depends on an unanswered question is not on the frontier yet.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so ask a different frontier question while it runs. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
