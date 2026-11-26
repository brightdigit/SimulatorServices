# `simctl runtime list -j`: Xcode 27.2 (27B52)

Recorded 2026-10-30 on a Mac with the Xcode 27.2 final selected. Copied from Stewed's `docs/fixtures/simctl/` (brightdigit/Stewed#123); `SimctlSnapshotTests` reads it here for `hardwareNames`.

It holds both the 27.2 RC and final runtimes for every platform, plus the iPhone Duo's own final runtime (`iOS-27-2-iPhone19-4`, build `24B91016s`).

`list-iphone-duo-runtime.json` holds the `runtimes` entry for `iOS-27-2-iPhone19-4` from `simctl list -j runtimes`, recorded 2026-11-04 on a Mac with Xcode 27.2. It's wrapped in empty `devicetypes`, `devices` and `pairs` so it decodes as a `simctl list -j` result. The entry has `name` "iOS 27.2", the same as the general runtime, and exactly one supported device type, "iPhone Duo".
