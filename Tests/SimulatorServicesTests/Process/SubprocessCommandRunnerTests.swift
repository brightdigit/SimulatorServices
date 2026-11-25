//
//  SubprocessCommandRunnerTests.swift
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
  import Testing

  @testable import SimulatorServices

  /// Runs `<simctl> 30`, which `/bin/sleep` takes as 30 seconds.
  private struct SleepSubcommand: Subcommand {
    typealias OutputType = Void
    var arguments: [String] { ["30"] }
    func parse(_: Data?) throws(SimCtlError) {}
  }

  /// The live runner, against harmless system tools.
  @Suite("Subprocess command runner")
  internal struct SubprocessCommandRunnerTests {
    private let runner = SubprocessCommandRunner()

    private func command(
      _ path: String,
      _ arguments: [String] = [],
      environment: [String: String]? = nil
    ) -> Command {
      Command(
        executableURL: URL(fileURLWithPath: path),
        arguments: arguments,
        environment: environment
      )
    }

    @Test("Standard output and a zero exit")
    internal func standardOutput() async throws {
      let output = try await runner.run(command("/bin/echo", ["hello"]))
      #expect(output.termination == .exited(0))
      #expect(String(decoding: output.standardOutput, as: UTF8.self) == "hello\n")
      #expect(output.standardError.isEmpty)
    }

    @Test("A non-zero exit is output, not an error, and keeps standard error")
    internal func nonZeroExit() async throws {
      let output = try await runner.run(
        command("/bin/sh", ["-c", "echo out; echo err >&2; exit 3"])
      )
      #expect(output.termination == .exited(3))
      #expect(String(decoding: output.standardOutput, as: UTF8.self) == "out\n")
      #expect(String(decoding: output.standardError, as: UTF8.self) == "err\n")
    }

    @Test("A custom environment replaces the inherited one")
    internal func customEnvironment() async throws {
      let output = try await runner.run(
        command("/usr/bin/env", environment: ["ONLY": "this"])
      )
      #expect(String(decoding: output.standardOutput, as: UTF8.self) == "ONLY=this\n")
    }

    @Test("No environment inherits this process's")
    internal func inheritedEnvironment() async throws {
      let output = try await runner.run(command("/usr/bin/env"))
      let text = String(decoding: output.standardOutput, as: UTF8.self)
      #expect(text.contains("PATH="))
    }

    @Test("A missing executable fails to launch")
    internal func missingExecutable() async {
      await #expect(throws: CommandError.self) {
        try await runner.run(command("/nonexistent/\(UUID().uuidString)"))
      }
    }

    @Test("Large standard error doesn't stall standard output")
    internal func largeStandardError() async throws {
      // 256 KB to standard error, more than a pipe buffer holds.
      let output = try await runner.run(
        command(
          "/bin/sh",
          ["-c", "head -c 262144 /dev/zero >&2; echo done"]
        )
      )
      #expect(output.standardError.count == 262_144)
      #expect(String(decoding: output.standardOutput, as: UTF8.self) == "done\n")
    }

    @Test("Cancelling the task terminates the command", .timeLimit(.minutes(1)))
    internal func cancellation() async {
      let runner = runner
      let task = Task {
        try await runner.run(
          Command(
            executableURL: URL(fileURLWithPath: "/bin/sleep"),
            arguments: ["30"],
            environment: nil
          )
        )
      }
      try? await Task.sleep(for: .milliseconds(200))
      let start = ContinuousClock.now
      task.cancel()
      let result = await task.result
      #expect(ContinuousClock.now - start < .seconds(10))
      #expect(throws: CommandError.cancelled) { try result.get() }
    }

    @Test("SimCtl maps a cancelled call to SimCtlError.cancelled")
    internal func simCtlCancellation() async {
      let simCtl = SimCtl(
        xcRunURL: URL(fileURLWithPath: "/bin/sleep"),
        simCtlURL: URL(fileURLWithPath: "/bin/sleep"),
        runner: SubprocessCommandRunner()
      )
      // An untyped closure: Swift 6.4 crashes emitting a typed-throws
      // `Task` closure here.
      let task = Task {
        try await simCtl.run(SleepSubcommand())
      }
      try? await Task.sleep(for: .milliseconds(200))
      task.cancel()
      await #expect(throws: SimCtlError.cancelled(arguments: ["30"])) {
        try await task.value
      }
    }
  }
#endif
