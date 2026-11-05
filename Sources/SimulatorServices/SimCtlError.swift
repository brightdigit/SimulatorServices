//
//  SimCtlError.swift
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

/// Why a `simctl` call failed.
///
/// Every ``SimCtl`` call throws only this.
public enum SimCtlError: Error, Sendable, LocalizedError {
  /// `simctl` exited with a non-zero status or was killed by a signal.
  case failed(Failure)

  /// `xcrun` or `simctl` couldn't be started, for example because
  /// `DEVELOPER_DIR` doesn't point at an Xcode.
  case launchFailed(arguments: [String], description: String)

  /// `simctl` succeeded but printed nothing, or something that couldn't be
  /// read. The decoding error is included when there is one.
  case unreadableOutput(arguments: [String], DecodingError?)

  /// What went wrong, as far as it can be told from the exit status and standard error.
  ///
  /// The strings and exit statuses were recorded from Xcode 27.1.
  public enum Reason: Equatable, Sendable {
    /// There's no device with that UDID.
    ///
    /// Exit status 148, with `Invalid device: <udid>`
    /// (or `Invalid device or device pair: <udid>` from `boot`).
    case invalidDevice
    /// The device isn't in a state the command can run in, such as booting
    /// a booted device or shutting down a shut-down one.
    ///
    /// Exit status 149, with `domain=com.apple.CoreSimulator.SimError, code=405`.
    case invalidState
    /// No runtime image matched the identifiers given to `runtime delete`.
    ///
    /// Exit status 2, with `No matching images found to delete`.
    case noMatchingRuntime
    /// Anything else. Read ``Failure/standardError``.
    case other
  }

  /// The arguments passed to `simctl`.
  public var arguments: [String] {
    switch self {
    case .failed(let failure): failure.arguments
    case .launchFailed(let arguments, _), .unreadableOutput(let arguments, _): arguments
    }
  }

  /// The status `simctl` exited with, or `nil` when it was killed by a
  /// signal or never ran.
  public var exitCode: Int32? {
    guard case .failed(let failure) = self else {
      return nil
    }
    return failure.exitCode
  }

  /// Standard error from `simctl`, verbatim, when it ran and failed.
  public var standardError: String? {
    guard case .failed(let failure) = self else {
      return nil
    }
    return failure.standardError
  }

  /// What went wrong, worked out from the exit status and standard error,
  /// or ``Reason/other`` when `simctl` didn't run or its output was unreadable.
  public var reason: Reason {
    guard case .failed(let failure) = self else {
      return .other
    }
    return failure.reason
  }

  /// A sentence for an alert.
  public var errorDescription: String? {
    switch self {
    case .failed(let failure):
      failure.message

    case .launchFailed(_, let description):
      "simctl couldn't be started: \(description)"

    case .unreadableOutput(_, nil):
      "simctl printed nothing."

    case .unreadableOutput(_, let error?):
      "Couldn't read simctl's output: \(error)"
    }
  }

  /// The error for a ``ProcessError`` from running `simctl`.
  /// - Parameters:
  ///   - error: How the process failed.
  ///   - arguments: The arguments passed to `simctl`.
  /// - Returns: The matching ``SimCtlError``.
  internal static func from(_ error: ProcessError, arguments: [String]) -> SimCtlError {
    switch error {
    case .uncaughtSignal(let signal):
      .failed(Failure(signal: signal, arguments: arguments))

    case .launchFailed(let description):
      .launchFailed(arguments: arguments, description: description)

    case .unreadableOutput:
      .unreadableOutput(arguments: arguments, nil)
    }
  }
}

extension SimCtlError: Equatable {
  /// Two errors are equal when their cases and values match. Decoding
  /// errors, which aren't `Equatable`, are compared by description.
  public static func == (lhs: SimCtlError, rhs: SimCtlError) -> Bool {
    switch (lhs, rhs) {
    case let (.failed(left), .failed(right)):
      left == right

    case let (.launchFailed(leftArguments, left), .launchFailed(rightArguments, right)):
      leftArguments == rightArguments && left == right

    case let (.unreadableOutput(leftArgs, left), .unreadableOutput(rightArgs, right)):
      leftArgs == rightArgs
        && left.map { String(describing: $0) } == right.map { String(describing: $0) }

    default:
      false
    }
  }
}
