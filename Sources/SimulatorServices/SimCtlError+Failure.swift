//
//  SimCtlError+Failure.swift
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

extension SimCtlError {
  /// A `simctl` call that ran and failed.
  ///
  /// ``standardError`` holds what `simctl` wrote to standard error, verbatim,
  /// so it can be shown to the user as is.
  public struct Failure: Equatable, Sendable {
    /// The ``terminationReason`` of a process that exited normally.
    public static let exitTerminationReason: TerminationReason = 1

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
    public var reason: SimCtlError.Reason {
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

    /// The status `simctl` exited with, or `nil` when a signal ended it.
    public var exitCode: Int32? {
      terminationReason == Self.exitTerminationReason ? Int32(clamping: status) : nil
    }

    /// Creates an error from what a failed `simctl` call reported.
    /// - Parameters:
    ///   - arguments: The arguments passed to `simctl`.
    ///   - status: The exit status, or the signal number.
    ///   - standardError: What `simctl` wrote to standard error.
    ///   - terminationReason: `1` for an exit, `2` for an uncaught signal,
    ///     as in `Process.TerminationReason`.
    ///   - standardOutput: What `simctl` wrote to standard output.
    public init(
      arguments: [String],
      status: Int,
      standardError: String,
      terminationReason: TerminationReason = Failure.exitTerminationReason,
      standardOutput: String = ""
    ) {
      self.arguments = arguments
      self.status = status
      self.terminationReason = terminationReason
      self.standardError = standardError
      self.standardOutput = standardOutput
    }

    /// Create an error from a failed `simctl` process.
    /// - Parameters:
    ///   - signal: How the process ended, with its output.
    ///   - arguments: The arguments passed to `simctl`.
    public init(signal: UncaughtSignal, arguments: [String]) {
      self.arguments = arguments
      status = signal.status
      terminationReason = signal.reason
      standardError = signal.data.flatMap { String(bytes: $0, encoding: .utf8) } ?? ""
      standardOutput = signal.output.flatMap { String(bytes: $0, encoding: .utf8) } ?? ""
    }
  }
}
