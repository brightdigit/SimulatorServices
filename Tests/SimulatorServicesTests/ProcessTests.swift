//
//  ProcessTests.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

@testable import SimulatorServices
import XCTest

public class ProcessTests: XCTestCase {
  func testRunProcess() async throws {
    guard #available(iOS 13.4, *) else {
      throw XCTSkip("Required API is not available for this test.")
    }

    let timeout: DispatchTime = .now() + 1.0
    let output: Data = .random()
    let error: Data = .random()
    let termination: TerminationResult = .init(reason: 1, status: 0)

    let process = MockAsyncableProcess(outputData: output, errorData: error, terminationResult: termination, willTimeout: false)
    let actualOutput = try await process.run(timeout: timeout)
    XCTAssertEqual(output, actualOutput)
  }
}
