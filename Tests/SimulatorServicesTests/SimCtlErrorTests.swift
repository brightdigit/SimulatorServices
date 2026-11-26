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
  /// The recorded exit 2 stderr for an unknown runtime ID.
  private static let noRuntime = """
    No runtime disk images or bundles found matching 'X'. Try 'runtime list'.
    No matching images found to delete

    """

  private static func failure(
    status: Int,
    standardError: String,
    terminationReason: TerminationReason = 1
  ) -> SimCtlError {
    .failed(
      SimCtlError.Failure(
        arguments: ["boot", "booted"],
        status: status,
        standardError: standardError,
        terminationReason: terminationReason
      )
    )
  }

  internal func testKeepsStandardErrorVerbatim() {
    let error = Self.failure(status: 1, standardError: "  Something failed\n")

    XCTAssertEqual(error.standardError, "  Something failed\n")
    XCTAssertEqual(error.errorDescription, "Something failed")
    XCTAssertEqual(error.reason, .other)
    XCTAssertEqual(error.exitCode, 1)
    XCTAssertEqual(error.arguments, ["boot", "booted"])
  }

  internal func testMessageWithoutStandardError() {
    let error = Self.failure(status: 3, standardError: "\n")
    XCTAssertEqual(error.errorDescription, "simctl boot booted failed with status 3")
  }

  internal func testAnExitKeepsItsStatusAndStandardError() {
    let error = Self.failure(status: 2, standardError: Self.noRuntime)
    XCTAssertEqual(error.exitCode, 2)
    XCTAssertEqual(error.standardError, Self.noRuntime)
    XCTAssertEqual(error.reason, .noMatchingRuntime)
  }

  internal func testASignalHasNoExitCode() {
    let error = Self.failure(status: 9, standardError: "", terminationReason: 2)
    XCTAssertNil(error.exitCode)
  }

  internal func testFromUncaughtSignal() throws {
    let signal = try XCTUnwrap(
      UncaughtSignal(
        reason: 1, status: 148, data: Data("Invalid device: x\n".utf8), output: nil
      )
    )
    let error = SimCtlError.from(.uncaughtSignal(signal), arguments: ["erase", "x"])
    let failure = SimCtlError.Failure(signal: signal, arguments: ["erase", "x"])
    XCTAssertEqual(error, .failed(failure))
    XCTAssertEqual(error.reason, .invalidDevice)
  }

  internal func testFromALaunchFailure() {
    let error = SimCtlError.from(.launchFailed("No such file"), arguments: ["list", "-j"])
    let expected = SimCtlError.launchFailed(
      arguments: ["list", "-j"],
      description: "No such file"
    )
    XCTAssertEqual(error, expected)
    XCTAssertNil(error.exitCode)
    XCTAssertNil(error.standardError)
    XCTAssertEqual(error.errorDescription, "simctl couldn't be started: No such file")
  }

  internal func testListFailuresAreSimCtlErrors() async throws {
    let signal = try XCTUnwrap(
      UncaughtSignal(
        reason: 1, status: 72, data: Data("No devices\n".utf8), output: nil
      )
    )
    let simctl = SimCtl(
      xcRunURL: URL(fileURLWithPath: "/usr/bin/xcrun"),
      runner: MockSimCtlProcess(result: .failure(.uncaughtSignal(signal)))
    )
    do {
      _ = try await simctl.run(RuntimeList())
      XCTFail("Expected a SimCtlError")
    } catch {
      XCTAssertEqual(error.exitCode, 72)
      XCTAssertEqual(error.arguments, ["runtime", "list", "-j"])
    }
    do {
      _ = try await simctl.run(List())
      XCTFail("Expected a SimCtlError")
    } catch {
      XCTAssertEqual(error.arguments, ["list", "-j"])
    }
  }

  internal func testEmptyOutputIsUnreadable() {
    XCTAssertThrowsError(try RuntimeList().parse(nil)) { error in
      let expected = SimCtlError.unreadableOutput(
        arguments: ["runtime", "list", "-j"],
        nil
      )
      XCTAssertEqual(error as? SimCtlError, expected)
      XCTAssertEqual((error as? SimCtlError)?.errorDescription, "simctl printed nothing.")
    }
  }
}
