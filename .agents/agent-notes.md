# Agent notes

A running log of the maintainer's corrections and standing always/never directives for this repo.

- **Read this file at the start of every session, before doing any work.**
- **Append proactively, without being asked:** whenever the maintainer corrects you or gives an always/never instruction, add one line here.
- One line per entry. Newest lines at the bottom.
- When a directive supersedes an earlier one, update or remove the stale line rather than leaving both.

Project facts that aren't directives (decisions, constraints, gotchas) go in `.agents/memory/` instead; see `.agents/memory/MEMORY.md`.

---

- 2026-11-04: Use typed throws (`throws(SomeError)`) everywhere; the only exception is a protocol witness whose body must call untyped-throwing APIs.
- 2026-11-04: SimulatorServices targets Swift 6.4 (swift-tools-version 6.4), like Stewed's app packages.
- 2026-11-19: Keep the macOS minimum at the lowest the code needs (currently 15.4); it may go as high as macOS 26.
- 2026-11-24: Never add Codecov (or any other coverage upload); no codecov.yml, upload steps or badges.
- 2026-11-25: Never add CodeFactor, Code Climate or other third-party code-quality integrations or badges.
- 2026-11-25: GitHub Actions workflows run on `pull_request` (plus `workflow_dispatch`), never also on `push`.
- 2026-11-25: Library code changes are made in Stewed's `Packages/SimulatorServices` subrepo and pushed upstream from there. Repo-level CI and scaffolding may be changed here directly, followed by a Stewed `git subrepo pull --force`.
- 2026-11-25: The maintainer rebases `simulator` onto `main` before merging and tagging.
