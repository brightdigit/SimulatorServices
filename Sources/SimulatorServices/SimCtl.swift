//
//  SimCtl.swift
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

/// Interface for running `simctl`.
///
/// By default each subcommand runs as `xcrun simctl <arguments>`.
/// A ``SimCtl`` from ``find(developerDirectory:xcRunURL:)`` runs the `simctl`
/// that `xcrun --find simctl` resolved instead.
/// When ``developerDirectory`` is set, every process gets it as `DEVELOPER_DIR`,
/// so `simctl` comes from that Xcode rather than the one `xcode-select` points to.
public struct SimCtl: Sendable {
  /// The name of the environment variable `xcrun` reads the developer directory from.
  public static let developerDirectoryKey = "DEVELOPER_DIR"

  /// URL Path to `xcrun`
  public let xcRunURL: URL

  /// URL path to `simctl`, as resolved by `xcrun --find simctl`.
  ///
  /// When it's `nil`, subcommands run through `xcrun simctl`.
  public let simCtlURL: URL?

  /// The developer directory passed as `DEVELOPER_DIR` to every process,
  /// or `nil` to use the one `xcode-select` points to.
  public let developerDirectory: URL?

  internal let baseEnvironment: [String: String]
  internal let processFactory: @Sendable () -> any InternalSimCtlProcess

  internal init(
    xcRunURL: URL,
    simCtlURL: URL? = nil,
    developerDirectory: URL? = nil,
    environment: [String: String] = [:],
    processFactory: @escaping @autoclosure @Sendable () -> any InternalSimCtlProcess
  ) {
    self.xcRunURL = xcRunURL
    self.simCtlURL = simCtlURL
    self.developerDirectory = developerDirectory.map(Self.developerDirectory(for:))
    self.baseEnvironment = environment
    self.processFactory = processFactory
  }

  #if os(macOS)
    /// Create an interface to `simctl`
    /// - Parameters:
    ///   - xcRunURL: URL path to `xcrun`.
    ///   - developerDirectory: The Xcode to use, either the app
    ///     (`/Applications/Xcode.app`) or its developer directory
    ///     (`/Applications/Xcode.app/Contents/Developer`). It's passed as
    ///     `DEVELOPER_DIR`. `nil` uses the one `xcode-select` points to.
    @available(macOS 10.15.4, *)
    public init(
      xcRunURL: URL = URL(fileURLWithPath: "/usr/bin/xcrun"),
      developerDirectory: URL? = nil
    ) {
      self.init(
        xcRunURL: xcRunURL,
        developerDirectory: developerDirectory,
        environment: ProcessInfo.processInfo.environment,
        processFactory: Process()
      )
    }

    /// Resolve `simctl` with `xcrun --find simctl` and create an interface to it.
    /// - Parameters:
    ///   - developerDirectory: The Xcode to use, either the app or its developer
    ///     directory. It's passed as `DEVELOPER_DIR`, both to `xcrun --find`
    ///     and to every later `simctl` call.
    ///     `nil` uses the one `xcode-select` points to.
    ///   - xcRunURL: URL path to `xcrun`.
    /// - Returns: An interface that runs the resolved `simctl` directly.
    /// - Throws: ``SimCtlError`` if `xcrun` fails or its output isn't a path.
    @available(macOS 10.15.4, *)
    public static func find(
      developerDirectory: URL?,
      xcRunURL: URL = URL(fileURLWithPath: "/usr/bin/xcrun")
    ) async throws(SimCtlError) -> SimCtl {
      try await SimCtl(
        xcRunURL: xcRunURL,
        developerDirectory: developerDirectory,
        environment: ProcessInfo.processInfo.environment,
        processFactory: Process()
      )
      .find()
    }
  #endif

  internal func makeProcess(
    executableURL: URL,
    arguments: [String]
  ) -> any InternalSimCtlProcess {
    let process = processFactory()
    process.executableURL = executableURL
    process.arguments = arguments
    if let developerDirectory {
      var environment = baseEnvironment
      environment[Self.developerDirectoryKey] = developerDirectory.path
      process.environment = environment
    }
    return process
  }

  /// Run a subcommand under `simctl`.
  /// - Parameter subcommand: subcommand to run.
  /// - Returns: Result of the subcommand.
  /// - Throws: ``SimCtlError`` if the command fails.
  public func run<SubcommandType: Subcommand>(
    _ subcommand: SubcommandType
  ) async throws(SimCtlError) -> SubcommandType.OutputType {
    let process =
      if let simCtlURL {
        makeProcess(executableURL: simCtlURL, arguments: subcommand.arguments)
      } else {
        makeProcess(executableURL: xcRunURL, arguments: ["simctl"] + subcommand.arguments)
      }
    let data: Data?
    do {
      data = try await process.runToCompletion()
    } catch {
      try subcommand.recover(error)
      data = nil
    }
    return try subcommand.parse(data)
  }
}
