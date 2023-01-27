// swift-tools-version: 5.5

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

let package = Package(
  name: "SimulatorServices",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [
    .library(
      name: "SimulatorServices",
      targets: ["SimulatorServices"]
    )
  ],
  targets: [
    .target(
      name: "SimulatorServices",
      dependencies: []
    ),
    .testTarget(
      name: "SimulatorServicesTests",
      dependencies: ["SimulatorServices"]
    )
  ]
)
