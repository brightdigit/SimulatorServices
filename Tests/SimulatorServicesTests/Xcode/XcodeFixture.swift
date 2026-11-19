//
//  XcodeFixture.swift
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

@testable import SimulatorServices

/// Reads the recorded Xcode discovery fixtures in `Resources/xcode/`
/// and builds test installations and plists.
internal enum XcodeFixture {
  /// A recorded file is missing from the test bundle.
  internal struct MissingResource: Error {
    internal let name: String
  }

  /// The recording directory.
  internal static let recording = "xcode-27.2-27B48"

  /// Xcode 27.1 in `/Applications/Xcode.app`.
  internal static let xcode = installation("Xcode.app", "27.1", "27A9275")
  /// Xcode 27.2 beta in `/Applications/Xcode-beta.app`.
  internal static let beta = installation("Xcode-beta.app", "27.2", "27B5028f")

  /// A recorded file's contents.
  internal static func data(_ name: String) throws -> Data {
    let url = Bundle.module.url(
      forResource: name,
      withExtension: nil,
      subdirectory: "Resources/xcode/\(recording)"
    )
    guard let url else {
      throw MissingResource(name: name)
    }
    return try Data(contentsOf: url)
  }

  /// An installation in `/Applications`.
  internal static func installation(
    _ name: String,
    _ version: String,
    _ build: String? = nil
  ) -> XcodeInstallation {
    XcodeInstallation(
      url: directoryURL("/Applications/\(name)"),
      version: version,
      build: build
    )
  }

  /// A path marked as a directory.
  internal static func directoryURL(_ path: String) -> URL {
    URL(filePath: path, directoryHint: .isDirectory)
  }

  /// Command output with `text` on stdout.
  internal static func output(
    _ text: String,
    exitCode: Int32 = 0,
    standardError: String = ""
  ) -> XcodeToolOutput {
    XcodeToolOutput(
      standardOutput: Data(text.utf8),
      standardError: Data(standardError.utf8),
      exitCode: exitCode
    )
  }

  /// An XML plist with the given string values.
  internal static func plist(_ values: [String: String]) throws -> Data {
    try PropertyListSerialization.data(fromPropertyList: values, format: .xml, options: 0)
  }
}
