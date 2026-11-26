//
//  XcodePreference.swift
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

/// Which Xcode to use: Automatic, or a pinned Xcode.
///
/// ``XcodeResolution/resolve(_:pinnedXcode:canonicalURL:)`` takes its
/// ``pinnedXcode``. Store it as its ``rawValue``.
public enum XcodePreference: Sendable, Hashable, RawRepresentable {
  /// `xcode-select`'s Xcode, or else the newest installed one.
  case automatic
  /// This Xcode app bundle. If it's deleted, Automatic applies.
  case pinned(URL)

  /// The pinned app bundle, or `nil` for Automatic.
  public var pinnedXcode: URL? {
    guard case .pinned(let url) = self else {
      return nil
    }
    return url
  }

  /// An empty string for Automatic, otherwise the pinned bundle's path.
  public var rawValue: String {
    pinnedXcode?.path(percentEncoded: false) ?? ""
  }

  /// Reads a stored value.
  ///
  /// An empty string is Automatic.
  public init(rawValue: String) {
    self =
      rawValue.isEmpty
      ? .automatic
      : .pinned(URL(filePath: rawValue, directoryHint: .isDirectory))
  }
}
