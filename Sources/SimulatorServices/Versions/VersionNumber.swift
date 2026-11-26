//
//  VersionNumber.swift
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

/// A dotted OS version such as `27.1` or `18.3.1`, compared numerically.
///
/// Versions are compared component by component, never as strings, so
/// `27.1` < `27.1.1` and `27.9` < `27.10`. A missing
/// component counts as zero, so `27.1` and `27.1.0` are equal.
public struct VersionNumber: Sendable, CustomStringConvertible {
  /// The numeric components as parsed, for example `[18, 3, 1]`.
  public let components: [Int]

  /// The `X.Y` key that decides whether two runtimes are "the same version".
  ///
  /// A version with a single component gets a minor of zero.
  public var majorMinor: MajorMinorVersion {
    MajorMinorVersion(
      major: components[0],
      minor: components.count > 1 ? components[1] : 0
    )
  }

  /// The components joined with dots, as parsed.
  public var description: String {
    components.map(String.init).joined(separator: ".")
  }

  /// The components with trailing zeros removed, used for equality and hashing.
  private var significantComponents: ArraySlice<Int> {
    let lastNonZero = components.lastIndex { $0 != 0 } ?? -1
    return components[...lastNonZero]
  }

  /// Parses a dotted version such as `27.1` or `18.3.1`.
  ///
  /// Returns `nil` unless every dot-separated component is one or more ASCII
  /// digits that fit in an `Int`.
  public init?(_ string: some StringProtocol) {
    let parts = string.split(separator: ".", omittingEmptySubsequences: false)
    var components: [Int] = []
    components.reserveCapacity(parts.count)
    for part in parts {
      guard let value = Int(asciiDigits: part) else {
        return nil
      }
      components.append(value)
    }
    self.init(components: components)
  }

  /// Creates a version from its numeric components.
  ///
  /// Returns `nil` if there are no components or any is negative.
  public init?(components: [Int]) {
    guard !components.isEmpty, components.allSatisfy({ $0 >= 0 }) else {
      return nil
    }
    self.components = components
  }
}

extension VersionNumber: Hashable {
  /// Whether both have the same components, ignoring trailing zeros.
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.significantComponents == rhs.significantComponents
  }

  /// Hashes the components without trailing zeros, consistent with `==`.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(Array(significantComponents))
  }
}

extension VersionNumber: Comparable {
  /// Whether `lhs` is earlier, comparing components numerically and
  /// treating missing ones as zero.
  public static func < (lhs: Self, rhs: Self) -> Bool {
    let count = max(lhs.components.count, rhs.components.count)
    for index in 0..<count {
      let left = lhs.components.indices.contains(index) ? lhs.components[index] : 0
      let right = rhs.components.indices.contains(index) ? rhs.components[index] : 0
      if left != right {
        return left < right
      }
    }
    return false
  }
}
