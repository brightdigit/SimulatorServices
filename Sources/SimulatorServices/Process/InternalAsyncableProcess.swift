//
//  InternalAsyncableProcess.swift
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

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
internal protocol InternalAsyncableProcess: AnyObject {
  func run() throws
  func promise() -> any ProcessCompletionPromise
  func fileHandles() -> ProcessOutputHandleSet
  func termintationResult() -> TerminationResult
}

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
extension InternalAsyncableProcess {
  internal func data(
    basedOn termination: TerminationResult,
    from fileHandles: ProcessOutputHandleSet
  ) throws(ProcessError) -> Data? {
    let output = fileHandles.outputResult
    if let uncaught = UncaughtSignal(
      termination: termination,
      data: fileHandles.errorData,
      output: try? output.get()
    ) {
      throw .uncaughtSignal(uncaught)
    }
    do {
      return try output.get()
    } catch {
      throw .unreadableOutput(error.localizedDescription)
    }
  }

  /// Runs the process until it exits and returns its standard output.
  /// - Returns: Standard output, if the process printed anything.
  /// - Throws: ``ProcessError`` if it can't start, fails, or its output
  ///   can't be read.
  internal func runToCompletion() async throws(ProcessError) -> Data? {
    var handles = fileHandles()
    let semaphore = promise()
    do {
      try run()
    } catch {
      throw .launchFailed(error.localizedDescription)
    }
    handles.readToEnd()
    let result = await withCheckedContinuation { continuation in
      let termination = semaphore.waitForCompletion(with: self.termintationResult())
      continuation.resume(
        returning: Result { () throws(ProcessError) -> Data? in
          try self.data(basedOn: termination, from: handles)
        }
      )
    }
    return try result.get()
  }
}
