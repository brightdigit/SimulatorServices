# Stewed subrepo

Stewed (brightdigit/Stewed) vendors this repo with `git subrepo` at `Packages/SimulatorServices`. Its `.gitrepo` file has `branch = simulator` and a `commit` naming the upstream tip it last synced with.

- Day-to-day library changes happen inside Stewed's subrepo. The maintainer pushes them upstream to `simulator` only as the last step before a Stewed version branch merges into `main`.
- Before `simulator` merges into this repo's `main` and is tagged, it gets rebased onto `main`. A rebase rewrites the commit that Stewed's `.gitrepo` names. Afterwards, run `git subrepo pull --force Packages/SimulatorServices` on a Stewed branch so `.gitrepo` points at the new tip; otherwise Stewed's next `git subrepo push` fails.
- First done on 2026-11-25: PR #29 was rebased onto `main` and the CI scaffolding was rebuilt here (Swift 6.4, `xcode-27`).
