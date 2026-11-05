//
//  CommandFixture.swift
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
import XCTest

@testable import SimulatorServices

/// One `simctl` command recorded as `commands/<name>.{stdout,stderr,exit}`,
/// copied from Stewed's `docs/fixtures/simctl/`.
internal struct CommandFixture {
  /// Thrown when a fixture expected to fail runs successfully.
  internal struct UnexpectedSuccess: Error {
    internal let name: String
  }

  /// The UDID or identifier the `*-unknown` fixtures used.
  internal static let unknownID = uuid("00000000-0000-0000-0000-000000000000")

  /// The iPhone 18 Pro (iOS 27.0) the `boot` and `shutdown` fixtures used.
  internal static let device = uuid("573A75A3-913D-4A4B-9080-FCDDB62C728C")

  /// The iOS 16.0 disk image the `runtime-delete-ios16` fixtures deleted.
  internal static let iOS16Image = uuid("C4C5640A-D49F-4CDE-A854-95F829558242")

  /// The watchOS 9.4 disk image the `runtime-delete-watchos94` fixture deleted.
  internal static let watchOS94Image = uuid("A2DC8602-3A2A-4BE7-8433-0B4BDDC129AD")

  /// The recording the fixture belongs to.
  internal let recording: RuntimeListFixture
  /// The file name without its extension.
  internal let name: String

  internal init(_ recording: RuntimeListFixture, _ name: String) {
    self.recording = recording
    self.name = name
  }

  private static func uuid(_ string: String) -> UUID {
    guard let uuid = UUID(uuidString: string) else {
      preconditionFailure("Invalid UUID \(string)")
    }
    return uuid
  }

  private func data(_ pathExtension: String) throws -> Data {
    let url = try XCTUnwrap(
      Bundle.module.url(
        forResource: name,
        withExtension: pathExtension,
        subdirectory: "Resources/simctl/\(recording.rawValue)/commands"
      ),
      "Missing fixture \(recording.rawValue)/commands/\(name).\(pathExtension)"
    )
    return try Data(contentsOf: url)
  }

  /// The recorded exit status.
  internal func status() throws -> Int {
    let text = try XCTUnwrap(String(bytes: try data("exit"), encoding: .utf8))
    return try XCTUnwrap(Int(text.trimmingCharacters(in: .whitespacesAndNewlines)))
  }

  /// The recorded standard error.
  internal func standardError() throws -> Data { try data("stderr") }

  /// The recorded standard output.
  internal func standardOutput() throws -> Data { try data("stdout") }

  /// What the process would return: standard output for exit status 0,
  /// otherwise a ``ProcessError`` like the one `Process` throws.
  internal func result() throws -> Result<Data?, ProcessError> {
    let signal = UncaughtSignal(
      reason: 1,
      status: try status(),
      data: try standardError(),
      output: try standardOutput()
    )
    guard let signal else {
      return .success(try standardOutput())
    }
    return .failure(.uncaughtSignal(signal))
  }

  /// Run a subcommand through ``SimCtl`` with a process that replays this fixture.
  internal func run<SubcommandType: Subcommand>(
    _ subcommand: SubcommandType
  ) async throws -> SubcommandType.OutputType {
    let process = MockSimCtlProcess(result: try result())
    let simctl = SimCtl(
      xcRunURL: URL(fileURLWithPath: "/usr/bin/xcrun"),
      processFactory: process
    )
    return try await simctl.run(subcommand)
  }

  /// Run a subcommand that this fixture makes fail.
  /// - Returns: The ``SimCtlError/Failure`` it throws.
  internal func error<SubcommandType: Subcommand>(
    running subcommand: SubcommandType
  ) async throws -> SimCtlError.Failure {
    do {
      _ = try await run(subcommand)
    } catch let SimCtlError.failed(failure) {
      return failure
    }
    throw UnexpectedSuccess(name: name)
  }
}
