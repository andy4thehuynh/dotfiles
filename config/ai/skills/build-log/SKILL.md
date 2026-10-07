---
name: build-log
description: Maintains a project's append-only build log (docs/build-log.md) with dated entries and verification evidence — the audit trail and observability record for infrastructure and agent work. Use when starting or completing any task in a project that has a build-log.md (check docs/), when the user says "log it", "document this in the build log", "audit trail", or at every meaningful milestone in homelab/infra work even if not asked. Also use when a project lacks a build log and the user wants observability conventions established.
---

# Build Log — audit trail and observability discipline

A project's history must be reconstructible from its docs alone. The build log is the append-only record that makes that true.

## The file

Location: `docs/build-log.md` in the project root (create on first use with the header below). If the project already has one, never start a second file.

```markdown
Last updated: YYYY-MM-DD HH:MM TZ

# <Project> — build log & audit trail

Chronological, append-only. Entries are never edited after being written; corrections are new entries referencing the old one. Current-state summary lives in a separate doc (e.g. flip-report, architecture doc); this log is the history authority.

## Entry N — YYYY-MM-DD: <one-line title>
- What was changed (commands/config paths, not full transcripts)
- Verification evidence (the probe output or exit code that proves it — "it works" is not evidence)
- Gotchas hit & how they were resolved
- Secrets: NEVER. Reference file paths and permission modes only.

## Open items (blocked / queued)
- Reordered when status changes; struck through or moved to a "Done" note when closed.
```

## When to write entries

Write an entry at each of these moments:
1. **Access/credential changes** — keys, sudoers, authorized_keys, capability registrations.
2. **Resource provisioning or destruction** — VMs, containers, volumes, services.
3. **Config changes with security or availability impact** — model endpoints, firewalls, egress, service units.
4. **State transfers** — anything copied/migrated between machines.
5. **Incidents + fixes** — anything that broke and was fixed (the `restrict`/PTY class of lesson; the "why" is the value).
6. **Verification milestones** — gate/checkpoint results (pass or fail).

If a session does none of these, no entry. If a session does several, one entry per logical unit of work is fine.

## Key insights to capture (observability value)

Each entry should answer, briefly:
- **What probes exist to watch this?** (the command(s) that verify health — they become the monitoring playbook)
- **What signals would indicate regressions?** (gotchas encode failure modes)
- **What depends on this?** (so future changes know their blast radius)

Maintain a `## Verification probes` section near the top of the log listing the one-liner health checks discovered so far (e.g. `ssh nous 'sudo -n qm guest exec 105 -- /bin/sh -c "systemctl is-active docker"'`), each with what "good" output looks like. This is the project's monitoring checklist.

## Rules

- Append-only: corrections are new entries ("Fix to Entry 3: ..."), never rewrites. Git history may not exist for this repo; the log is the history.
- Evidence required: every claim of "working" includes the probe that proved it.
- Dated headers on ALL project docs; `build-log.md` = history authority, current-state doc = present authority. When they conflict, trust the log's latest entry and fix the state doc.
- Secrets by reference only (paths, modes), never values.
- User-visible summaries at end of session reference entry numbers.

## Housekeeping

- Update `Last updated:` header on every append.
- Keep `Open items` current — blocked items name the blocker and who unblocks.
- If the log exceeds ~500 lines, start archiving by moving closed entries to `docs/build-log-archive-<year>.md` with a pointer at top.