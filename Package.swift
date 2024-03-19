// swift-tools-version: 5.9

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

let package = Package(
  name: "SimulatorServices",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .watchOS(.v9),
    .macCatalyst(.v16),
    .tvOS(.v16),
    .visionOS(.v1)
  ],
  products: [
    .library(
      name: "SimulatorServices",
      targets: ["SimulatorServices"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/brightdigit/OperatingSystemVersion.git",
      from: "1.0.0-beta.1"
    )
  ],
  targets: [
    .target(
      name: "SimulatorServices",
      dependencies: ["OperatingSystemVersion"],
      swiftSettings: [
        SwiftSetting.enableUpcomingFeature("BareSlashRegexLiterals"),
        SwiftSetting.enableUpcomingFeature("ConciseMagicFile"),
        SwiftSetting.enableUpcomingFeature("ExistentialAny"),
        SwiftSetting.enableUpcomingFeature("ForwardTrailingClosures"),
        SwiftSetting.enableUpcomingFeature("ImplicitOpenExistentials"),
        SwiftSetting.enableUpcomingFeature("StrictConcurrency"),
        SwiftSetting.enableUpcomingFeature("DisableOutwardActorInference"),
        SwiftSetting.enableExperimentalFeature("StrictConcurrency")
      ]
    ),
    .testTarget(
      name: "SimulatorServicesTests",
      dependencies: ["SimulatorServices"]
    ),
    .testTarget(
      name: "SimulatorServicesIntegrationTests",
      dependencies: ["SimulatorServices"]
    )
  ]
)
// swiftlint:enable explicit_acl explicit_top_level_acl
