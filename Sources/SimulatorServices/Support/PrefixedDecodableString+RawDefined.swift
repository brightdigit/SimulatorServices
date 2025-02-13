//
//  PrefixedDecodableString+RawDefined.swift
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

extension PrefixedDecodableString
where Self: RawDefined, Self.RawAvailableOptions.RawValue == String {
  /// Initializes an instance with the provided suffix.
  ///
  /// - Parameter suffix: The suffix part of the string after removing the prefix.
  /// - Throws: An error if initialization fails.
  public init(suffix: any StringProtocol) throws { self.init(rawValue: .init(suffix)) }

  /// Initializes an instance by decoding from the given decoder.
  ///
  /// - Parameter decoder: The decoder to read data from.
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

// swift-format-ignore
extension PrefixedDecodableString
where
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
