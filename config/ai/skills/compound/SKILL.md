---
name: compound
description: Capture what this session taught and route each lesson to where the next session will find it — docs/solutions, a rule, a skill, or an account file. Use at the end of /build, when the user says "compound", or when offered after account work.
---

# compound — make the next session smarter

## 1. Harvest

Review the session for what a future session would otherwise relearn:

- Surprises, dead ends, and fixes whose reason isn't visible in the code
- Corrections the user made to how you worked
- A procedure done for the second time
- New facts about an account or a person

Skip anything the code, tests, commit messages, or existing docs already say.

## 2. Route

`$CFG` is the ai-config repo: `dirname "$(readlink ~/.claude/CLAUDE.md)"`.

| Lesson | Destination | Example |
| --- | --- | --- |
| Fix or gotcha in this repo | `docs/solutions/<slug>.md` | Vector index needs a rebuild after a schema change |
| Convention for a language or tests, any repo | `$CFG/rules/<name>.md` | Couchbase test fixtures reuse one cluster connection |
| Procedure done twice, this repo only | `<repo>/.claude/skills/<name>/SKILL.md` | `reset-demo` reloads sample data |
| Procedure done twice, any repo | `$CFG/skills/<name>/SKILL.md` | A sizing bundle built the same way for two accounts |
| Global rule the user keeps restating | `$CFG/claude-code.md` | "Never mock the cluster" |
| Account fact | `~/cbme/accounts/<slug>/README.md` | Security review takes 30+ days |
| Person fact | `~/cbme/people/<name>.md` | Wants diagrams, not slides |
| SE lesson that carries across accounts | `~/cbme/docs/solutions/<slug>.md` | The answer that landed on MongoDB licensing |

Search the destination first. Update an existing entry rather than adding a near-duplicate.

## 3. Propose, then wait

One list. Per item: the lesson in one line, its destination, and the exact text to write. The user approves, edits, or rejects each. Write nothing before that.

## 4. Write

A `docs/solutions/` entry:

```markdown
---
title: <what broke or what was learned>
date: <YYYY-MM-DD>
tags: [<area>, <tool>]
---

## Problem
## Fix
## Why it wasn't obvious
```

A new global skill needs `ruby bootstrap.rb install --personal` in `$CFG` to link it.

Commit through `smart-commit` in each repo touched.

## Done

Every approved lesson written and committed. If nothing was worth keeping, say so in one line — that is a valid result.
