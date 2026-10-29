//
//  DeviceStateCommandTests.swift
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

internal final class DeviceStateCommandTests: XCTestCase {
  private static let udid = "573A75A3-913D-4A4B-9080-FCDDB62C728C"

  internal func testArguments() {
    XCTAssertEqual(Boot(CommandFixture.device).arguments, ["boot", Self.udid])
    XCTAssertEqual(Shutdown(CommandFixture.device).arguments, ["shutdown", Self.udid])
    XCTAssertEqual(Erase(CommandFixture.device).arguments, ["erase", Self.udid])
  }

  internal func testBoot() async throws {
    let fixture = CommandFixture(.xcode271, "boot")
    XCTAssertEqual(try fixture.status(), 0)
    try await fixture.run(Boot(CommandFixture.device))
  }

  internal func testBootBootedDevice() async throws {
    let fixture = CommandFixture(.xcode271, "boot-already-booted")
    let error = try await fixture.error(running: Boot(CommandFixture.device))

    XCTAssertEqual(error.status, 149)
    XCTAssertEqual(error.reason, .invalidState)
    XCTAssertEqual(
      error.message,
      """
      An error was encountered processing the command \
      (domain=com.apple.CoreSimulator.SimError, code=405):
      Unable to boot device in current state: Booted
      """
    )
  }

  internal func testBootUnknownDevice() async throws {
    let fixture = CommandFixture(.xcode271, "boot-unknown")
    let error = try await fixture.error(running: Boot(CommandFixture.unknownID))

    XCTAssertEqual(error.status, 148)
    XCTAssertEqual(error.reason, .invalidDevice)
    XCTAssertEqual(
      error.message,
      "Invalid device or device pair: 00000000-0000-0000-0000-000000000000"
    )
  }

  internal func testShutdown() async throws {
    let fixture = CommandFixture(.xcode271, "shutdown")
    XCTAssertEqual(try fixture.status(), 0)
    try await fixture.run(Shutdown(CommandFixture.device))
  }

  internal func testShutdownShutDownDevice() async throws {
    let fixture = CommandFixture(.xcode271, "shutdown-already-shutdown")
    let error = try await fixture.error(running: Shutdown(CommandFixture.device))

    XCTAssertEqual(error.status, 149)
    XCTAssertEqual(error.reason, .invalidState)
    XCTAssert(
      error.message.hasSuffix("Unable to shutdown device in current state: Shutdown")
    )
  }

  internal func testShutdownUnknownDevice() async throws {
    let fixture = CommandFixture(.xcode271, "shutdown-unknown")
    let error = try await fixture.error(running: Shutdown(CommandFixture.unknownID))

    XCTAssertEqual(error.status, 148)
    XCTAssertEqual(error.reason, .invalidDevice)
    XCTAssertEqual(error.message, "Invalid device: 00000000-0000-0000-0000-000000000000")
  }

  internal func testEraseUnknownDevice() async throws {
    let fixture = CommandFixture(.xcode271, "erase-unknown")
    let command = Erase(CommandFixture.unknownID)
    let error = try await fixture.error(running: command)

    XCTAssertEqual(error.status, 148)
    XCTAssertEqual(error.reason, .invalidDevice)
    XCTAssertEqual(error.arguments, command.arguments)
    XCTAssertEqual(error.message, "Invalid device: 00000000-0000-0000-0000-000000000000")
  }
}
