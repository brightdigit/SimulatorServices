//
//  RuntimeID.swift
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

/// A structure representing a runtime ID.
///
/// Most identifiers are `<platform>-<major>-<minor>`, such as
/// `com.apple.CoreSimulator.SimRuntime.iOS-27-2`. A runtime made for
/// specific hardware adds a ``variant``, such as
/// `com.apple.CoreSimulator.SimRuntime.iOS-27-2-iPhone19-4`
/// (seen with Xcode 27.1 on 2026-10-29).
public struct RuntimeID: PrefixedDecodableString, Equatable, Hashable, Sendable {
  /// The prefix used for decoding strings.
  public static let decodableStringPrefix = "com.apple.CoreSimulator.SimRuntime."

  /// The platform of the runtime.
  public let platform: Platform

  /// The version of the runtime.
  public let version: Version

  /// What follows the version, such as `iPhone19-4`, or `nil` for none.
  public let variant: String?

  /// The suffix part of the runtime ID.
  public var suffix: String {
    var values: [any CustomStringConvertible] = [
      platform, version.majorVersion, version.minorVersion,
    ]
    if let variant {
      values.append(variant)
    }
    return values.map(\.description).joined(separator: "-")
  }

  /// Initializes a runtime ID with the given platform and version.
  ///
  /// - Parameters:
  ///   - platform: The platform of the runtime.
  ///   - version: The version of the runtime.
  ///   - variant: What follows the version, such as `iPhone19-4`.
  public init(platform: Platform, version: Version, variant: String? = nil) {
    self.platform = platform
    self.version = version
    self.variant = variant
  }

  /// Initializes a runtime ID with the given suffix.
  ///
  /// - Parameter suffix: The suffix part of the runtime ID.
  /// - Throws: `DecodingError.dataCorrupted` if it isn't
  ///   `<platform>-<major>-<minor>[-<variant>]`.
  public init(suffix: any StringProtocol) throws(DecodingError) {
    let values = suffix.components(separatedBy: "-")
    let versionValues = values.dropFirst().prefix(2).compactMap(Int.init)
    guard values.count >= 3, versionValues.count == 2 else {
      throw .dataCorrupted(
        .init(codingPath: [], debugDescription: "Invalid value: \"\(suffix)\"")
      )
    }
    let platform = Platform(rawValue: values[0])
    let version = Version(majorVersion: versionValues[0], minorVersion: versionValues[1])
    let variant = values.count > 3 ? values[3...].joined(separator: "-") : nil
    self.init(platform: platform, version: version, variant: variant)
  }
}
