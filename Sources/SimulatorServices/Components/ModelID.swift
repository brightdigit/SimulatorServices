//
//  ModelID.swift
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

/// A structure representing a model ID.
public struct ModelID: Decodable, Equatable, Sendable, CustomStringConvertible {
  /// An enumeration representing the name of the model.
  public enum Name: String, Sendable, CaseIterable {
    /// The iPod model.
    case iPod

    /// The iPhone model.
    case iPhone

    /// The iPad model.
    case iPad

    /// The Apple TV model.
    case appleTV = "AppleTV"

    /// The Apple Watch model.
    case appleWatch = "Watch"

    /// The Apple Vision model.
    case appleVision = "RealityDevice"
  }

  /// A structure representing the version of the model.
  public struct Version: Equatable, Sendable {
    /// The major version number.
    public let major: Int

    /// The minor version number.
    public let minor: Int

    /// Initializes a version with the given major and minor numbers.
    ///
    /// - Parameters:
    ///   - major: The major version number.
    ///   - minor: The minor version number.
    public init(major: Int, minor: Int) {
      self.major = major
      self.minor = minor
    }

    // swiftlint:disable:next strict_fileprivate
    fileprivate static func random() -> Version {
      .init(major: .random(in: 2 ... 25), minor: .random(in: 1 ... 9))
    }
  }

  /// The name of the model.
  public let name: Name

  /// The version of the model.
  public let version: Version

  /// A textual representation of the model ID.
  public var description: String {
    "\(name)\(version.major),\(version.minor)"
  }

  /// Initializes a model ID with the given name and version.
  ///
  /// - Parameters:
  ///   - name: The name of the model.
  ///   - version: The version of the model.
  public init(name: ModelID.Name, version: ModelID.Version) {
    self.name = name
    self.version = version
  }

  // swiftlint:disable function_body_length

  /// Initializes a model ID by decoding from the given decoder.
  ///
  /// - Parameter decoder: The decoder to read data from.
  /// - Throws: Any errors encountered during decoding.
  public init(from decoder: any Decoder) throws {
    let stringValue = try decoder.singleValueContainer().decode(String.self)
    let regex = /([a-zA-Z]+)(\d+),(\d+)/
    guard let match = stringValue.firstMatch(of: regex) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: [],
          debugDescription: "String doesn't match pattern: \(stringValue)"
        )
      )
    }
    guard let name = Name(rawValue: String(match.1)) else {
      throw DecodingError.dataCorrupted(
        .init(
          codingPath: [],
          debugDescription: "Unknown product \(match.1)"
        )
      )
    }
    guard let major = Int(match.2) else {
      assertionFailure("Invalid major value: \(match.2)")
      throw DecodingError.valueNotFound(
        Int.self,
        .init(
          codingPath: [],
          debugDescription: "Invalid major value: \(match.2)"
        )
      )
    }
    guard let minor = Int(match.3) else {
      assertionFailure("Invalid minor value: \(match.3)")
      throw DecodingError.valueNotFound(
        Int.self, .init(
          codingPath: [],
          debugDescription: "Invalid minor value: \(match.3)"
        )
      )
    }
    self.init(name: name, version: .init(major: major, minor: minor))
  }

  // swiftlint:enable function_body_length

  /// Generates a random model ID.
  internal static func random() -> ModelID {
    // swiftlint:disable:next force_unwrapping
    .init(name: .allCases.randomElement()!, version: .random())
  }
}
