//
//  ListTests.swift
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

internal class ListTests: XCTestCase {
  internal func testArguments() {
    let listCommand = List()
    XCTAssertEqual(listCommand.arguments, ["list", "-j"])
  }

  internal func testParse() throws {
    let actualList: SimulatorList = .random()
    let expectation = expectation(description: "decoder called")
    let expectedData: Data = .random()
    let decoder = MockDecoder { actualData -> SimulatorList in
      XCTAssertEqual(expectedData, actualData)
      defer { expectation.fulfill() }
      return actualList
    }
    let listCommand = List(decoder: decoder)
    let expectedList = try listCommand.parse(expectedData)
    waitForExpectations(timeout: 1.0) { error in
      XCTAssertNil(error)
      XCTAssertEqual(expectedList, actualList)
    }
  }
}

extension SimulatorList {
  // swiftlint:disable:next strict_fileprivate
  fileprivate static func random() -> SimulatorList {
    SimulatorList(
      devicetypes: [
        .init(
          productFamily: .random(),
          bundlePath: .random(),
          maxRuntimeVersion: 1,
          maxRuntimeVersionString: .random(),
          identifier: .random(),
          modelIdentifier: .random(),
          minRuntimeVersionString: .random(),
          minRuntimeVersion: 2,
          name: .random()
        )
      ],
      runtimes: [],
      devices: [:],
      pairs: [:]
    )
  }
}
