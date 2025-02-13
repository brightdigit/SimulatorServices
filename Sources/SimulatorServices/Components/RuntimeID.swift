//
//  RuntimeID.swift
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

import OperatingSystemVersion

/// A structure representing a runtime ID.
public struct RuntimeID: PrefixedDecodableString, Equatable, Hashable, Sendable {
  /// The prefix used for decoding strings.
  public static let decodableStringPrefix = "com.apple.CoreSimulator.SimRuntime."

  /// The platform of the runtime.
  public let platform: Platform

  /// The version of the runtime.
  public let version: Version

  /// The suffix part of the runtime ID.
  public var suffix: String {
    let values: [any CustomStringConvertible] = [
      platform, version.majorVersion, version.minorVersion,
    ]
    return values.map(\.description).joined(separator: "-")
  }

  /// Initializes a runtime ID with the given platform and version.
  ///
  /// - Parameters:
  ///   - platform: The platform of the runtime.
  ///   - version: The version of the runtime.
  public init(platform: Platform, version: Version) {
    self.platform = platform
    self.version = version
  }

  /// Initializes a runtime ID with the given suffix.
  ///
  /// - Parameter suffix: The suffix part of the runtime ID.
  /// - Throws: An error if initialization fails.
  public init(suffix: any StringProtocol) throws {
    let values = suffix.components(separatedBy: "-")
    guard values.count == 3 else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: [], debugDescription: "Invalid value: \"\(suffix)\"")
      )
    }
    let platform = Platform(rawValue: values[0])
    let versionValues = values[1...].compactMap(Int.init)
    let version = try Version(components: versionValues)
    self.init(platform: platform, version: version)
  }
}
