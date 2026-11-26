//
//  RuntimeImageTests.swift
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

internal final class RuntimeImageTests: XCTestCase {
  // No recorded fixture has a `deletable: false` runtime or a `Deleting` state yet,
  // so these entries are hand-written from recorded ones.
  private static func image(
    deletable: Bool = true,
    kind: String = "Patchable Cryptex Disk Image",
    state: String = "Ready",
    sizeBytes: Int = 8_067_000_161
  ) throws -> RuntimeImage {
    let json = """
      {
        "build": "24A434",
        "deletable": \(deletable),
        "identifier": "11111111-1111-1111-1111-111111111111",
        "kind": "\(kind)",
        "path": "/Library/Developer/CoreSimulator/Images/1.dmg",
        "platformIdentifier": "com.apple.platform.iphonesimulator",
        "runtimeIdentifier": "com.apple.CoreSimulator.SimRuntime.iOS-27-0",
        "sizeBytes": \(sizeBytes),
        "state": "\(state)",
        "version": "27.0"
      }
      """
    return try JSONDecoder().decode(RuntimeImage.self, from: Data(json.utf8))
  }

  internal func testBundledWithXcode() throws {
    let image = try Self.image(deletable: false)
    XCTAssertTrue(image.isBundledWithXcode)
    XCTAssertFalse(image.canDelete)
    XCTAssertNil(image.signatureState)
    XCTAssertNil(image.lastUsedAt)
    XCTAssertNil(image.mountPath)

    let kind = try Self.image(kind: "Bundled with Xcode")
    XCTAssertEqual(kind.kind, .bundledWithXcode)
    XCTAssertTrue(kind.isBundledWithXcode)
    XCTAssertFalse(kind.canDelete)
  }

  internal func testPendingDelete() throws {
    let image = try Self.image(state: "Deleting")
    XCTAssertEqual(image.state, .deleting)
    XCTAssertTrue(image.isPendingDelete)
    XCTAssertFalse(image.canDelete)
  }

  internal func testUnknownKindAndState() throws {
    let image = try Self.image(kind: "Future Kind", state: "Future State")
    XCTAssertEqual(image.kind, .unknown("Future Kind"))
    XCTAssertEqual(image.state, .unknown("Future State"))
    XCTAssertFalse(image.isPendingDelete)
    XCTAssertFalse(image.canDelete)
  }

  internal func testDescriptions() {
    XCTAssertEqual(RuntimeImageState.ready.description, "Ready")
    XCTAssertEqual(RuntimeImageState.deleting.description, "Deleting")
    XCTAssertEqual(RuntimeImageState.unknown("Other").description, "Other")
    XCTAssertEqual(RuntimeImageKind.legacyDownload.description, "Legacy Download")
    XCTAssertEqual(RuntimeImageKind.bundledWithXcode.description, "Bundled with Xcode")
  }

  internal func testLastUsedAt() throws {
    let images = try RuntimeListFixture.xcode271RuntimeDelete.images()
    let image = try images.image("32BC621C-11BD-4AC2-924C-E7C30C7B8633")
    XCTAssertEqual(
      image.lastUsedAt,
      ISO8601DateFormatter().date(from: "2025-08-28T16:17:57Z")
    )
  }

  internal func testFixturesHaveNoUnknownValues() throws {
    for fixture in RuntimeListFixture.allCases {
      let images = try fixture.images()
      XCTAssertEqual(images.compactMap { $0.state.unknownValue() }, [], fixture.rawValue)
      XCTAssertEqual(images.compactMap { $0.kind.unknownValue() }, [], fixture.rawValue)
      XCTAssertEqual(
        images.compactMap { $0.platform.unknownValue() },
        [],
        fixture.rawValue
      )
    }
  }

  internal func testReportedSizeIgnoresADirectoryEntry() throws {
    XCTAssertEqual(try Self.image().reportedSizeBytes, 8_067_000_161)
    XCTAssertNil(try Self.image(sizeBytes: 128).reportedSizeBytes)
    XCTAssertEqual(
      try Self.image(sizeBytes: RuntimeImage.minimumPlausibleSizeBytes).reportedSizeBytes,
      RuntimeImage.minimumPlausibleSizeBytes
    )
  }
}
