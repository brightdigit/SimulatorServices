//
//  GetAppContainer.swift
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

/// Get an app container directory based on the bundle identifier.
public struct GetAppContainer: Subcommand {
  /// Path type.
  public typealias OutputType = Path

  /// Error type thrown by this ``Subcommand``
  public enum Error: Swift.Error, Equatable {
    /// Nothing was returned. Likely the simulator specified does not contain this app.
    case missingData
    /// Data returned by the call is invalid.
    case invalidData(Data)
  }

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
      container.description
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
  /// - Throws: ``Error`` if the standard output data is nil or invalid.
  public func parse(_ data: Data?) throws -> Path {
    guard let data else {
      throw Error.missingData
    }

    guard let text = String(bytes: data, encoding: .utf8) else {
      throw Error.invalidData(data)
    }

    return text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Recovers from the error state thrown by the command line call.
  /// - Parameter error: ``ProcessError`` from an uncaught signal or a timeout.
  public func recover(_ error: ProcessError) throws {
    guard case let .uncaughtSignal(signal) = error else {
      throw error
    }

    guard let text = signal.data.flatMap({ String(data: $0, encoding: .utf8) }) else {
      throw error
    }

    let lines = text.components(separatedBy: .newlines)
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }

    guard let errorString = lines.last?
      .trimmingCharacters(in: .whitespacesAndNewlines) else {
      throw error
    }

    guard errorString == "No such file or directory" else {
      throw error
    }
  }
}
