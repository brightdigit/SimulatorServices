//
//  XcodeToolRunner.swift
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

  /// Runs `xcode-select` and `mdfind` through a ``CommandRunning``
  /// (swift-subprocess by default).
  ///
  /// Cancelling the calling task terminates the command and throws
  /// ``XcodeDiscoveryError/cancelled``.
  internal struct XcodeToolRunner: XcodeToolRunning {
    private let runner: any CommandRunning

    internal init(runner: any CommandRunning = SubprocessCommandRunner()) {
      self.runner = runner
    }

    internal func run(
      executable: URL,
      arguments: [String],
      environment: [String: String]
    ) async throws(XcodeDiscoveryError) -> XcodeToolOutput {
      let output: CommandOutput
      do {
        output = try await runner.run(
          Command(executableURL: executable, arguments: arguments, environment: environment)
        )
      } catch {
        switch error {
        case .cancelled:
          throw .cancelled
        case .launchFailed(let description), .unreadableOutput(let description):
          let command =
            ([executable.path(percentEncoded: false)] + arguments).joined(separator: " ")
          throw .launchFailed(command: command, description: description)
        }
      }
      return XcodeToolOutput(
        standardOutput: output.standardOutput,
        standardError: output.standardError,
        exitCode: Int32(output.termination.status)
      )
    }
  }
#endif
