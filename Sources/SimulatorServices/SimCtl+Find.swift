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
  /// Errors from resolving `simctl` with `xcrun --find simctl`.
  public enum FindError: Swift.Error, Equatable, Sendable {
    /// `xcrun` printed nothing.
    case missingData
    /// `xcrun` printed something that isn't an absolute path.
    case invalidPath(String)
  }

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
  /// - Returns: The URL of `simctl`.
  /// - Throws: ``FindError`` if the output is empty or isn't an absolute path.
  internal static func parseFindOutput(_ data: Data?) throws -> URL {
    guard let data, let text = String(data: data, encoding: .utf8) else {
      throw FindError.missingData
    }
    let path = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !path.isEmpty else {
      throw FindError.missingData
    }
    guard path.hasPrefix("/"), !path.contains("\n") else {
      throw FindError.invalidPath(path)
    }
    return URL(fileURLWithPath: path)
  }
}
