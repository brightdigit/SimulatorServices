//
//  SimCtl+DeveloperDirectory.swift
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
  /// Where `xcode-select` points when only the Command Line Tools are installed.
  ///
  /// It has no `simctl`.
  public static let commandLineToolsDirectory = URL(
    fileURLWithPath: "/Library/Developer/CommandLineTools",
    isDirectory: true
  )

  /// The Xcode app that holds a developer directory.
  ///
  /// The inverse of ``developerDirectory(for:)``.
  /// - Parameter developerDirectory: A directory such as
  ///   `/Applications/Xcode.app/Contents/Developer`, as `xcode-select -p` prints.
  /// - Returns: The `.app`, or `nil` for anything else, such as the
  ///   Command Line Tools.
  public static func xcodeURL(forDeveloperDirectory developerDirectory: URL) -> URL? {
    let standardized = developerDirectory.standardizedFileURL
    guard standardized.pathComponents.suffix(2) == ["Contents", "Developer"] else {
      return nil
    }
    let app = standardized.deletingLastPathComponent().deletingLastPathComponent()
    guard app.pathExtension == "app" else {
      return nil
    }
    return URL(fileURLWithPath: app.path, isDirectory: true)
  }

  /// Whether a developer directory is the Command Line Tools',
  /// with or without a trailing slash.
  public static func isCommandLineTools(_ developerDirectory: URL) -> Bool {
    developerDirectory.standardizedFileURL.path == commandLineToolsDirectory.path
  }

  /// An environment for a process that should use a given Xcode.
  ///
  /// ``SimCtl`` with no ``developerDirectory`` passes its environment through,
  /// so an inherited `DEVELOPER_DIR` still picks the Xcode. Use this to build
  /// an environment where `nil` really means the one `xcode-select` points to,
  /// for example before running `xcode-select -p`, which prints `DEVELOPER_DIR`
  /// when it's set.
  /// - Parameters:
  ///   - base: The environment to start from.
  ///   - developerDirectory: An Xcode app or developer directory,
  ///     or `nil` to remove `DEVELOPER_DIR`.
  /// - Returns: `base` with `DEVELOPER_DIR` set, or removed.
  public static func environment(
    _ base: [String: String],
    developerDirectory: URL?
  ) -> [String: String] {
    var environment = base
    environment[developerDirectoryKey] = developerDirectory.map { directory in
      Self.developerDirectory(for: directory).standardizedFileURL.path
    }
    return environment
  }
}
