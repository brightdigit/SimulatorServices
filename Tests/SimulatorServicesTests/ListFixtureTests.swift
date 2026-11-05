//
//  ListFixtureTests.swift
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
import XCTest

@testable import SimulatorServices

/// Decodes `simctl list -j` output recorded with Xcode 27.1 (27A9275)
/// on macOS 27.0.1, copied from Stewed's `docs/fixtures/simctl/`.
internal final class ListFixtureTests: XCTestCase {
  private static func list(_ recording: String) throws -> SimulatorList {
    let url = try XCTUnwrap(
      Bundle.module.url(
        forResource: "list",
        withExtension: "json",
        subdirectory: "Resources/simctl/\(recording)"
      )
    )
    return try List().parse(Data(contentsOf: url))
  }

  private static func device(_ udid: String, in list: SimulatorList) throws -> Device {
    try XCTUnwrap(
      list.devices.values.joined().first { $0.udid.uuidString == udid }
    )
  }

  internal func testParseXcode271() throws {
    let list = try Self.list("xcode-27.1-27A9275")
    let devices = Array(list.devices.values.joined())

    XCTAssertEqual(list.runtimes.count, 14)
    XCTAssertEqual(devices.count, 52)
    // Every device reports its data size; only used ones report lastUsedAt.
    XCTAssert(devices.allSatisfy { $0.dataPathSize != nil })
    XCTAssertEqual(devices.compactMap(\.lastUsedAt).count, 19)
    // simctl never reports lastBootedAt.
    XCTAssert(devices.allSatisfy { $0.lastBootedAt == nil })
    XCTAssert(devices.allSatisfy { $0.availabilityError == nil })
  }

  internal func testParseLastUsedAt() throws {
    let list = try Self.list("xcode-27.1-27A9275")
    let used = try Self.device("3E965CE7-0A8B-4F41-B558-6A9BA7933BE2", in: list)

    XCTAssertEqual(used.name, "iPhone Duo")
    XCTAssertEqual(used.dataPathSize, 2_538_086_400)
    XCTAssertEqual(
      used.lastUsedAt,
      try Date("2026-10-16T17:33:41Z", strategy: .iso8601)
    )

    let unused = try Self.device("971C66B1-C447-4C20-9B98-039BDB61C4F1", in: list)
    XCTAssertEqual(unused.dataPathSize, 4_096)
    XCTAssertNil(unused.lastUsedAt)
  }

  internal func testParseUnsupportedRuntimes() throws {
    let list = try Self.list("xcode-27.1-27A9275-runtime-delete")
    let unavailable = list.runtimes.filter { !$0.isAvailable }

    XCTAssertEqual(list.runtimes.count, 30)
    XCTAssertEqual(
      Set(unavailable.map(\.identifier.description)),
      [
        "com.apple.CoreSimulator.SimRuntime.iOS-15-5",
        "com.apple.CoreSimulator.SimRuntime.iOS-16-0",
        "com.apple.CoreSimulator.SimRuntime.watchOS-8-5",
        "com.apple.CoreSimulator.SimRuntime.watchOS-9-4",
      ]
    )
    let iOS16 = try XCTUnwrap(
      unavailable.first { $0.identifier.description.hasSuffix("iOS-16-0") }
    )
    XCTAssertEqual(
      iOS16.availabilityError,
      "The iOS 16.0 simulator runtime is not supported on hosts after macOS 26.99.99."
    )
    let available = list.runtimes.filter(\.isAvailable)
    XCTAssert(available.allSatisfy { $0.availabilityError == nil })
  }
}
