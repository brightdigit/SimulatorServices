//
//  Decoder+PrefixedDecodableString.swift
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

extension Decoder {
  /// Decode the suffix for a `PrefixedDecodableString` type.
  ///
  /// - Parameter decodable: The type of `PrefixedDecodableString`.
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
    guard
      let prefixMismatchError = context?.underlyingError
        as? PrefixMismatchError
    else {
      throw self
    }

    return prefixMismatchError.singleStringValue
  }
}
