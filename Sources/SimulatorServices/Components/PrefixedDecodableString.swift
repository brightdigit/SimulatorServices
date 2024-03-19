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

public protocol PrefixedDecodableString: Decodable {
  init(suffix: any StringProtocol) throws
  static var decodableStringPrefix: String {
    get
  }
}

extension PrefixedDecodableString {
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

extension PrefixedDecodableString {
  public init(from decoder: any Decoder) throws {
    let suffixValue = try decoder.decodeSuffix(for: Self.self)
    try self.init(suffix: suffixValue)
  }
}

extension PrefixedDecodableString where Self: RawDefined, Self.RawAvailableOptions.RawValue == String {
  public init(suffix: any StringProtocol) throws {
    self.init(rawValue: .init(suffix))
  }

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

extension Decoder {
  func decodeSuffix(for decodable: (some PrefixedDecodableString).Type) throws -> any StringProtocol {
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
  var context: DecodingError.Context? {
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

  func prefixMismatchStringValue() throws -> String {
    guard let prefixMismatchError = context?.underlyingError as? PrefixMismatchError else {
      throw self
    }

    return prefixMismatchError.singleStringValue
  }
}

struct PrefixMismatchError: Error {
  let singleStringValue: String
}
