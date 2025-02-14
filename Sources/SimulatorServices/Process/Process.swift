//
//  Process.swift
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

#if os(macOS)
  import Foundation

  @available(macOS 10.15.4, *)
  extension Process: InternalSimCtlProcess, InternalAsyncableProcess {
    internal func termintationResult() -> TerminationResult {
      .init(reason: terminationReason.rawValue, status: Int(terminationStatus))
    }

    internal func fileHandles() -> ProcessOutputHandleSet {
      let standardError = Pipe()
      let standardOutput = Pipe()

      self.standardError = standardError
      self.standardOutput = standardOutput

      return .init(
        output: standardOutput.fileHandleForReading,
        error: standardError.fileHandleForReading
      )
    }

    internal func promise() -> any ProcessCompletionPromise {
      let semaphore = DispatchSemaphore(value: 0)

      terminationHandler = { _ in semaphore.signal() }
      return semaphore
    }

    /// Runs the process within the timeout given.
    /// - Parameter timeout: `DispatchTime` for the process to complete.
    /// - Returns: `Data` returned from the command.
    /// - Throws: An error is the process fails.
    public func run(till timeout: DispatchTime) async throws -> Data? {
      try await run(timeout: timeout)
    }
  }

#endif
