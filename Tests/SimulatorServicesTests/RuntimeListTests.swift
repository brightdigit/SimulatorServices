//
//  RuntimeListTests.swift
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

internal final class RuntimeListTests: XCTestCase {
  internal func testArguments() {
    XCTAssertEqual(RuntimeList().arguments, ["runtime", "list", "-j"])
  }

  internal func testParseMissingData() {
    XCTAssertThrowsError(try RuntimeList().parse(nil)) { error in
      guard case .unreadableOutput(_, nil) = error as? SimCtlError else {
        XCTFail("Unexpected error: \(error)")
        return
      }
    }
  }

  internal func testParseInvalidJSON() {
    XCTAssertThrowsError(try RuntimeList().parse(Data("[]".utf8))) { error in
      guard case .unreadableOutput(_, .some) = error as? SimCtlError else {
        XCTFail("Unexpected error: \(error)")
        return
      }
    }
  }

  internal func testParseXcode271() throws {
    let images = try RuntimeListFixture.xcode271.images()

    XCTAssertEqual(images.count, 14)
    let identifiers = images.map(\.identifier.uuidString)
    XCTAssertEqual(identifiers, identifiers.sorted())
    XCTAssert(images.allSatisfy { $0.state == .ready })
    XCTAssert(images.allSatisfy(\.deletable))
    XCTAssert(images.allSatisfy(\.canDelete))
    XCTAssertFalse(images.contains(where: \.isBundledWithXcode))
    XCTAssertFalse(images.contains(where: \.isLegacy))
    XCTAssertFalse(images.contains(where: \.isPendingDelete))
  }

  internal func testParseCryptexDirectoryImage() throws {
    let images = try RuntimeListFixture.xcode271.images()
    let beta = try images.image("6B805CEC-8273-4E93-A59B-CF905C21EC91")

    XCTAssertEqual(beta.version, "27.2")
    XCTAssertEqual(beta.build, "24B5089g")
    XCTAssertEqual(beta.runtimeIdentifier, try RuntimeID(suffix: "iOS-27-2"))
    XCTAssertEqual(beta.platform, .iOS)
    XCTAssertEqual(beta.platformIdentifier, "com.apple.platform.iphonesimulator")
    XCTAssertEqual(beta.kind, .patchableCryptexDiskImage)
    // simctl reports the size of the directory entry, not of the runtime.
    XCTAssertEqual(beta.sizeBytes, 128)
    XCTAssertEqual(
      beta.path,
      "/Library/Developer/CoreSimulator/Cryptex/Images/" + beta.identifier.uuidString
    )
    XCTAssertEqual(beta.signatureState, "Unknown")
    XCTAssertEqual(beta.supportedArchitectures, ["arm64"])
    XCTAssertNil(beta.parentIdentifier)
  }

  internal func testParseDiskImage() throws {
    let images = try RuntimeListFixture.xcode271.images()
    let watch = try images.image("A63F348B-E8D7-43D7-9309-276CC6BE5451")

    XCTAssertEqual(watch.platform, .watchOS)
    XCTAssertEqual(watch.kind, .diskImage)
    XCTAssertEqual(watch.sizeBytes, 3_946_536_779)
    XCTAssertEqual(
      watch.path,
      "/Library/Developer/CoreSimulator/Images/A63F348B-E8D7-43D7-9309-276CC6BE5451.dmg"
    )
    XCTAssertEqual(
      watch.mountPath,
      "/Library/Developer/CoreSimulator/Volumes/watchOS_21T575"
    )
  }

  internal func testParseRuntimeDeleteFixture() throws {
    let images = try RuntimeListFixture.xcode271RuntimeDelete.images()

    XCTAssertEqual(images.count, 30)
    XCTAssertEqual(
      Set(images.filter(\.isLegacy).map(\.identifier.uuidString)),
      [
        "C1BED4ED-2818-4628-A185-7DCB1A355510",
        "3ACCAFAA-161A-440B-ADE7-0E9EE536A15A",
      ]
    )
    XCTAssertEqual(images.filter { $0.kind == .cryptexDiskImage }.count, 8)
    XCTAssertEqual(images.filter { $0.kind == .patchableCryptexDiskImage }.count, 16)
    XCTAssertEqual(images.filter { $0.kind == .diskImage }.count, 4)
    XCTAssertEqual(images.filter { $0.platform == .xrOS }.count, 6)
    XCTAssertEqual(images.compactMap(\.lastUsedAt).count, 10)
  }

  internal func testParseLegacyImage() throws {
    let images = try RuntimeListFixture.xcode271RuntimeDelete.images()
    let legacy = try images.image("C1BED4ED-2818-4628-A185-7DCB1A355510")

    XCTAssertEqual(legacy.kind, .legacyDownload)
    XCTAssertFalse(legacy.kind.isDiskImage)
    // simctl says deletable, but a legacy runtime needs admin rights to delete.
    XCTAssertTrue(legacy.deletable)
    XCTAssertFalse(legacy.canDelete)
    XCTAssertFalse(legacy.isBundledWithXcode)
    XCTAssertNil(legacy.mountPath)
    XCTAssertEqual(legacy.sizeBytes, 12_385_398_784)
    XCTAssertEqual(
      legacy.path,
      "/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 15.5.simruntime"
    )
  }

  internal func testParseCryptexImage() throws {
    let images = try RuntimeListFixture.xcode271RuntimeDelete.images()
    let cryptex = try images.image("12E6FA95-0AC6-42C6-9D26-DC4ED9B8D000")

    XCTAssertEqual(cryptex.kind, .cryptexDiskImage)
    XCTAssertEqual(cryptex.platform, .tvOS)
    XCTAssertEqual(
      cryptex.parentIdentifier,
      UUID(uuidString: "1A1A0360-1992-46DC-82FC-B4F14B11FC8E")
    )
    XCTAssertTrue(cryptex.canDelete)

    // The runtime identifier drops the patch version.
    let patch = try images.image("3FDA4027-FB31-4B4E-B591-E332B4CBB40B")
    XCTAssertEqual(patch.version, "26.3.1")
    XCTAssertEqual(
      patch.runtimeIdentifier.description,
      "com.apple.CoreSimulator.SimRuntime.iOS-26-3"
    )
  }
}
