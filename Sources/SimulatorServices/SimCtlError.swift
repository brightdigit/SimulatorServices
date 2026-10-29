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

/// A `simctl` subcommand that exited with an error.
///
/// ``standardError`` holds what `simctl` wrote to standard error, verbatim,
/// so it can be shown to the user as is.
public struct SimCtlError: Error, Equatable, Sendable, LocalizedError {
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
    /// Anything else. Read ``SimCtlError/standardError``.
    case other
  }

  /// The arguments passed to `simctl`.
  public let arguments: [String]
  /// The exit status, or the signal number if `simctl` was killed by a signal.
  public let status: Int
  /// The termination reason (`1` for an exit, `2` for an uncaught signal).
  public let terminationReason: TerminationReason
  /// Standard error from `simctl`, verbatim.
  public let standardError: String
  /// Standard output from `simctl`, verbatim.
  public let standardOutput: String

  /// What went wrong, worked out from ``status`` and ``standardError``.
  public var reason: Reason {
    if standardError.hasPrefix("Invalid device") {
      return .invalidDevice
    }
    if standardError.contains("domain=com.apple.CoreSimulator.SimError, code=405") {
      return .invalidState
    }
    if standardError.contains("No matching images found to delete") {
      return .noMatchingRuntime
    }
    return .other
  }

  /// Standard error without surrounding whitespace, or the exit status if it's empty.
  public var message: String {
    let message = standardError.trimmingCharacters(in: .whitespacesAndNewlines)
    guard message.isEmpty else {
      return message
    }
    return "simctl \(arguments.joined(separator: " ")) failed with status \(status)"
  }

  /// The same as ``message``.
  public var errorDescription: String? { message }

  /// Create an error from a failed `simctl` process.
  /// - Parameters:
  ///   - signal: How the process ended, with its output.
  ///   - arguments: The arguments passed to `simctl`.
  public init(signal: UncaughtSignal, arguments: [String]) {
    self.arguments = arguments
    status = signal.status
    terminationReason = signal.reason
    standardError = signal.data.map { String(decoding: $0, as: UTF8.self) } ?? ""
    standardOutput = signal.output.map { String(decoding: $0, as: UTF8.self) } ?? ""
  }

  /// The error a subcommand rethrows for a ``ProcessError``.
  /// - Parameters:
  ///   - error: The error from running `simctl`.
  ///   - arguments: The arguments passed to `simctl`.
  /// - Returns: A ``SimCtlError`` for a process that failed,
  ///   otherwise `error` itself (a timeout).
  internal static func from(_ error: ProcessError, arguments: [String]) -> any Error {
    guard case let .uncaughtSignal(signal) = error else {
      return error
    }
    return SimCtlError(signal: signal, arguments: arguments)
  }
}
