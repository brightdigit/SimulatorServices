//
//  Platform.swift
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

/// An enumeration representing different platforms.
/// Use this enumeration to represent various platforms such as iOS, tvOS, watchOS, xrOS,
/// or an unknown platform with a custom string.
///
/// Example usage:
/// ```
/// let platform: Platform = .iOS
/// print(platform) // Output: iOS
/// ```
///
/// - Note: If a platform is unknown,
/// it can be represented using the `.unknown` case with a custom string.
public enum Platform {
  /// Represents the iOS platform.
  case iOS

  /// Represents the tvOS platform.
  case tvOS

  /// Represents the watchOS platform.
  case watchOS

  /// Represents the xrOS platform.
  case xrOS

  /// Represents an unknown platform with a custom string.
  case unknown(String)

  /// An enumeration representing the available raw options for the platform.
  ///
  /// Use this enumeration to map raw options to platforms and vice versa.
  ///
  /// Example usage:
  /// ```
  /// let rawOption: Platform.RawAvailableOptions = .iOS
  /// let platform = Platform(rawOption: rawOption)
  /// print(platform) // Output: iOS
  /// ```
  public enum RawAvailableOptions: String, Sendable, RawReversable, CaseIterable {
    case iOS
    case tvOS
    case watchOS
    case xrOS
  }

  /// Names to show for platforms whose raw value isn't the name people use.
  ///
  /// `simctl` still calls visionOS `xrOS`.
  public static let displayNames: [Platform: String] = [.xrOS: "visionOS"]

  /// Each raw option and the case it stands for.
  public static let rawOptions: BidirectionalMap<RawAvailableOptions, Self> = [
    .iOS: .iOS,
    .tvOS: .tvOS,
    .watchOS: .watchOS,
    .xrOS: .xrOS,
  ]

  /// The name to show for this platform: its entry in ``displayNames``,
  /// otherwise its raw value, such as `iOS`.
  public var displayName: String {
    Self.displayNames[self] ?? underlyingValue
  }

  /// Retrieves the custom string for an unknown platform.
  ///
  /// - Returns: The custom string representing the unknown platform if applicable,
  ///  otherwise nil.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}

extension Platform: RawDefined {}
extension Platform: Equatable {}
extension Platform: Decodable {}
extension Platform: Sendable {}
extension Platform: RandomEnum {}
extension Platform: Hashable {}
extension Platform: CustomStringConvertible {}

extension Platform: RawMapped {}

extension Platform.RawAvailableOptions {
  /// The type these options stand for.
  public typealias OptionType = Platform
}
