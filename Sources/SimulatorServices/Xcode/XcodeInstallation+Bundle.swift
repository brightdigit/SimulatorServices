//
//  XcodeInstallation+Bundle.swift
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

// Reads an Xcode app bundle's identity, version and build from its plists.
extension XcodeInstallation {
  /// Xcode's `CFBundleIdentifier`.
  public static let bundleIdentifier = "com.apple.dt.Xcode"

  /// Creates an installation from the bundle's plists, or returns `nil` if
  /// it isn't Xcode or has no version.
  ///
  /// The version and build come from `Contents/version.plist`
  /// (`CFBundleShortVersionString`, `ProductBuildVersion`) first, because
  /// that's what `xcodebuild -version` reports. `Info.plist`'s
  /// `DTXcodeBuild` can be one build behind (Xcode 27.2 has `27B47` there
  /// and `27B48` in `version.plist`), so it's only a fallback.
  ///
  /// - Parameters:
  ///   - url: The `.app` bundle.
  ///   - infoPlist: `Contents/Info.plist`.
  ///   - versionPlist: `Contents/version.plist`, if there is one.
  public init?(
    bundleAt url: URL,
    infoPlist: Data,
    versionPlist: Data?
  ) {
    guard
      let info = Self.dictionary(infoPlist),
      info["CFBundleIdentifier"] as? String == Self.bundleIdentifier
    else {
      return nil
    }
    let version = versionPlist.flatMap(Self.dictionary) ?? [:]
    guard
      let marketingVersion = Self.nonEmpty(version["CFBundleShortVersionString"])
        ?? Self.nonEmpty(info["CFBundleShortVersionString"])
    else {
      return nil
    }
    self.init(
      url: url.asDirectory,
      version: marketingVersion,
      build: Self.nonEmpty(version["ProductBuildVersion"])
        ?? Self.nonEmpty(info["DTXcodeBuild"])
    )
  }

  private static func dictionary(_ data: Data) -> [String: Any]? {
    let plist = try? PropertyListSerialization.propertyList(from: data, format: nil)
    return plist as? [String: Any]
  }

  private static func nonEmpty(_ value: Any?) -> String? {
    guard
      let string = (value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
      !string.isEmpty
    else {
      return nil
    }
    return string
  }
}
