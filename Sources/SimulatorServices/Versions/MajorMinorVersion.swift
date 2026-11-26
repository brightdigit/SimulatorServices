//
//  MajorMinorVersion.swift
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

/// The `X.Y` part of a version, the key for "same version".
///
/// Two runtimes of the same platform are the same version when their
/// `MajorMinorVersion` values are equal, so `27.1` and `27.1.1` share a key
/// while `27.1` and `27.2` don't.
public struct MajorMinorVersion: Sendable, Hashable, Comparable, CustomStringConvertible {
  /// The major version, `X`.
  public let major: Int
  /// The minor version, `Y`.
  public let minor: Int

  /// `X.Y`, for example `27.1`.
  public var description: String {
    "\(major).\(minor)"
  }

  /// Creates a key from its major and minor components.
  public init(major: Int, minor: Int) {
    self.major = major
    self.minor = minor
  }

  /// Whether `lhs` is an earlier `X.Y` than `rhs`, by major then minor.
  public static func < (lhs: Self, rhs: Self) -> Bool {
    (lhs.major, lhs.minor) < (rhs.major, rhs.minor)
  }
}
