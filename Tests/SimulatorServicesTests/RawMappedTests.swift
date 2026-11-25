//
//  RawMappedTests.swift
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

import XCTest

@testable import SimulatorServices

/// Every raw option maps to a case and back, so no dictionary entry is
/// missing. (A `switch` would catch that at compile time; a lookup can't.)
internal final class RawMappedTests: XCTestCase {
  private func assertRoundTrips<Value: RawMapped>(
    _: Value.Type,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where Value.RawAvailableOptions: CaseIterable {
    let options = Value.RawAvailableOptions.allCases
    let mapped = Value.rawOptions.leftValues.count
    XCTAssertEqual(mapped, options.count, file: file, line: line)
    for option in options {
      let value = Value(rawOption: option)
      let message = "\(option) maps to unknown"
      XCTAssertNil(value.unknownValue(), message, file: file, line: line)
      XCTAssertEqual(Value.rawOptions[right: value], option, file: file, line: line)
    }
  }

  internal func testEveryMappingRoundTrips() {
    assertRoundTrips(DeviceState.self)
    assertRoundTrips(DeviceTypeID.self)
    assertRoundTrips(PairState.self)
    assertRoundTrips(SimulatorServices.Platform.self)
    assertRoundTrips(ProductFamily.self)
    assertRoundTrips(RuntimeImageKind.self)
    assertRoundTrips(RuntimeImageState.self)
  }

  internal func testReversibleOptionsComeFromTheSameMap() {
    XCTAssertEqual(SimulatorServices.Platform.RawAvailableOptions(option: .xrOS), .xrOS)
    XCTAssertNil(
      SimulatorServices.Platform.RawAvailableOptions(option: .unknown("macOS"))
    )
    XCTAssertEqual(DeviceState.RawAvailableOptions(option: .shuttingDown), .shuttingDown)
    let visionPro = DeviceTypeID.RawAvailableOptions(option: .appleVisionPro)
    XCTAssertEqual(visionPro, .appleVisionPro)
  }

  internal func testDiskImageKinds() {
    XCTAssertTrue(RuntimeImageKind.patchableCryptexDiskImage.isDiskImage)
    XCTAssertFalse(RuntimeImageKind.legacyDownload.isDiskImage)
    XCTAssertFalse(RuntimeImageKind.unknown("Other").isDiskImage)
  }
}
