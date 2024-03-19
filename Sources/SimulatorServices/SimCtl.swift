//
//  SimCtl.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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
public struct SimCtl: Sendable {
  /// URL Path to `xcrun`
  public let xcRunURL: URL

  private let processFactory: @Sendable () -> any InternalSimCtlProcess

  internal init(
    xcRunURL: URL,
    processFactory: @escaping @autoclosure @Sendable () -> any InternalSimCtlProcess
  ) {
    self.xcRunURL = xcRunURL
    self.processFactory = processFactory
  }

  #if os(macOS)
    /// Create an interface to `simctl`
    /// - Parameter xcRunURL: URL path to `xcrun`.
    @available(macOS 10.15.4, *)
    public init(xcRunURL: URL = URL(fileURLWithPath: "/usr/bin/xcrun")) {
      self.init(xcRunURL: xcRunURL, processFactory: Process())
    }
  #endif

  /// Run a subcommand under `simctl`.
  /// - Parameter subcommand: subcommand to run.
  /// - Returns: Result of the subcommand.
  public func run<SubcommandType: Subcommand>(
    _ subcommand: SubcommandType
  ) async throws -> SubcommandType.OutputType {
    let process = processFactory()
    process.executableURL = xcRunURL
    process.arguments = ["simctl"] + subcommand.arguments
    let data: Data?
    do {
      data = try await process.run(timeout: .distantFuture)
    } catch let error as ProcessError {
      try subcommand.recover(error)
      data = nil
    }
    return try subcommand.parse(data)
  }
}
