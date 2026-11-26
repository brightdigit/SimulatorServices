//
//  XcodeToolOutput.swift
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

/// What one run of `xcode-select` or `mdfind` printed, and its exit status.
public struct XcodeToolOutput: Sendable, Hashable {
  /// Standard output.
  public let standardOutput: Data
  /// Standard error.
  public let standardError: Data
  /// The exit status.
  public let exitCode: Int32

  /// Creates an output.
  public init(standardOutput: Data, standardError: Data = Data(), exitCode: Int32 = 0) {
    self.standardOutput = standardOutput
    self.standardError = standardError
    self.exitCode = exitCode
  }
}

extension XcodeToolOutput {
  private var lines: [String] {
    // Invalid UTF-8 is replaced, not dropped, so a path still shows in errors.
    // swiftlint:disable:next optional_data_string_conversion
    String(decoding: standardOutput, as: UTF8.self)
      .split(whereSeparator: \.isNewline)
      .map { $0.trimmingCharacters(in: .whitespaces) }
  }

  /// The one absolute path `xcode-select -p` prints, as a directory.
  ///
  /// - Parameter command: The command line, for errors.
  /// - Returns: The developer directory, marked as a directory.
  /// - Throws: ``XcodeDiscoveryError`` for a non-zero exit (with stderr
  ///   verbatim), no output, or a relative path.
  public func developerDirectory(
    command: String = "xcode-select -p"
  ) throws(XcodeDiscoveryError) -> URL {
    guard exitCode == 0 else {
      throw .commandFailed(
        command: command,
        exitCode: exitCode,
        // swiftlint:disable:next optional_data_string_conversion
        standardError: String(decoding: standardError, as: UTF8.self)
      )
    }
    let firstLine = lines.first { !$0.isEmpty }
    guard let firstLine else {
      throw .emptyOutput(command: command)
    }
    guard firstLine.hasPrefix("/") else {
      throw .notAnAbsolutePath(command: command, output: firstLine)
    }
    return URL(filePath: firstLine, directoryHint: .isDirectory)
  }

  /// The app bundles `mdfind` listed, one path per line.
  ///
  /// Blank lines, relative paths and anything in a Trash are skipped. A
  /// failed search gives no results, since Spotlight only supplements the
  /// folder scan.
  public func spotlightResults() -> [URL] {
    guard exitCode == 0 else {
      return []
    }
    return
      lines
      .filter { line in
        line.hasPrefix("/")
          && !line.contains("/.Trash/")
          && !line.contains("/.Trashes/")
      }
      .map { URL(filePath: $0, directoryHint: .isDirectory) }
  }
}
