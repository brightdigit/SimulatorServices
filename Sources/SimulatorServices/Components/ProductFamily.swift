//
//  ProductFamily.swift
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

/// The product family of a device.
/// - Note: This enum conforms to several protocols for functionality.
/// - SeeAlso: ``RawAvailableOptions`` for the available raw options.
/// - SeeAlso: ``unknownValue()`` for retrieving the unknown value.
/// - Important: The ``unknown`` case allows for custom product family names.
public enum ProductFamily:
  RawDefined,
  Equatable,
  Decodable,
  Sendable,
  CaseIterable,
  RandomEnum {
  case iPhone
  case iPad
  case appleTV
  case appleWatch
  case appleVision
  case unknown(String)

  /// Available raw options for the product family.
  public enum RawAvailableOptions: String, CaseIterable {
    case iPhone
    case iPad
    case appleTV = "Apple TV"
    case appleWatch = "Apple Watch"
    case appleVision = "Apple Vision"
  }

  /// Initialize with a raw option.
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .iPhone: self = .iPhone
    case .iPad: self = .iPad
    case .appleTV: self = .appleTV
    case .appleWatch: self = .appleWatch
    case .appleVision: self = .appleVision
    }
  }

  /// Retrieve the unknown value if it exists.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
