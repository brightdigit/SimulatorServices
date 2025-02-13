//
//  DeviceTests.swift
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

import SimulatorServices
import XCTest

// swift-format-ignore: AlwaysUseLowerCamelCase
internal func XCTAssertEmpty(
  _ expression: @autoclosure () throws -> [Any],
  _ message: @autoclosure () -> String? = nil,
  file: StaticString = #filePath,
  line: UInt = #line
) rethrows {
  if let message = message() {
    try XCTAssert(expression().isEmpty, message, file: file, line: line)
    return
  }

  let value = try expression()
  XCTAssert(
    value.isEmpty,
    "Array is not empty: \(value.map { "\($0)" }.joined(separator: ","))",
    file: file,
    line: line
  )
}

internal final class DeviceTests: XCTestCase {
  // swiftlint:disable:next function_body_length
  internal func testSimCtlList() async throws {
    #if os(macOS)
      let simctl = SimCtl()
      let results = try await simctl.run(List())

      var deviceTypeIDs = [DeviceTypeID]()
      var deviceStates = [DeviceState]()
      var pairStates = [PairState]()
      var platforms = [Platform]()
      var productFamilies = [ProductFamily]()

      for devices in results.devices.values {
        for device in devices {
          deviceTypeIDs.append(device.deviceTypeIdentifier)
          deviceStates.append(device.state)
        }
      }

      for devicetype in results.devicetypes {
        productFamilies.append(devicetype.productFamily)
        deviceTypeIDs.append(devicetype.identifier)
      }

      for runtime in results.runtimes {
        platforms.append(runtime.platform)
        platforms.append(runtime.identifier.platform)
        for supportedDeviceType in runtime.supportedDeviceTypes {
          deviceTypeIDs.append(supportedDeviceType.identifier)
          productFamilies.append(supportedDeviceType.productFamily)
        }
      }

      for pair in results.pairs.values {
        deviceStates.append(pair.phone.state)
        deviceStates.append(pair.watch.state)
        pairStates.append(pair.state)
      }

      let unknownDevicetypeids = deviceTypeIDs.compactMap { $0.unknownValue() }
      let unknownDevicestates = deviceStates.compactMap { $0.unknownValue() }
      let unknownPairstates = pairStates.compactMap { $0.unknownValue() }
      let unknownPlatforms = platforms.compactMap { $0.unknownValue() }
      let unknownProductfamilies = productFamilies.compactMap { $0.unknownValue() }

      XCTAssertEmpty(unknownDevicetypeids)
      XCTAssertEmpty(unknownDevicestates)
      XCTAssertEmpty(unknownPairstates)
      XCTAssertEmpty(unknownPlatforms)
      XCTAssertEmpty(unknownProductfamilies)
    #else
      throw XCTSkip("Unavailable in operating system")
    #endif
  }
}
