//
//  SimctlSnapshotTests.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import Testing

@testable import SimulatorServices

/// The parts of a `simctl` read that don't depend on how an app shows it,
/// against recorded fixtures.
@Suite
internal struct SimctlSnapshotTests {
  private static let first = "xcode-27.1-27A9275"
  private static let runtimeDelete = "xcode-27.1-27A9275-runtime-delete"
  private static let xcode272 = "xcode-27.2-27B52"

  /// A `simctl list -j` result with no runtimes, as when `simctl list`
  /// doesn't report an image's runtime.
  private static func emptyList() throws -> SimulatorList {
    let json = #"{"devicetypes":[],"runtimes":[],"devices":{},"pairs":{}}"#
    return try List().parse(Data(json.utf8))
  }

  /// Cryptex directories report 128 bytes, so they need measuring.
  @Test
  internal func cryptexDirectoriesNeedMeasurement() throws {
    let snapshot = try SimctlSnapshotFixture.snapshot(Self.first)
    let measured = snapshot.imagesNeedingMeasurement.map(\.identifier.uuidString)
    #expect(measured.count == 5)
    #expect(snapshot.images.filter { $0.sizeBytes == 128 }.count == 5)
    #expect(measured.contains("6B805CEC-8273-4E93-A59B-CF905C21EC91"))
  }

  @Test
  internal func diskImagesDontNeedMeasurement() throws {
    let snapshot = try SimctlSnapshotFixture.snapshot(Self.runtimeDelete)
    #expect(snapshot.images.count == 30)
    #expect(snapshot.imagesNeedingMeasurement.isEmpty)
  }

  /// The iPhone Duo's own runtime (`iOS-27-2-iPhone19-4`) is named for the
  /// one device type `simctl list -j` gives it.
  @Test
  internal func aVariantIsNamedForItsDevice() throws {
    let snapshot = try SimctlSnapshotFixture.snapshot(
      Self.xcode272,
      list: "list-iphone-duo-runtime.json"
    )
    let duo = try #require(snapshot.images.first { $0.build == "24B91016s" })
    #expect(duo.runtimeIdentifier.variant == "iPhone19-4")
    #expect(snapshot.hardwareNames == [duo.identifier: "iPhone Duo"])
  }

  @Test
  internal func aVariantNotInTheListIsNamedByItsIdentifier() throws {
    let images = try SimctlSnapshotFixture.images(Self.xcode272)
    let snapshot = SimctlSnapshot(images: images, list: try Self.emptyList())
    let duo = try #require(images.first { $0.build == "24B91016s" })
    #expect(snapshot.hardwareNames == [duo.identifier: "iPhone19-4"])
  }

  /// Xcode 27.1's iPhone Duo runtimes use the general `iOS-27-1`
  /// identifier, so only their device-train builds and single supported
  /// device type mark them. visionOS also supports one device type, but its
  /// builds aren't a device train, so it stays general.
  @Test
  internal func deviceTrainBuildsWithOneDeviceTypeAreHardwareSpecific() throws {
    let snapshot = try SimctlSnapshotFixture.snapshot(Self.runtimeDelete)
    let names = snapshot.hardwareNames
    let duo = snapshot.images.filter { ["24A94232", "24A94401"].contains($0.build) }
    #expect(duo.count == 2)
    #expect(names.count == 2)
    #expect(duo.allSatisfy { names[$0.identifier] == "iPhone Duo" })
    let visionOS = snapshot.images.filter { $0.platform == .xrOS }
    #expect(!visionOS.isEmpty)
    #expect(visionOS.allSatisfy { names[$0.identifier] == nil })
  }

  @Test
  internal func runtimeIDDisplayName() throws {
    let snapshot = try SimctlSnapshotFixture.snapshot(Self.first)
    let identifiers = Set(snapshot.list.devices.keys)
    let iOS = try #require(identifiers.first { $0.suffix == "iOS-27-1" })
    #expect(iOS.displayName == "iOS 27.1")
    let duo = try RuntimeID(suffix: "iOS-27-2-iPhone19-4")
    #expect(duo.displayName == "iOS 27.2")
    #expect(try RuntimeID(suffix: "xrOS-2-5").displayName == "visionOS 2.5")
  }
}
