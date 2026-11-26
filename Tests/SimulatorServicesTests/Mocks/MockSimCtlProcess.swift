//
//  MockSimCtlProcess.swift
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

@testable import SimulatorServices

/// Replays one result for every command, and records the last command run.
///
/// Guarded by an `NSLock` rather than `Mutex`, which needs iOS 18 / watchOS 11
/// and newer than the package's minimums.
internal final class MockSimCtlProcess: CommandRunning, @unchecked Sendable {
  private let result: Result<Data?, ProcessError>
  private let lock = NSLock()
  private var storedLastCommand: Command?

  private var lastCommand: Command? {
    lock.withLock { storedLastCommand }
  }

  /// The executable of the last command run.
  internal var executableURL: URL? { lastCommand?.executableURL }
  /// The arguments of the last command run.
  internal var arguments: [String]? { lastCommand?.arguments }
  /// The environment of the last command run, `nil` when it inherits.
  internal var environment: [String: String]? { lastCommand?.environment }

  /// - Parameter result: Standard output for a command that exits with
  ///   status 0, or how it fails.
  internal init(result: Result<Data?, ProcessError>) {
    self.result = result
  }

  internal func run(_ command: Command) async throws(CommandError) -> CommandOutput {
    lock.withLock { storedLastCommand = command }
    switch result {
    case .success(let output):
      return CommandOutput(standardOutput: output ?? Data())

    case .failure(.uncaughtSignal(let signal)):
      return CommandOutput(
        standardOutput: signal.output ?? Data(),
        standardError: signal.data ?? Data(),
        termination: signal.reason == 1
          ? .exited(Int32(signal.status)) : .signaled(Int32(signal.status))
      )

    case .failure(.launchFailed(let description)):
      throw .launchFailed(description)

    case .failure(.unreadableOutput(let description)):
      throw .unreadableOutput(description)
    }
  }
}
