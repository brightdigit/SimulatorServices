//
//  RuntimeID.swift
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

import OperatingSystemVersion

/// Runtime ID
public struct RuntimeID: PrefixedDecodableString, Equatable, Sendable, LosslessStringConvertible {
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

  public init?(_ description: String) {
    guard let suffix = try? Self.suffix(forString: description) else {
      return nil
    }
    try? self.init(suffix: suffix)
  }

  public static let decodableStringPrefix = "com.apple.CoreSimulator.SimRuntime."

  public let platform: Platform
  public let version: Version

  public var description: String {
    let values: [any CustomStringConvertible] = [
      platform,
      version.majorVersion,
      version.minorVersion
    ]
    return values.map(\.description).joined(separator: "-")
  }

  public init(platform: Platform, version: Version) {
    self.platform = platform
    self.version = version
  }
}
