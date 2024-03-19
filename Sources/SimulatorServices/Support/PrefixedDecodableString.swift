//
//  PrefixedDecodableString.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

//
//  PrefixedDecodableString.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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
  public var description: String {
    Self.decodableStringPrefix + suffix
  }

  /// Retrieves the suffix from a given string by removing the prefix.
  ///
  /// - Parameters:
  ///   - value: The string from which to retrieve the suffix.
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

  /// Initializes an instance by decoding from the given decoder.
  ///
  /// - Parameters:
  ///   - decoder: The decoder to read data from.
  /// - Throws: Any errors encountered during decoding.
  public init(from decoder: any Decoder) throws {
    let suffixValue = try decoder.decodeSuffix(for: Self.self)
    try self.init(suffix: suffixValue)
  }

  /// Initializes an instance by converting the given string.
  ///
  /// - Parameters:
  ///   - description: The string to convert.
  /// - Returns: An instance of the conforming type if successful; otherwise, `nil`.
  public init?(_ description: String) {
    guard let suffix = try? Self.suffix(forString: description) else {
      return nil
    }
    try? self.init(suffix: suffix)
  }
}

extension PrefixedDecodableString where
  Self: RawDefined, Self.RawAvailableOptions.RawValue == String {
  /// Initializes an instance with the provided suffix.
  ///
  /// - Parameters:
  ///   - suffix: The suffix part of the string after removing the prefix.
  /// - Throws: An error if initialization fails.
  public init(suffix: any StringProtocol) throws {
    self.init(rawValue: .init(suffix))
  }

  /// Initializes an instance by decoding from the given decoder.
  ///
  /// - Parameters:
  ///   - decoder: The decoder to read data from.
  /// - Throws: Any errors encountered during decoding.
  public init(from decoder: any Decoder) throws {
    let stringValue = try decoder.singleValueContainer().decode(String.self)
    do {
      let suffix = try Self.suffix(forString: stringValue)
      try self.init(suffix: suffix)
    } catch let error as PrefixMismatchError {
      self.init(rawValue: error.singleStringValue)
    }
  }
}

extension PrefixedDecodableString where
  Self: RawDefined,
  Self.RawAvailableOptions.RawValue == String,
  Self.RawAvailableOptions: RawReversable,
  Self.RawAvailableOptions.OptionType == Self {
  /// The suffix part of the string, considering unknown values.
  public var suffix: String {
    if let unknownValue = unknownValue() {
      return unknownValue
    } else if let option = RawAvailableOptions(option: self) {
      return option.rawValue
    } else {
      fatalError("Invalid State")
    }
  }
}

extension Decoder {
  /// Decode the suffix for a `PrefixedDecodableString` type.
  ///
  /// - Parameters:
  ///   - decodable: The type of `PrefixedDecodableString`.
  /// - Throws: A `DecodingError` if decoding fails.
  /// - Returns: The suffix part of the string after removing the prefix.
  internal func decodeSuffix(
    for decodable: (some PrefixedDecodableString).Type
  ) throws -> any StringProtocol {
    let stringValue = try singleValueContainer().decode(String.self)
    do {
      return try decodable.suffix(forString: stringValue)
    } catch let error as PrefixMismatchError {
      throw DecodingError.dataCorrupted(
        .init(
          codingPath: [],
          debugDescription: "Invalid Value: \(error.singleStringValue)",
          underlyingError: error
        )
      )
    }
  }
}

extension DecodingError {
  internal var context: DecodingError.Context? {
    switch self {
    case let .typeMismatch(_, context):
      return context
    case let .valueNotFound(_, context):
      return context
    case let .keyNotFound(_, context):
      return context
    case let .dataCorrupted(context):
      return context
    @unknown default:
      return nil
    }
  }

  /// Retrieve the prefix mismatch string value from the decoding error.
  ///
  /// - Throws: The original error if the underlying error is not a `PrefixMismatchError`.
  /// - Returns: The single string value causing the prefix mismatch.
  internal func prefixMismatchStringValue() throws -> String {
    guard let prefixMismatchError = context?.underlyingError as? PrefixMismatchError else {
      throw self
    }

    return prefixMismatchError.singleStringValue
  }
}
