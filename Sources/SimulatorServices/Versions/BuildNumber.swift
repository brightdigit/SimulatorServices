//
//  BuildNumber.swift
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

/// An Apple build such as `24B5089g` or `23F77`, parsed for ordering.
///
/// A build is a leading number, a train letter, a number and an optional
/// suffix letter. Every number is `\d+`, never a fixed
/// width, because recorded builds include `21T575`, `24A434` and `24A94232`.
///
/// Builds compare in that order, numbers numerically, so `24A5318c` is newer
/// than `24A5305f`. A build with no suffix sorts before the same build with
/// one. Whether a build is a beta isn't decided here: a lowercase suffix
/// often means a beta, but not always (an RC can have none, and a
/// device-train final such as `24B91016s` has one), so ask release data.
public struct BuildNumber: Sendable, Hashable, CustomStringConvertible {
  /// The leading number, for example `24` in `24B5089g`.
  public let major: Int
  /// The uppercase train letter, for example `B` in `24B5089g`.
  public let train: Character
  /// The number after the train, for example `5089` in `24B5089g`.
  public let number: Int
  /// The optional lowercase suffix, for example `g` in `24B5089g`.
  public let suffix: Character?

  /// Whether the build is from a device-specific train, with five or more
  /// digits after the letter: iPhone Duo's `24A94232` and `24B91016s`.
  ///
  /// General runtimes have at most four (`24B114`, `24B5089g`, `24B8117`).
  /// A suffix says nothing about beta or final for these builds:
  /// `24B91016s` is a final.
  public var isDeviceTrain: Bool {
    number >= 10_000
  }

  /// The build in Apple's format, for example `24B5089g`.
  public var description: String {
    "\(major)\(train)\(number)" + (suffix.map(String.init) ?? "")
  }

  /// Parses a build such as `24B5089g`, `24B70` or `21T575`.
  ///
  /// Returns `nil` unless the whole string is ASCII digits, one uppercase
  /// letter, ASCII digits, and at most one lowercase letter, with each number
  /// fitting in an `Int`.
  public init?(_ string: some StringProtocol) {
    let bytes = Array(string.utf8)
    var index = bytes.startIndex
    guard
      let major = Self.scanNumber(bytes, from: &index),
      let train = Self.scanByte(bytes, from: &index, where: UInt8.isASCIIUppercase),
      let number = Self.scanNumber(bytes, from: &index)
    else {
      return nil
    }
    let suffix = Self.scanByte(bytes, from: &index, where: UInt8.isASCIILowercase)
    guard index == bytes.endIndex else {
      return nil
    }
    self.major = major
    self.train = Character(Unicode.Scalar(train))
    self.number = number
    self.suffix = suffix.map { Character(Unicode.Scalar($0)) }
  }

  private static func scanNumber(_ bytes: [UInt8], from index: inout Int) -> Int? {
    let start = index
    while index < bytes.endIndex, UInt8.isASCIIDigit(bytes[index]) {
      index += 1
    }
    guard start < index else {
      return nil
    }
    // The bytes are ASCII digits, so decoding can't replace anything.
    // swiftlint:disable:next optional_data_string_conversion
    return Int(asciiDigits: String(decoding: bytes[start..<index], as: UTF8.self))
  }

  private static func scanByte(
    _ bytes: [UInt8],
    from index: inout Int,
    where predicate: (UInt8) -> Bool
  ) -> UInt8? {
    guard index < bytes.endIndex, predicate(bytes[index]) else {
      return nil
    }
    defer { index += 1 }
    return bytes[index]
  }
}

extension BuildNumber: Comparable {
  /// Whether `lhs` is older: compares the leading number, the train, the
  /// number, then the suffix, where no suffix sorts first.
  public static func < (lhs: Self, rhs: Self) -> Bool {
    if lhs.major != rhs.major {
      return lhs.major < rhs.major
    }
    if lhs.train != rhs.train {
      return lhs.train < rhs.train
    }
    if lhs.number != rhs.number {
      return lhs.number < rhs.number
    }
    switch (lhs.suffix, rhs.suffix) {
    case let (left?, right?):
      return left < right

    case (nil, .some):
      return true

    case (_, nil):
      return false
    }
  }
}
