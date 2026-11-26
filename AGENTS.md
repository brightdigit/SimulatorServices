# CLAUDE.md

Guidance for Claude Code and other agents working in this repository.

## What this is

SimulatorServices is a Swift package for driving Apple's simulators and finding Xcode installs. It covers:

- `simctl` commands (`SimCtl`, `Subcommand`, and the command types in `Commands/`) and their decoded models (`Components/`);
- the `SimCtlCommands` / `SimCtlDeletionCommands` seam, with `LiveSimCtlCommands` as the live implementation;
- `SimctlSnapshot`, `SimulatorAttribution`, and version parsing (`Versions/`);
- Xcode discovery and resolution (`Xcode/`), including the live `XcodeLocator` and its FSEvents watcher.

It has one library product and one target, `SimulatorServices`. Its dependencies are OSVer, and swift-subprocess on macOS only.

**Its main consumer is Stewed.** Stewed vendors this repo as a git subrepo at `Packages/SimulatorServices`, tracking the `simulator` branch.

## Rules

- **Typed throws everywhere**, e.g. `throws(SimCtlError)`. The only exceptions are protocol witnesses whose body calls untyped-throwing APIs.
- Swift 6.4 (`swift-tools-version: 6.4`), Swift 6 language mode and `ExistentialAny`. Public types are `Sendable`.
- **Keep the platform minimums low.** The macOS minimum is the lowest the code needs, currently 15.4 for `isolated deinit` in `FSEventsPathWatch`. It may go as high as macOS 26, but only when the code requires it.
- **Linux must keep building.** Anything that runs `xcrun`, `simctl`, `xcode-select` or `mdfind`, or that uses FSEvents, belongs behind `#if os(macOS)`. Keep the `Subprocess` product conditioned to macOS in `Package.swift`.
- **Write value mappings as data, not `switch`es:** a `BidirectionalMap` for two-way mappings, a dictionary or set for one-way. Every `RawDefined` type is `RawMapped` with a single `rawOptions` table.
- **New simulator hardware:** add the identifier to `DeviceTypeID` in three places: the case, the `RawAvailableOptions` raw value, and the `rawOptions` row. `DeviceTests.testSimCtlList` fails on any device type it doesn't know.
- **No swift-docc-plugin in `Package.swift`.** Every dependent package would resolve it. Build docs with `Scripts/docc.sh` instead.
- Every public symbol has a doc comment (swift-format's `AllPublicDeclarationsHaveDocumentation`). Each source file carries the MIT header; run `make headers` to add or refresh it.

## Commands

```bash
swift build
swift test             # XCTest + Swift Testing; integration tests run the real simctl on macOS
make lint              # Scripts/lint.sh (tools pinned in mise.toml; run `mise install` once)
make format            # format in place only
make docs              # DocC with --warnings-as-errors; output in .build/docs
make docs-preview
```

`Scripts/lint.sh` works like this:

- Outside CI it first formats in place (swift-format, `swiftlint --fix`).
- It then runs swift-format and SwiftLint in strict mode, `swift build --build-tests` (locally only), and the header script.
- It runs periphery locally if it's installed.
- In Claude Code web sessions (`CLAUDE_CODE_REMOTE=true`) it skips mise, SwiftLint and periphery.

## CI

GitHub Actions workflows trigger on `pull_request` and `workflow_dispatch`, never on `push`. The exceptions are a weekly CodeQL schedule, branch deletion for cache cleanup, and issue and review-comment events for `claude.yml`. PRs into `main` or a semver branch get the full Apple-platform matrix.

- The manifest needs Swift 6.4, so:
  - Linux lanes use the `swift:6.4-<os>` images;
  - Apple lanes and CodeQL use the `xcode-27` runner image with `/Applications/Xcode_27.2.app`.
- Simulator device names must exist on that image's runtimes. Check `actions/runner-images`' `xcode-27-arm64-Readme.md` before changing them.
- The lint job runs on `ubuntu-24.04`: SwiftLint's Linux binary needs `libxml2.so.2`.
- CodeQL builds with `swift build --disable-sandbox`. Under the CodeQL tracer, the manifest sandbox fails with "Bad CPU type in executable".
- No Codecov, CodeFactor or other third-party code-quality services.
- Swift Package Index builds the published docs (`.spi.yml`).

## Tests

- `Tests/SimulatorServicesTests` mixes XCTest and Swift Testing suites.
- Recorded `simctl` and Xcode output lives in `Tests/SimulatorServicesTests/Resources/` (`simctl/xcode-<version>-<build>/`). It mirrors Stewed's `docs/fixtures/simctl/`, and Stewed's tests check the copies match. Re-record fixtures rather than hand-editing them.
- `Tests/SimulatorServicesIntegrationTests` runs against the machine's real `simctl` (macOS only).

## Memory & Corrections Convention

`AGENTS.md` and `.agents/` are the real files. `CLAUDE.md` and `.claude` are symlinks to them, so Claude Code finds them too. Edit the real paths, and don't replace a symlink with a copy.

These two files are the source of truth for how to work in this repo. Both are committed to git.

- **`.agents/agent-notes.md`**: an append-only log of the maintainer's corrections and standing always/never directives, one line each, newest at the bottom.
- **`.agents/memory/`**: this project's memory store. It holds one markdown file per project-scoped fact (decisions, constraints, gotchas, context not derivable from the code or git history), indexed in `.agents/memory/MEMORY.md`.

Rules:

1. Read `.agents/agent-notes.md` and `.agents/memory/MEMORY.md` before doing any work.
2. Append to them proactively, without being asked: a line in `agent-notes.md` for every correction or always/never instruction, and a memory file plus index line for every project fact worth keeping.
3. When a directive or memory is superseded or wrong, update or delete the stale entry rather than leaving both.
4. Never store project-scoped memories in a native or global memory system (such as Claude Code's `~/.claude/projects/<project>/memory/`). They belong in the repo so they're versioned and visible to every person and agent working here.
