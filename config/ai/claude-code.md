# Claude Code — Conventions

Rules for AI agents working in my projects. Only non-obvious constraints and personal preferences live here — modern agents don't need generic coaching.

Identity, tone, and response format are not here. They live in `core.md`, loaded as the `Prime` output style. A rule that appears in both files is a bug — when two instructions disagree, Claude picks one arbitrarily.

## Formatting

- Spaces over tabs, except where the language mandates otherwise (`gofmt`). Width follows the language standard — the language skills carry the specifics.
- Remove trailing whitespace.

## Secrets

Blocked by `permissions.deny` in `settings.json`, so the file list lives there rather than here. When a read is denied: fall back to the example or template file (`.env.example`, `secrets.toml.example`). If none exists, list the expected fields and ask.

## Git

- You handle git: create branches and commit. Push and open PRs only when I ask.
- **On main, ask before the first commit** — offer a feature branch. If I decline, commit to main.
  - With ticket: `<TICKET>-<feature>` (e.g. `MDZ-10-user-authentication`)
  - Without ticket: `<feature>` in kebab-case (e.g. `refactor-orders`)
- **No AI references anywhere in git history.** Branch names must never contain `claude`, `anthropic`, `gpt`, `copilot`, `cursor`, or any other agent or vendor name — this holds even when the word is part of a repo, directory, or file name you are working on. No `Co-Authored-By`, no "Generated with" lines in commits or PR bodies.
- Commit through the `smart-commit` skill: small, focused commits. Imperative mood, explain what and why, no `feat:`/`fix:` prefixes (unless the project already uses them).
- Run the linter and tests before committing.
- Demo apps get no PRs: commit to a feature branch, then merge it into main once the demo works.
- **Merge with a merge commit, never fast-forward or squash** — `git merge --no-ff`, or GitHub's "Create a merge commit" (`gh pr merge --merge`). Branch history should read as "train tracks": the feature branch's commits stay visible on their own rail forking off and rejoining main.

## Code

- YAGNI — smallest change that works. No speculative abstractions, no drive-by refactors.
- Before writing code, stop at the first that holds: not needed (skip it, say so) → already in this codebase → stdlib → native platform feature → installed dependency → only then new code.
- Understand before shrinking: trace the real flow first. The smallest diff in the wrong place is a second bug.
- Bug fixes go at the root cause, where every caller routes through, not only the path the report names.
- Never simplify away validation at trust boundaries, error handling that prevents data loss, security, or accessibility.
- Mark a deliberate corner-cut with a comment naming its ceiling and upgrade path.
- Follow existing project conventions and framework defaults over novel patterns.
- Check existing dependencies (Gemfile, package.json, pyproject.toml, go.mod) before adding new ones; keep lockfiles updated.
- Comments explain "why", never "what". Minimal logging.

## Testing

- **Never delete a failing test to make the suite pass.** Fix the test or fix the code.

Everything else — mocking boundaries, coverage targets, flake hygiene — is in `rules/testing.md`.

## Stack preferences

- **Rails**: Hotwire/Stimulus over heavy JS frameworks; RSpec + FactoryBot.
- **JavaScript**: vanilla-first; TypeScript only if the project already uses it.
- **Python**: stdlib-first; `uv` for environments, `ruff` for lint + format, `pytest`.
- **Go**: stdlib-first; `gofmt`/`goimports`, `go vet`, `staticcheck`.

Detailed conventions are in `rules/` (Claude Code loads each one when it reads a matching file; other agents should read the relevant `rules/<name>.md` when working in that language).

## MCP servers

- `context7` is installed but opt-in: never call it unless I explicitly ask for it (e.g. "use context7", "check the docs via context7").

## Project docs (`docs/plans/`)

One doc per feature in `docs/plans/` at the project root: `docs/plans/<feature>.md`, lowercase-hyphen (`user-auth.md`). Three sections: Goal, Decisions (with the options rejected and why), Tasks.

Tasks are checkboxes in that doc, and ticking one is the progress record. There is no separate task file.

**On session start**, if a doc in `docs/plans/` has unchecked tasks, read it and resume from the first unchecked one.

Tracked by default. A repo that wants its planning docs kept out of version control adds `docs/plans/` to its own `.gitignore`.

## Architecture (`docs/architecture.html`)

Every project gets one: a single self-contained HTML file covering the system's components, how data flows between them, and the decisions behind the shape — including the options rejected and why.

- **Self-contained.** Inline all CSS, JS, and diagrams. No CDN links, no external fonts or images. It has to render correctly opened straight from disk with `open docs/architecture.html`, offline.
- Diagram the parts that are hard to hold in your head — request paths, service boundaries, data lifecycles. Inline SVG, since a CDN-loaded diagram library breaks the offline requirement.
- Keep it current as the architecture changes. A stale diagram is worse than none.
- Local only. Never publish or upload it unless I ask.
