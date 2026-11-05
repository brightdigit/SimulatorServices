//
//  RawMapped.swift
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

/// A ``RawDefined`` type whose known cases map one-to-one to its raw options.
///
/// Declare the mapping once in ``rawOptions``. ``RawDefined/init(rawOption:)``
/// and ``RawReversable/init(option:)`` both look it up.
public protocol RawMapped: RawDefined, Hashable, Sendable
where RawAvailableOptions: Hashable & Sendable {
  /// Each raw option and the case it stands for.
  static var rawOptions: BidirectionalMap<RawAvailableOptions, Self> { get }
}

extension RawMapped {
  /// The case for a raw option.
  ///
  /// Every raw option is in ``rawOptions``; if one is missing, that's a bug,
  /// and the value is kept as ``RawDefined/unknown(_:)``.
  public init(rawOption: RawAvailableOptions) {
    guard let value = Self.rawOptions[left: rawOption] else {
      assertionFailure("\(rawOption) is missing from \(Self.self).rawOptions.")
      self = .unknown(rawOption.rawValue)
      return
    }
    self = value
  }
}

extension RawReversable
where OptionType: RawMapped, OptionType.RawAvailableOptions == Self {
  /// The raw option for a known case, or `nil` for an unknown one.
  public init?(option: OptionType) {
    guard let value = OptionType.rawOptions[right: option] else {
      return nil
    }
    self = value
  }
}
