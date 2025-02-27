//
//  MockAsyncableProcess.swift
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

@testable import SimulatorServices

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
internal class MockAsyncableProcess: InternalAsyncableProcess, ProcessCompletionPromise {
  private let outputData: Data
  private let errorData: Data
  private let terminationResult: TerminationResult
  private let runError: Error?
  private let willTimeout: Bool

  internal init(
    outputData: Data,
    errorData: Data,
    terminationResult: TerminationResult,
    willTimeout: Bool,
    runError: Error? = nil
  ) {
    self.outputData = outputData
    self.errorData = errorData
    self.terminationResult = terminationResult
    self.runError = runError
    self.willTimeout = willTimeout
  }

  internal func waitForCompletion(
    for timeout: DispatchTime,
    with result: @autoclosure @escaping () -> SimulatorServices.TerminationResult
  ) -> SimulatorServices.ProcessResult {
    sleep(1)
    if willTimeout {
      return .timedOut(timeout)
    } else {
      return .success(result())
    }
  }

  internal func run() throws {
    guard let runError else {
      return
    }

    throw runError
  }

  internal func promise() -> SimulatorServices.ProcessCompletionPromise { self }

  internal func fileHandles() -> SimulatorServices.ProcessOutputHandleSet {
    // swiftlint:disable:next force_try
    try! .init(
      output: .init(temporaryFromData: outputData),
      error: .init(temporaryFromData: errorData)
    )
  }

  internal func termintationResult() -> SimulatorServices.TerminationResult {
    terminationResult
  }
}
