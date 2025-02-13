//
//  PrefixedDecodableString.swift
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

/// A structure representing an error when there is a prefix mismatch.
public struct PrefixMismatchError: Error {
  /// The single string value causing the prefix mismatch error.
  public let singleStringValue: String
}

/// A protocol for types that can be decoded from strings with a specific prefix.
public protocol PrefixedDecodableString: Decodable, LosslessStringConvertible {
  /// The prefix expected for decoding the string.
  static var decodableStringPrefix: String { get }

  /// The suffix part of the string after removing the prefix.
  var suffix: String { get }

  /// Initializes an instance of the conforming type with a provided suffix.
  init(suffix: any StringProtocol) throws
}

extension PrefixedDecodableString {
  /// A textual representation of the instance, including the prefix and suffix.
  public var description: String { Self.decodableStringPrefix + suffix }

  /// Initializes an instance by decoding from the given decoder.
  ///
  /// - Parameter decoder: The decoder to read data from.
  /// - Throws: Any errors encountered during decoding.
  public init(from decoder: any Decoder) throws {
    let suffixValue = try decoder.decodeSuffix(for: Self.self)
    try self.init(suffix: suffixValue)
  }

  /// Initializes an instance by converting the given string.
  ///
  /// - Parameter description: The string to convert.
  public init?(_ description: String) {
    guard let suffix = try? Self.suffix(forString: description) else {
      return nil
    }
    try? self.init(suffix: suffix)
  }

  /// Retrieves the suffix from a given string by removing the prefix.
  ///
  /// - Parameter value: The string from which to retrieve the suffix.
  /// - Returns: The suffix part of the string.
  /// - Throws: A `PrefixMismatchError` if the prefix does not match.
  public static func suffix(forString value: String) throws -> any StringProtocol {
    guard value.starts(with: decodableStringPrefix) else {
      throw PrefixMismatchError(singleStringValue: value)
    }
    return value.suffix(
      from: value.index(
        value.startIndex,
        offsetBy: decodableStringPrefix.count
      )
    )
  }
}
