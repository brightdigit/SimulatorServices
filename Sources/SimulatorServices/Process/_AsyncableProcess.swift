//
//  _AsyncableProcess.swift
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

import Foundation

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
protocol _AsyncableProcess: AnyObject {
  func run() throws
  func promise() -> any ProcessCompletionPromise
  func fileHandles() -> ProcessOutputHandleSet
  func termintationResult() -> TerminationResult
}

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
extension _AsyncableProcess {
  func data(
    basedOn result: ProcessResult,
    from fileHandles: ProcessOutputHandleSet
  ) throws -> Data? {
    switch result {
    case let .success(termination):
      if let uncaught = UncaughtSignal(
        termination: termination,
        data: fileHandles.errorData,
        output: try? fileHandles.outputResult.get()
      ) {
        throw ProcessError.uncaughtSignal(uncaught)
      } else {
        return try fileHandles.outputResult.get()
      }

    case let .timedOut(timeout):
      throw ProcessError.timeout(timeout)
    }
  }

  /// Run the process asyncronously and returns the output as data.
  /// - Parameter timeout: Timeout for the process to be done.
  /// - Returns: Data if there anything output from the process.
  func run(timeout: DispatchTime) async throws -> Data? {
    var handles = fileHandles()
    let semaphore = promise()
    try run()
    handles.readToEnd()
    return try await withCheckedThrowingContinuation { continuation in
      let semaphoreResult = semaphore.waitForCompletion(
        for: timeout,
        with: self.termintationResult()
      )
      let result = Result {
        try self.data(basedOn: semaphoreResult, from: handles)
      }
      continuation.resume(with: result)
    }
  }
}
