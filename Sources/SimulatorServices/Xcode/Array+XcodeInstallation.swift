//
//  Array+XcodeInstallation.swift
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

// Pure rules for choosing among installed Xcodes: ordering and
// matching a developer directory.
//
// Anything that needs symlinks resolved takes a `canonicalURL` function, so
// the file-system lookup stays with the caller and tests can pass `{ $0 }`.
extension Array where Element == XcodeInstallation {
  private static func isOrderedBefore(
    _ lhs: XcodeInstallation,
    _ rhs: XcodeInstallation
  ) -> Bool {
    let left = VersionNumber(lhs.version)
    let right = VersionNumber(rhs.version)
    if let left, let right, left != right {
      return left > right
    }
    if (left == nil) != (right == nil) {
      // A version that parses sorts before one that doesn't.
      return left != nil
    }
    return lhs.url.path(percentEncoded: false) < rhs.url.path(percentEncoded: false)
  }

  /// These installations without duplicates, newest version first.
  ///
  /// A duplicate is one bundle reached through a symlink, or found by both
  /// the folder scan and Spotlight; the first URL seen is kept. Equal
  /// versions are ordered by path.
  public func normalized(canonicalURL: (URL) -> URL) -> Self {
    var seen = Set<String>()
    let unique = filter { installation in
      seen.insert(canonicalURL(installation.url).pathKey).inserted
    }
    return unique.sorted(by: Self.isOrderedBefore)
  }

  /// The installation whose developer directory is `directory`, comparing
  /// canonical paths on both sides.
  public func installation(
    forDeveloperDirectory directory: URL,
    canonicalURL: (URL) -> URL
  ) -> XcodeInstallation? {
    let target = canonicalURL(directory).pathKey
    return first { installation in
      canonicalURL(installation.developerDirectory).pathKey == target
    }
  }
}
