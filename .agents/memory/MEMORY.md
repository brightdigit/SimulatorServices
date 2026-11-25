# Project memory

This directory is SimulatorServices's memory store for agents. It's committed to git, so every memory is versioned and visible to the maintainer, teammates and every other agent working here.

**It replaces any native or global memory feature** (Claude Code's `~/.claude/projects/<project>/memory/`, Cursor memories, a knowledge store and so on). Don't save project-scoped memories there; write them here.

## Convention

- One markdown file per project-scoped fact worth remembering: decisions, constraints, gotchas, or context that can't be worked out from the code or git history. Don't record what the code, `AGENTS.md` or git log already says.
- Give each file a short kebab-case name (e.g. `cloudkit-record-name-limit.md`) and add a one-line entry to the index below: `- [Title](file.md): one-line hook`.
- Read this index before doing any work, and open the files that look relevant.
- When a memory turns out to be wrong or outdated, update or delete its file and its index line. Don't leave stale entries.
- Corrections and always/never directives from the maintainer go in `.agents/agent-notes.md`, not here.

## Index

- [Stewed subrepo](stewed-subrepo.md): Stewed vendors this repo at `Packages/SimulatorServices` on `simulator`; re-sync Stewed after any history rewrite here
- [xcodebuild vs SwiftPM test runs](xcodebuild-vs-swiftpm-tests.md): resources, availability and injected env vars that pass `swift test` but fail the xcodebuild lanes
