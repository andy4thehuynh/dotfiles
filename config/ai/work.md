Solutions Engineer at Couchbase, West Enterprise SE team.
Focus: AI workloads — vector search, RAG, agent memory.
~10 years Rails — engineering fluency assumed.
Audience: enterprise architects, AI/platform teams, AI executives.

Explain AI and Couchbase concepts from fundamentals unless I say otherwise.

"need adult" = simplify:
- Plain language, no jargon
- One concrete example
- Anchor to a Rails equivalent where one exists

Guardrails:
- Don't invent SQL++ syntax or API surface — verify against docs
- Don't invent account facts — ask or leave a placeholder
- No perf numbers or benchmarks without a cited source

## ~/cbme — Knowledge Base

This repo is notes, not code: accounts, people, projects, admin. Demo code
repos live in `~/src/couchbase/demos/` and are linked from here, never nested.

Private personal repo (`andy4thehuynh/work`) — accept that customer material
lives here. `assets/` (decks, PDFs, recordings) is gitignored; those live in
Google Drive and are linked by URL, not committed. `_inbox/` is a gitignored
drop folder for raw material (transcripts, PDFs) waiting to be distilled into
notes — never a permanent home.

### Layout

```
accounts/<slug>/README.md        account facts + ## Current state + ## Tasks
accounts/<slug>/CLAUDE.md        thin, instructions only, imports @README.md
accounts/<slug>/notes/           dated notes, see filename convention below
accounts/<slug>/assets/          gitignored — decks, PDFs, local scratch
accounts/<slug>/projects/<proj>/ nested project, same shape as an account
people/<slug>.md                 single file, never a folder (see below)
admin/                           SE role material, enablement, internal 1:1s
admin/notes/                     internal-only meeting notes
library/                         reusable demo/reference assets
templates/                       scaffold for each entity type
accounts/README.md               rollup: account list, worth-knowing, dates
admin/README.md                  rollup of internal work, tasks, and dates
bin/                             scripts; each opens with a comment: what, how to run
docs/solutions/                  SE lessons that carry across accounts, via /compound
_inbox/                          gitignored drop folder, not a record
```

### Compounding

When a session changed an account or person file, offer `/compound` once
before wrapping up. One line; the user decides.

### Account index format

An account file is the index you read before a call, so every fact in it must
be traceable.

- **Cite every fact** with a footnote, `[^key]`, defined under `## Sources` as
  `System — what, YYYY-MM-DD. [link](url)`. Systems: Gmail, Slack, Calendar,
  Drive, SFDC, a linked note, or "Andy, in conversation".
- **Inference is marked `[unverified]`.** Never state a guess as a fact.
- **`## Current state` opens with `_As of YYYY-MM-DD._`** so staleness shows,
  then one bullet per source, so each line traces to one place.
- **`## Key dates`** is a Date / What / Source table of upcoming and recent
  dates.
- **Fact-check before committing.** Run the `fact-checker` agent
  (`.claude/agents/fact-checker.md`) on the diff of any account, admin, or
  people file, and fix what it flags first.

### Rollups

`accounts/README.md` is the view across every account. It has a hand-written
"Worth knowing now" section, and a generated section between
`<!-- generated:start -->` and `<!-- generated:end -->`. The generated section
lists the accounts and every `## Key dates` row, sorted by date. A date lives
in its account file; the rollup only copies it. Rebuild after any Key dates
change with `bin/rollup`, and never edit a date only in the rollup.

`admin/README.md` does the same for internal work: tasks, open threads such
as IT tickets, and its own Key dates.

### Frontmatter schema

Every field is optional — a missing field is fine, an invented field name is not.
Add fields here first, then use them; don't invent one inline in a file.

**account**
```yaml
type: account
name: NOV Inc.        # full legal/formal name
slug: nov
industry:
status: active         # active | prospect | closed
ae:                    # account executive
csm:
opportunities: []      # SFDC opportunity ids/links, join key back to SFDC
city: Houston
state: Texas
services: [Data, Query, Index]   # Couchbase services in use
sdks: [Python, Go]
use_cases: [RigDocs, OneChat]    # named use cases — see below
website: https://example.com/
```

`use_cases` is the searchable index of the account's named use cases: short
names only ("RigDocs", "OneChat", "The Operator"), never sentences. It does not
replace the `### Use cases` prose under `## Workstreams` — that stays as the
narrative. An account with no named use case gets `use_cases: []`; never invent
one to fill the field.

**project** (nested under its account)
```yaml
type: project
name: The Operator
account: nov
stage: poc             # discovery | poc | bake-off | expansion | live
tech: [Couchbase Lite, Sync Gateway]
use_cases: [RigDocs]   # same rules as on an account
status: active
```

**prep-bundle** — a folder of working documents with no lifecycle stage:
material prepared for one session, not an initiative being run. Same folder
shape as a project, nested under its account, but no `stage:`.
```yaml
type: prep-bundle
name: Relational vs NoSQL
account: scottsdale
topic: Relational vs NoSQL
date: 2026-09-14       # the session it was prepared for
status: active         # active | closed
```

**person** — always `people/<slug>.md`, never a folder (link breakage isn't
worth the tidiness). Couchbase colleagues you work with regularly; customer
contacts stay as an inline `## Stakeholders` list in the account file unless
one recurs enough to need cross-account tracking.
```yaml
type: person
name: Jack Harper
company: Couchbase
role: AE
accounts: [nov, fcbh]
```

**note** — one per meeting/session, filed under the entity it's about.
```yaml
type: note
date: 2026-09-11
entity: nov
people: [jack-harper]
kind: internal     # meeting | call | research | sizing | demo | poc | internal
source: drive:<fileId>   # present when ingested from a Gemini transcript
```

### Note filenames

`<entity-slug>-<YYYY-MM-DD>-<title-slug>.md`, e.g. `nov-2026-09-11-internal-sync.md`.
ISO date sorts correctly; the slug makes it unique and self-describing, so a
note is findable by name in Obsidian's quick switcher and in search.

### Account slugs

Short and spoken, not the legal entity: `enhabit` not `advanced-homecare`,
`gohealth` not `norvax`, `ara` not `applied-research-associates`. Full legal
name still lives in `name:`. Folders never move — archive via `status: closed`.

### Links

Relative markdown links, never `[[wikilinks]]`: `[esri](../esri/README.md)`,
`[call notes](notes/esri-2026-09-24-connect.md)`. They're clickable on GitHub,
in Obsidian, and in obsidian.nvim; wikilinks render as plain text on GitHub.
An account or project's main file is `README.md` so GitHub shows it when the
folder is opened. In Obsidian: Settings → Files and links → New link format:
"Relative path to file", and "Use [[Wikilinks]]" off.

### Binaries

Decks, PDFs, recordings are not committed (`assets/` is gitignored). They live
in Google Drive; notes and account files link to the Drive URL. If a deck is
genuinely the deliverable and small, it can go in `library/` uncommitted-free
— ask before making an exception.
