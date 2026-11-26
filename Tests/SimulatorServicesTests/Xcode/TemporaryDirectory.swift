//
//  TemporaryDirectory.swift
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
#if os(macOS)

  import Foundation

  /// A temporary directory, removed when the value is released.
  package final class TemporaryDirectory: Sendable {
    package let url: URL

    package init() throws {
      url = FileManager.default.temporaryDirectory
        .appending(
          path: "SimulatorServicesTests-\(UUID().uuidString)", directoryHint: .isDirectory
        )
      try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    private static func plist(_ values: [String: String]) throws -> Data {
      try PropertyListSerialization.data(
        fromPropertyList: values,
        format: .xml,
        options: 0
      )
    }

    /// Creates `name` (with intermediate folders) and returns it.
    package func directory(_ name: String) throws -> URL {
      let directory = url.appending(path: name, directoryHint: .isDirectory)
      try FileManager.default.createDirectory(
        at: directory, withIntermediateDirectories: true
      )
      return directory
    }

    /// Writes a minimal app bundle: `Contents/Info.plist` and, when
    /// `version` is given, `Contents/version.plist`.
    @discardableResult
    package func bundle(
      in directory: URL,
      name: String,
      bundleIdentifier: String = "com.apple.dt.Xcode",
      version: String? = nil,
      build: String? = nil
    ) throws -> URL {
      let app = directory.appending(path: name, directoryHint: .isDirectory)
      let contents = app.appending(path: "Contents", directoryHint: .isDirectory)
      try FileManager.default.createDirectory(
        at: contents, withIntermediateDirectories: true
      )
      try Self.plist(["CFBundleIdentifier": bundleIdentifier])
        .write(to: contents.appending(path: "Info.plist"))
      if let version {
        var values = ["CFBundleShortVersionString": version]
        values["ProductBuildVersion"] = build
        try Self.plist(values).write(to: contents.appending(path: "version.plist"))
      }
      return app
    }

    deinit {
      try? FileManager.default.removeItem(at: url)
    }
  }
#endif
