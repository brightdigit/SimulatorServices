// swift-tools-version: 6.4

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

let package = Package(
  name: "SimulatorServices",
  platforms: [
    .iOS(.v16),
    // 15.4 for `isolated deinit` (FSEventsPathWatch).
    .macOS("15.4"),
    .watchOS(.v9),
    .macCatalyst(.v16),
    .tvOS(.v16),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "SimulatorServices",
      targets: ["SimulatorServices"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/brightdigit/OSVer.git",
      from: "1.0.0"
    ),
    // Runs xcrun, simctl, xcode-select and mdfind (macOS only).
    .package(
      url: "https://github.com/swiftlang/swift-subprocess.git",
      from: "1.0.2"
    ),
  ],
  targets: [
    .target(
      name: "SimulatorServices",
      dependencies: [
        "OSVer",
        .product(
          name: "Subprocess",
          package: "swift-subprocess",
          condition: .when(platforms: [.macOS])
        ),
      ],
      swiftSettings: [
        // Swift 6 mode already includes the other upcoming features.
        SwiftSetting.enableUpcomingFeature("ExistentialAny")
      ]
    ),
    .testTarget(
      name: "SimulatorServicesTests",
      dependencies: ["SimulatorServices"],
      // Copy the fixture folders, not `Resources` itself: a top-level
      // `Resources` folder makes codesign reject the iOS-family test bundle.
      resources: [
        .copy("Resources/simctl"),
        .copy("Resources/xcode"),
      ]
    ),
    .testTarget(
      name: "SimulatorServicesIntegrationTests",
      dependencies: ["SimulatorServices"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
// swiftlint:enable explicit_acl explicit_top_level_acl
