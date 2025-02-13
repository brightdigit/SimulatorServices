//
//  SimCtlTests.swift
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

// swiftlint:disable strict_fileprivate

internal class SimCtlTests: XCTestCase {
  private struct SubcommandTest {
    fileprivate let command: MockSubcommand<UUID>
    fileprivate let expectedUUID: UUID
    fileprivate let expectedData: Data
    fileprivate let simctl: SimCtl
    private init(
      command: MockSubcommand<UUID>,
      expectedUUID: UUID,
      expectedData: Data,
      simctl: SimCtl
    ) {
      self.command = command
      self.expectedUUID = expectedUUID
      self.expectedData = expectedData
      self.simctl = simctl
    }

    fileprivate init(from testCase: XCTestCase) {
      let expectedUUID = UUID()
      let expectedData = Data.random()

      let commandExpectation = testCase.expectation(description: "subcommand")
      let command = MockSubcommand { actualData -> UUID in
        XCTAssertEqual(actualData, expectedData)
        commandExpectation.fulfill()
        return expectedUUID
      }

      let expectedXcRunURL = FileManager.default
        .temporaryDirectory
        .appendingPathComponent(
          UUID().uuidString
        )
      let simctl = SimCtl(
        xcRunURL: expectedXcRunURL,
        processFactory: MockSimCtlProcess(result: .success(expectedData))
      )

      self.init(
        command: command,
        expectedUUID: expectedUUID,
        expectedData: expectedData,
        simctl: simctl
      )
    }
  }

  internal func testInit() {
    let expectedXcRunURL = FileManager.default.temporaryDirectory.appendingPathComponent(
      UUID().uuidString
    )
    let simctl = SimCtl(
      xcRunURL: expectedXcRunURL,
      processFactory: MockSimCtlProcess(result: .success(nil))
    )
    XCTAssertEqual(expectedXcRunURL, simctl.xcRunURL)
  }

  internal func testRunSubcommandParse() throws {
    let details = SubcommandTest(from: self)
    let runExpectation = expectation(description: "run")
    Task {
      let actualUUID = try await details.simctl.run(details.command)
      XCTAssertEqual(actualUUID, details.expectedUUID)
      runExpectation.fulfill()
    }
    waitForExpectations(timeout: 1.0) { error in XCTAssertNil(error) }
  }
}
// swiftlint:enable strict_fileprivate
