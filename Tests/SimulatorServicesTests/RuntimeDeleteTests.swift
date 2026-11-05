//
//  RuntimeDeleteTests.swift
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

internal final class RuntimeDeleteTests: XCTestCase {
  internal func testArguments() {
    XCTAssertEqual(
      RuntimeDelete(CommandFixture.iOS16Image).arguments,
      ["runtime", "delete", "C4C5640A-D49F-4CDE-A854-95F829558242"]
    )
  }

  internal func testArgumentsWithMultipleIdentifiers() throws {
    let identifiers = [
      CommandFixture.iOS16Image, CommandFixture.watchOS94Image, CommandFixture.unknownID,
    ]
    let expected = ["runtime", "delete"] + identifiers.map(\.uuidString)

    XCTAssertEqual(try XCTUnwrap(RuntimeDelete(identifiers)).arguments, expected)
    XCTAssertEqual(
      RuntimeDelete(identifiers[0], identifiers[1], identifiers[2]).arguments,
      expected
    )
  }

  internal func testInitWithNoIdentifiers() {
    XCTAssertNil(RuntimeDelete([]))
  }

  internal func testDelete() async throws {
    let fixture = CommandFixture(.xcode271RuntimeDelete, "runtime-delete-ios16")
    XCTAssertEqual(try fixture.status(), 0)
    try await fixture.run(RuntimeDelete(CommandFixture.iOS16Image))
  }

  internal func testDeleteSecondImage() async throws {
    let fixture = CommandFixture(.xcode271RuntimeDelete, "runtime-delete-watchos94")
    XCTAssertEqual(try fixture.status(), 0)
    try await fixture.run(RuntimeDelete(CommandFixture.watchOS94Image))
  }

  internal func testDeleteAgain() async throws {
    let fixture = CommandFixture(.xcode271RuntimeDelete, "runtime-delete-ios16-again")
    let command = RuntimeDelete(CommandFixture.iOS16Image)
    let error = try await fixture.error(running: command)

    XCTAssertEqual(error.status, 2)
    XCTAssertEqual(error.reason, .noMatchingRuntime)
    XCTAssertEqual(error.arguments, command.arguments)
    let standardError = String(bytes: try fixture.standardError(), encoding: .utf8)
    XCTAssertEqual(error.standardError, standardError)
    XCTAssertEqual(
      error.message,
      """
      No runtime disk images or bundles found matching \
      'C4C5640A-D49F-4CDE-A854-95F829558242'. Try 'runtime list'.
      No matching images found to delete
      """
    )
  }

  internal func testDeleteUnknownIdentifier() async throws {
    let fixture = CommandFixture(.xcode271, "runtime-delete-unknown-id")
    let error = try await fixture.error(running: RuntimeDelete(CommandFixture.unknownID))

    XCTAssertEqual(error.status, 2)
    XCTAssertEqual(error.reason, .noMatchingRuntime)
    XCTAssert(
      error.standardError.hasPrefix(
        "No runtime disk images or bundles found matching "
          + "'00000000-0000-0000-0000-000000000000'."
      )
    )
  }

  internal func testRecoverLaunchFailure() {
    let delete = RuntimeDelete(CommandFixture.iOS16Image)
    XCTAssertThrowsError(try delete.recover(.launchFailed("No such file"))) {
      XCTAssertEqual(
        $0 as? SimCtlError,
        .launchFailed(arguments: delete.arguments, description: "No such file")
      )
    }
  }
}
