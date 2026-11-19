# Xcode discovery fixtures: Xcode 27.2 (27B48), macOS 27.2 (26B123)

Recorded 2026-10-29 for Stewed (brightdigit/Stewed#33), moved here with the Xcode discovery types (brightdigit/Stewed#123). `XcodeToolOutputTests` and `XcodeInstallationBundleTests` read it. Only `/Applications/Xcode.app` was installed, with the Command Line Tools in `/Library/Developer/CommandLineTools`.

| File | Source | Exit |
|---|---|---|
| `xcode-select-p.stdout` | `xcode-select -p` with `DEVELOPER_DIR` unset | 0 |
| `xcode-select-p-developer-dir.stdout` | `DEVELOPER_DIR=/Library/Developer/CommandLineTools xcode-select -p` | 0 |
| `mdfind-xcode.stdout` | `mdfind "kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'"` | 0 |
| `version.plist` | `/Applications/Xcode.app/Contents/version.plist`, verbatim | |
| `Info.plist` | `/Applications/Xcode.app/Contents/Info.plist`, **trimmed** to the four keys below and converted from binary to XML | |

Seen on this Mac:

- `xcode-select -p` prints `DEVELOPER_DIR` when it's set, so a locator clears it to read the system-wide choice.
- `Info.plist` says `DTXcodeBuild` `27B47`, while `version.plist` says `ProductBuildVersion` `27B48`. `XcodeInstallation(bundleAt:infoPlist:versionPlist:)` prefers `version.plist`.
- `/var/db/xcode_select_link` pointed at `/Applications/Xcode-beta.app/Contents/Developer`, which no longer existed, yet `xcode-select -p` printed `/Applications/Xcode.app/Contents/Developer`. So read the selection with `xcode-select -p`, not the link; the link is only watched for changes.
- With `DEVELOPER_DIR=/Library/Developer/CommandLineTools`, `xcrun --find simctl` exits **72** with stderr `xcrun: error: unable to find utility "simctl", not a developer tool or in PATH`.
