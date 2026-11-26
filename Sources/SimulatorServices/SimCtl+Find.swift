//
//  SimCtl+Find.swift
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
  /// The developer directory to pass as `DEVELOPER_DIR` for an Xcode.
  /// - Parameter xcodeURL: An Xcode app, or a developer directory.
  /// - Returns: `Contents/Developer` inside an `.app`, otherwise `xcodeURL` itself.
  public static func developerDirectory(for xcodeURL: URL) -> URL {
    guard xcodeURL.pathExtension == "app" else {
      return xcodeURL
    }
    return
      xcodeURL
      .appendingPathComponent("Contents", isDirectory: true)
      .appendingPathComponent("Developer", isDirectory: true)
  }

  /// Parse the output of `xcrun --find simctl`.
  /// - Parameter data: Standard output from `xcrun`.
  /// - Returns: The URL of `simctl`, or `nil` if the output is empty or
  ///   isn't an absolute path.
  internal static func parseFindOutput(_ data: Data?) -> URL? {
    guard let data, let text = String(data: data, encoding: .utf8) else {
      return nil
    }
    let path = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard path.hasPrefix("/"), !path.contains("\n") else {
      return nil
    }
    return URL(fileURLWithPath: path)
  }

  /// Resolve `simctl` with `xcrun --find simctl`.
  /// - Returns: A copy of this interface that runs the resolved `simctl` directly.
  /// - Throws: ``SimCtlError`` if `xcrun` fails or its output isn't a path.
  internal func find() async throws(SimCtlError) -> SimCtl {
    let arguments = ["--find", "simctl"]
    let data: Data?
    let command = makeCommand(executableURL: xcRunURL, arguments: arguments)
    switch await runToCompletion(command) {
    case .success(let output):
      data = output

    case .failure(.cancelled):
      throw .cancelled(arguments: arguments)

    case .failure(.process(let error)):
      throw .from(error, arguments: arguments)
    }
    guard let simCtlURL = Self.parseFindOutput(data) else {
      throw .unreadableOutput(arguments: arguments, nil)
    }
    return SimCtl(
      xcRunURL: xcRunURL,
      simCtlURL: simCtlURL,
      developerDirectory: developerDirectory,
      environment: baseEnvironment,
      runner: runner
    )
  }
}
