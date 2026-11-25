//
//  SimCtl+RunToCompletion.swift
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

extension SimCtl {
  /// Why ``runToCompletion(_:)`` returned no output.
  internal enum RunFailure: Error, Sendable {
    /// The calling task was cancelled.
    case cancelled
    /// The command failed, couldn't start, or its output was unreadable.
    case process(ProcessError)
  }

  /// The command for `arguments`, with `DEVELOPER_DIR` set when
  /// ``developerDirectory`` is.
  internal func makeCommand(executableURL: URL, arguments: [String]) -> Command {
    var environment: [String: String]?
    if let developerDirectory {
      environment = baseEnvironment
      environment?[Self.developerDirectoryKey] = developerDirectory.path
    }
    return Command(
      executableURL: executableURL,
      arguments: arguments,
      environment: environment
    )
  }

  /// Runs `command` and returns its standard output if it exited with
  /// status 0.
  internal func runToCompletion(_ command: Command) async -> Result<Data?, RunFailure> {
    let output: CommandOutput
    do {
      output = try await runner.run(command)
    } catch .cancelled {
      return .failure(.cancelled)
    } catch {
      return .failure(.process(ProcessError(error)))
    }
    do {
      return .success(try output.standardOutputIfSucceeded())
    } catch {
      return .failure(.process(error))
    }
  }
}
