//
//  Command.swift
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

/// A command for a ``CommandRunning`` to run.
internal struct Command: Sendable, Hashable {
  /// The executable, by absolute path.
  internal let executableURL: URL
  /// The arguments, without the executable.
  internal let arguments: [String]
  /// The whole environment, or `nil` to inherit this process's.
  internal let environment: [String: String]?

  internal init(executableURL: URL, arguments: [String], environment: [String: String]?) {
    self.executableURL = executableURL
    self.arguments = arguments
    self.environment = environment
  }
}

/// How a command ended.
internal enum CommandTermination: Sendable, Hashable {
  /// It exited with this status.
  case exited(Int32)
  /// An uncaught signal ended it.
  case signaled(Int32)
}

/// What a command printed, and how it ended.
internal struct CommandOutput: Sendable, Hashable {
  internal let standardOutput: Data
  internal let standardError: Data
  internal let termination: CommandTermination

  internal init(
    standardOutput: Data = Data(),
    standardError: Data = Data(),
    termination: CommandTermination = .exited(0)
  ) {
    self.standardOutput = standardOutput
    self.standardError = standardError
    self.termination = termination
  }
}

/// Why a command produced no ``CommandOutput``. A non-zero exit isn't an
/// error here: it's in ``CommandOutput/termination``.
internal enum CommandError: Error, Sendable, Equatable {
  /// It couldn't be started.
  case launchFailed(String)
  /// Its output couldn't be read, or was larger than the limit.
  case unreadableOutput(String)
  /// The calling task was cancelled. A running command is terminated.
  case cancelled
}

/// Runs commands to completion. ``SimCtl`` and ``XcodeLocator`` run
/// everything through it, so tests can replay recorded output instead.
internal protocol CommandRunning: Sendable {
  /// Runs `command` and waits for it to exit. Cancelling the calling task
  /// terminates it and throws ``CommandError/cancelled``.
  func run(_ command: Command) async throws(CommandError) -> CommandOutput
}
