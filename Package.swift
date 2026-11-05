// swift-tools-version: 6.4

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
    )
  ],
  targets: [
    .target(
      name: "SimulatorServices",
      dependencies: ["OSVer"],
      swiftSettings: [
        // Swift 6 mode already includes the other upcoming features.
        SwiftSetting.enableUpcomingFeature("ExistentialAny")
      ]
    ),
    .testTarget(
      name: "SimulatorServicesTests",
      dependencies: ["SimulatorServices"],
      resources: [.copy("Resources")]
    ),
    .testTarget(
      name: "SimulatorServicesIntegrationTests",
      dependencies: ["SimulatorServices"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
// swiftlint:enable explicit_acl explicit_top_level_acl
