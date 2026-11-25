//
//  CommandOutput+Process.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
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

extension CommandTermination {
  /// As `Process.TerminationReason`: `1` for an exit, `2` for an uncaught signal.
  internal var reason: TerminationReason {
    switch self {
    case .exited: 1
    case .signaled: 2
    }
  }

  /// The exit status, or the signal number.
  internal var status: Int {
    switch self {
    case .exited(let status), .signaled(let status): Int(status)
    }
  }
}

extension CommandOutput {
  /// Standard output, or `nil` if there was none.
  ///
  /// - Throws: ``ProcessError/uncaughtSignal(_:)`` unless the command
  ///   exited with status 0.
  internal func standardOutputIfSucceeded() throws(ProcessError) -> Data? {
    let output = standardOutput.isEmpty ? nil : standardOutput
    if let signal = UncaughtSignal(
      reason: termination.reason,
      status: termination.status,
      data: standardError.isEmpty ? nil : standardError,
      output: output
    ) {
      throw .uncaughtSignal(signal)
    }
    return output
  }
}

extension ProcessError {
  /// The error for a command that produced no output, other than
  /// cancellation.
  internal init(_ error: CommandError) {
    switch error {
    case .launchFailed(let description):
      self = .launchFailed(description)

    case .unreadableOutput(let description):
      self = .unreadableOutput(description)

    case .cancelled:
      self = .launchFailed("The task was cancelled.")
    }
  }
}
