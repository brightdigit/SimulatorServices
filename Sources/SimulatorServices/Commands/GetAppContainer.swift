//
//  GetAppContainer.swift
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

/// Get an app container directory based on the bundle identifier.
public struct GetAppContainer: Subcommand {
  /// Path type.
  public typealias OutputType = Path

  /// Bundle identifier of the app container.
  public let appBundleIdentifier: String
  /// ``ContainerID`` directory path to fetch.
  public let container: ContainerID
  /// ``SimulatorID`` of the device to query.
  public let simulator: SimulatorID

  /// Arguments to pass to `simctl`
  public var arguments: [String] {
    [
      "get_app_container",
      simulator.description,
      appBundleIdentifier,
      container.description,
    ]
  }

  /// Create a call to `simctl` for fetching the app container directory.
  /// - Parameters:
  ///   - appBundleIdentifier: Bundle identiifier of the app.
  ///   - container: The ``ContainerID`` of the type of directory to fetch.
  ///   - simulator: The ``SimulatorID`` of the simulator device you are querying.
  public init(
    appBundleIdentifier: String,
    container: ContainerID = .app,
    simulator: SimulatorID = .booted
  ) {
    self.appBundleIdentifier = appBundleIdentifier
    self.container = container
    self.simulator = simulator
  }

  /// Parse the data from the call to `simctl`
  /// - Parameter data: Stanard output from the `simctl` call.
  /// - Returns: ``Path`` to the directory queried.
  /// - Throws: ``SimCtlError/unreadableOutput(arguments:_:)`` if `simctl`
  ///   printed nothing, likely because the simulator doesn't have the app,
  ///   or text that isn't UTF-8.
  public func parse(_ data: Data?) throws(SimCtlError) -> Path {
    guard let data, let text = String(bytes: data, encoding: .utf8) else {
      throw .unreadableOutput(arguments: arguments, nil)
    }

    return text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Recovers from the error state thrown by the command line call.
  /// - Parameter error: ``ProcessError`` from an uncaught signal or a timeout.
  /// - Throws: ``SimCtlError`` unless the app has no such container.
  public func recover(_ error: ProcessError) throws(SimCtlError) {
    guard case let .uncaughtSignal(signal) = error,
      let text = signal.data.flatMap({ String(data: $0, encoding: .utf8) })
    else {
      throw .from(error, arguments: arguments)
    }

    let lines = text.components(separatedBy: .newlines)
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }

    guard
      let errorString = lines.last?
        .trimmingCharacters(in: .whitespacesAndNewlines)
    else {
      throw .from(error, arguments: arguments)
    }

    guard errorString == "No such file or directory" else {
      throw .from(error, arguments: arguments)
    }
  }
}
