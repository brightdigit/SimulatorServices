//
//  RawDefined.swift
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

public protocol RawDefined {
  associatedtype RawAvailableOptions: RawRepresentable

  init(rawOption: RawAvailableOptions)
  static func unknown(_ rawValue: RawAvailableOptions.RawValue) -> Self
  func unknownValue() -> RawAvailableOptions.RawValue?
}

extension RawDefined where Self: Decodable, Self.RawAvailableOptions.RawValue: Decodable {
  public init(rawValue: RawAvailableOptions.RawValue) {
    if let rawValueOption = RawAvailableOptions(rawValue: rawValue) {
      self.init(rawOption: rawValueOption)
    } else {
      self = .unknown(rawValue)
    }
  }

  public init(from decoder: any Decoder) throws {
    let rawValueString = try decoder.singleValueContainer().decode(RawAvailableOptions.RawValue.self)
    self.init(rawValue: rawValueString)
  }
}

extension RawDefined where Self: CaseIterable, Self.RawAvailableOptions: CaseIterable {
  public static var allCases: [Self] { RawAvailableOptions.allCases.map(Self.init(rawOption:))
  }
}

public protocol RawReversable {
  associatedtype OptionType: RawDefined

  init?(option: OptionType)
}

extension RawDefined where Self.RawAvailableOptions: RawReversable, Self.RawAvailableOptions.OptionType == Self {
  public var underlyingValue: RawAvailableOptions.RawValue {
    switch (RawAvailableOptions(option: self), unknownValue()) {
    case let (.some(value), _):
      return value.rawValue

    case let (.none, .some(value)):
      return value

    case (.none, .none):
      fatalError("Invalid state should never happen.")
    }
  }
}

extension RawDefined where Self: CustomStringConvertible, Self.RawAvailableOptions: RawReversable, Self.RawAvailableOptions.OptionType == Self, Self.RawAvailableOptions.RawValue: CustomStringConvertible {
  public var description: String {
    underlyingValue.description
  }
}
