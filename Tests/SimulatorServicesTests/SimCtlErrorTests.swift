//
//  SimCtlErrorTests.swift
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

internal final class SimCtlErrorTests: XCTestCase {
  private static func error(status: Int, standardError: String) throws -> SimCtlError {
    let signal = try XCTUnwrap(
      UncaughtSignal(
        reason: 1, status: status, data: Data(standardError.utf8), output: nil
      )
    )
    return SimCtlError(signal: signal, arguments: ["boot", "booted"])
  }

  internal func testKeepsStandardErrorVerbatim() throws {
    let error = try Self.error(status: 1, standardError: "  Something failed\n")

    XCTAssertEqual(error.standardError, "  Something failed\n")
    XCTAssertEqual(error.message, "Something failed")
    XCTAssertEqual(error.errorDescription, "Something failed")
    XCTAssertEqual(error.reason, .other)
    XCTAssertEqual(error.standardOutput, "")
    XCTAssertEqual(error.terminationReason, 1)
  }

  internal func testMessageWithoutStandardError() throws {
    let error = try Self.error(status: 3, standardError: "\n")
    XCTAssertEqual(error.message, "simctl boot booted failed with status 3")
  }

  internal func testFromTimeout() {
    let timeout = ProcessError.timeout(.now())
    XCTAssertEqual(SimCtlError.from(timeout, arguments: []) as? ProcessError, timeout)
  }

  internal func testFromUncaughtSignal() throws {
    let signal = try XCTUnwrap(
      UncaughtSignal(
        reason: 1, status: 148, data: Data("Invalid device: x\n".utf8), output: nil
      )
    )
    let error = SimCtlError.from(.uncaughtSignal(signal), arguments: ["erase", "x"])
    XCTAssertEqual(
      error as? SimCtlError,
      SimCtlError(signal: signal, arguments: ["erase", "x"])
    )
    XCTAssertEqual((error as? SimCtlError)?.reason, .invalidDevice)
  }
}
