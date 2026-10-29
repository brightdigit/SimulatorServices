//
//  SimCtlDeveloperDirectoryTests.swift
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

internal final class SimCtlDeveloperDirectoryTests: XCTestCase {
  private static let xcRunURL = URL(fileURLWithPath: "/usr/bin/xcrun")
  private static let xcodeURL = URL(fileURLWithPath: "/Applications/Xcode-beta.app")
  private static let developerPath = "/Applications/Xcode-beta.app/Contents/Developer"
  private static let simCtlPath = developerPath + "/usr/bin/simctl"
  private static let udid = CommandFixture.device.uuidString
  private static let expectedEnvironment = [
    "PATH": "/usr/bin", "DEVELOPER_DIR": developerPath,
  ]

  internal func testDeveloperDirectoryForXcode() {
    XCTAssertEqual(SimCtl.developerDirectory(for: Self.xcodeURL).path, Self.developerPath)
    let developer = URL(fileURLWithPath: Self.developerPath)
    XCTAssertEqual(SimCtl.developerDirectory(for: developer), developer)
  }

  internal func testRunWithoutDeveloperDirectory() async throws {
    let process = MockSimCtlProcess(result: .success(nil))
    let simctl = SimCtl(
      xcRunURL: Self.xcRunURL,
      environment: ["PATH": "/usr/bin"],
      processFactory: process
    )
    try await simctl.run(Boot(CommandFixture.device))

    XCTAssertNil(simctl.developerDirectory)
    XCTAssertEqual(process.executableURL, Self.xcRunURL)
    XCTAssertEqual(process.arguments, ["simctl", "boot", Self.udid])
    // The process inherits the current environment.
    XCTAssertNil(process.environment)
  }

  internal func testRunWithDeveloperDirectory() async throws {
    let process = MockSimCtlProcess(result: .success(nil))
    let simctl = SimCtl(
      xcRunURL: Self.xcRunURL,
      developerDirectory: Self.xcodeURL,
      environment: ["PATH": "/usr/bin", "DEVELOPER_DIR": "/Applications/Xcode.app"],
      processFactory: process
    )
    try await simctl.run(Shutdown(CommandFixture.device))

    XCTAssertEqual(simctl.developerDirectory?.path, Self.developerPath)
    XCTAssertEqual(process.executableURL, Self.xcRunURL)
    XCTAssertEqual(process.arguments, ["simctl", "shutdown", Self.udid])
    XCTAssertEqual(
      process.environment,
      ["PATH": "/usr/bin", "DEVELOPER_DIR": Self.developerPath]
    )
  }

  internal func testFind() async throws {
    let process = MockSimCtlProcess(result: .success(Data((Self.simCtlPath + "\n").utf8)))
    let simctl = try await SimCtl(
      xcRunURL: Self.xcRunURL,
      developerDirectory: Self.xcodeURL,
      environment: ["PATH": "/usr/bin"],
      processFactory: process
    )
    .find()

    XCTAssertEqual(process.executableURL, Self.xcRunURL)
    XCTAssertEqual(process.arguments, ["--find", "simctl"])
    XCTAssertEqual(process.environment, Self.expectedEnvironment)
    XCTAssertEqual(simctl.simCtlURL?.path, Self.simCtlPath)
    XCTAssertEqual(simctl.developerDirectory?.path, Self.developerPath)

    // Later subcommands run the resolved simctl directly, with the same DEVELOPER_DIR.
    process.environment = nil
    try await simctl.run(Erase(CommandFixture.device))
    XCTAssertEqual(process.executableURL?.path, Self.simCtlPath)
    XCTAssertEqual(process.arguments, ["erase", CommandFixture.device.uuidString])
    XCTAssertEqual(process.environment, Self.expectedEnvironment)
  }

  internal func testParseFindOutput() throws {
    XCTAssertEqual(
      try SimCtl.parseFindOutput(Data("\(Self.simCtlPath)\n".utf8)).path,
      Self.simCtlPath
    )
    XCTAssertThrowsError(try SimCtl.parseFindOutput(nil)) {
      XCTAssertEqual($0 as? SimCtl.FindError, .missingData)
    }
    XCTAssertThrowsError(try SimCtl.parseFindOutput(Data(" \n".utf8))) {
      XCTAssertEqual($0 as? SimCtl.FindError, .missingData)
    }
    XCTAssertThrowsError(try SimCtl.parseFindOutput(Data("simctl\n".utf8))) {
      XCTAssertEqual($0 as? SimCtl.FindError, .invalidPath("simctl"))
    }
  }
}
