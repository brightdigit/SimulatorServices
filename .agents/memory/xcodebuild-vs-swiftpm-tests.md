# xcodebuild vs SwiftPM test runs

CI tests this package two ways: `swift test` (SPM lanes, Linux) and `xcodebuild test` (the swift-build action's `type:` lanes for macOS, iOS, watchOS, tvOS and visionOS). A green `swift test` doesn't mean the xcodebuild lanes will pass. Failures seen so far (2026-11-25, PR #29):

- **Test resources.** `.copy("Resources")` puts a top-level `Resources/` folder into the test bundle. On the iOS-family simulators codesign then rejects the bundle ("bundle format unrecognized, invalid, or unsuitable"). Copy the subfolders instead (`Resources/simctl`, `Resources/xcode`) and look fixtures up without the `Resources/` prefix.
- **Availability.** xcodebuild compiles the tests for each platform's minimum, so test helpers can't use APIs above iOS 16 / watchOS 9 / tvOS 16 (for example `Mutex`). `swift test` on macOS 15.4+ never notices. Use `NSLock`, or keep the helper `#if os(macOS)`.
- **Inherited environment.** `xcodebuild test` injects `DYLD_*`, `__XPC_DYLD_*`, `XCTest*` and `XCInjectBundle*` into the test process. If they're passed on to `simctl`, `Subprocess.run` failed with `CancellationError` on the `xcode-27` runner (not locally). `SubprocessCommandRunner` strips them from every child's environment (`removingInjectedVariables`).

Before pushing anything that touches tests, resources or process launching, also run `xcodebuild build-for-testing -scheme SimulatorServices -destination 'generic/platform=iOS Simulator'` and `xcodebuild test -scheme SimulatorServices -sdk macosx -destination platform=macOS`.
