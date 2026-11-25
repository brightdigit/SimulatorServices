//
//  RecordingToolRunner.swift
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
  import Synchronization

  @testable import SimulatorServices

  /// Replays canned command output and records each run.
  internal final class RecordingToolRunner: XcodeToolRunning {
    internal struct Invocation: Sendable, Hashable {
      internal let executable: URL
      internal let arguments: [String]
      internal let environment: [String: String]
    }

    private let outputs: Mutex<[String: XcodeToolOutput]>
    private let recorded = Mutex<[Invocation]>([])

    /// Every run so far, in order.
    internal var invocations: [Invocation] {
      recorded.withLock { $0 }
    }

    /// - Parameter outputs: Output keyed by the executable's name, for
    ///   example `"xcode-select"`. A missing key throws, as if the command
    ///   couldn't launch.
    internal init(_ outputs: [String: XcodeToolOutput] = [:]) {
      self.outputs = Mutex(outputs)
    }

    /// How many times `name` ran.
    internal func count(_ name: String) -> Int {
      invocations.count { $0.executable.lastPathComponent == name }
    }

    /// Replaces the output for `name`.
    internal func set(_ name: String, _ output: XcodeToolOutput) {
      outputs.withLock { $0[name] = output }
    }

    internal func run(
      executable: URL,
      arguments: [String],
      environment: [String: String]
    ) async throws(XcodeDiscoveryError) -> XcodeToolOutput {
      recorded.withLock { invocations in
        invocations.append(
          Invocation(
            executable: executable,
            arguments: arguments,
            environment: environment
          )
        )
      }
      guard let output = outputs.withLock({ $0[executable.lastPathComponent] }) else {
        throw .launchFailed(
          command: executable.lastPathComponent,
          description: "The executable couldn't be loaded."
        )
      }
      return output
    }
  }
#endif
