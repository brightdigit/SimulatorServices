//
//  DeviceDeleteTests.swift
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

internal final class DeviceDeleteTests: XCTestCase {
  internal func testArguments() throws {
    let udids = [CommandFixture.device, CommandFixture.unknownID]
    let expected = ["delete"] + udids.map(\.uuidString)

    XCTAssertEqual(DeviceDelete(udids[0], udids[1]).arguments, expected)
    XCTAssertEqual(try XCTUnwrap(DeviceDelete(udids)).arguments, expected)
    XCTAssertEqual(
      DeviceDelete(CommandFixture.device).arguments,
      ["delete", "573A75A3-913D-4A4B-9080-FCDDB62C728C"]
    )
  }

  internal func testInitWithNoUDIDs() {
    XCTAssertNil(DeviceDelete([]))
  }

  internal func testDeleteUnknownDevice() async throws {
    let fixture = CommandFixture(.xcode271, "device-delete-unknown")
    let command = DeviceDelete(CommandFixture.unknownID)
    let error = try await fixture.error(running: command)

    XCTAssertEqual(error.status, 148)
    XCTAssertEqual(error.reason, .invalidDevice)
    XCTAssertEqual(error.arguments, command.arguments)
    XCTAssertEqual(error.message, "Invalid device: 00000000-0000-0000-0000-000000000000")
    XCTAssertEqual(
      error.standardError, String(decoding: try fixture.standardError(), as: UTF8.self))
  }

  internal func testDeleteUnavailableArguments() {
    XCTAssertEqual(DeleteUnavailable().arguments, ["delete", "unavailable"])
  }

  internal func testDeleteUnavailable() async throws {
    // No recording of `delete unavailable` yet: it needs unavailable devices.
    let process = MockSimCtlProcess(result: .success(Data()))
    let simctl = SimCtl(
      xcRunURL: URL(fileURLWithPath: "/usr/bin/xcrun"),
      processFactory: process
    )
    try await simctl.run(DeleteUnavailable())
    XCTAssertEqual(process.arguments, ["simctl", "delete", "unavailable"])
  }
}
