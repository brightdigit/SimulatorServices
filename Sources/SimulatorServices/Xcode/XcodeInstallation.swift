//
//  XcodeInstallation.swift
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
/// An installed copy of Xcode.
public struct XcodeInstallation: Sendable, Hashable, Codable, Identifiable {
  /// The app bundle, for example `/Applications/Xcode.app`.
  public let url: URL
  /// The marketing version, for example `"27.2"`, with no beta suffix.
  public let version: String
  /// The build, for example `"27B48"`, if the bundle has one.
  public let build: String?

  /// The bundle's URL.
  public var id: URL {
    url
  }

  /// The value for `DEVELOPER_DIR`: `<app>/Contents/Developer`.
  public var developerDirectory: URL {
    SimCtl.developerDirectory(for: url)
  }

  /// Creates an installation.
  public init(url: URL, version: String, build: String?) {
    self.url = url
    self.version = version
    self.build = build
  }
}
