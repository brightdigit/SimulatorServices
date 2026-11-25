//
//  SubprocessCommandRunner.swift
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

#if os(macOS)
  import Foundation
  import Subprocess
  import System

  /// Runs commands with swift-subprocess.
  ///
  /// Standard output and standard error are read at the same time, so a
  /// chatty standard error can't stall the command. Cancelling the calling
  /// task terminates the command (Subprocess's teardown ends with `SIGKILL`).
  internal struct SubprocessCommandRunner: CommandRunning {
    /// The most standard output kept. `simctl list -j` is a few MB.
    internal static let standardOutputLimit = 64 * 1_024 * 1_024
    /// The most standard error kept.
    internal static let standardErrorLimit = 1_024 * 1_024

    /// Failures reading the command's output, rather than starting it.
    private static let readFailures: Set<SubprocessError.Code> = [
      .failedToReadFromSubprocess, .outputLimitExceeded, .asyncIOFailed,
    ]

    private static func environment(_ values: [String: String]?) -> Environment {
      guard let values else {
        return .inherit
      }
      let pairs = values.compactMap { key, value in
        Environment.Key(rawValue: key).map { ($0, value) }
      }
      return .custom(Dictionary(pairs) { first, _ in first })
    }

    private static func termination(_ status: TerminationStatus) -> CommandTermination {
      switch status {
      case .exited(let code): .exited(code)
      case .signaled(let signal): .signaled(signal)
      }
    }

    private static func commandError(_ error: any Error) -> CommandError {
      guard let error = error as? SubprocessError else {
        return .launchFailed(String(describing: error))
      }
      let description = String(describing: error)
      return readFailures.contains(error.code)
        ? .unreadableOutput(description) : .launchFailed(description)
    }

    internal func run(_ command: Command) async throws(CommandError) -> CommandOutput {
      let output: CommandOutput
      do {
        let result = try await Subprocess.run(
          .path(FilePath(command.executableURL.path(percentEncoded: false))),
          arguments: Arguments(command.arguments),
          environment: Self.environment(command.environment),
          output: .bytes(limit: Self.standardOutputLimit),
          error: .bytes(limit: Self.standardErrorLimit)
        )
        output = CommandOutput(
          standardOutput: Data(result.standardOutput),
          standardError: Data(result.standardError),
          termination: Self.termination(result.terminationStatus)
        )
      } catch {
        throw Task.isCancelled ? .cancelled : Self.commandError(error)
      }
      // A cancelled command was killed, so its output isn't its answer.
      guard !Task.isCancelled else {
        throw .cancelled
      }
      return output
    }
  }
#endif
