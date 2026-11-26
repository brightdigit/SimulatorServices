//
//  XcodeDiscoveryError.swift
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

/// A failure reading which Xcode `xcode-select` points at.
public enum XcodeDiscoveryError: Error, Sendable, Hashable {
  /// The command exited with a non-zero status. `standardError` is verbatim.
  case commandFailed(command: String, exitCode: Int32, standardError: String)
  /// The command succeeded but printed nothing.
  case emptyOutput(command: String)
  /// The command printed something other than an absolute path.
  case notAnAbsolutePath(command: String, output: String)
  /// The command couldn't be started.
  case launchFailed(command: String, description: String)
  /// The task was cancelled before the command started.
  case cancelled
}

extension XcodeDiscoveryError: LocalizedError {
  /// A sentence describing the failure, with stderr when there is any.
  public var errorDescription: String? {
    switch self {
    case let .commandFailed(command, exitCode, standardError):
      let detail = standardError.trimmingCharacters(in: .whitespacesAndNewlines)
      return detail.isEmpty
        ? "\(command) failed with exit code \(exitCode)."
        : "\(command) failed with exit code \(exitCode): \(detail)"

    case let .emptyOutput(command):
      return "\(command) printed nothing."

    case let .notAnAbsolutePath(command, output):
      return "\(command) printed \"\(output)\", which isn't an absolute path."

    case let .launchFailed(command, description):
      return "\(command) couldn't be started: \(description)"

    case .cancelled:
      return "Looking for Xcode was cancelled."
    }
  }
}
