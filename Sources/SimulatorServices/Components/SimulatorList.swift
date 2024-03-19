//
//  SimulatorList.swift
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

import Foundation

/// Result from a call to the ``List`` subcommand.
public struct SimulatorList: Decodable, Equatable, Sendable {
  public enum CodingKeys: CodingKey {
    case devicetypes
    case runtimes
    case devices
    case pairs
  }

  /// DeviceTypes
  public let devicetypes: [DeviceType]
  /// Runtimes
  public let runtimes: [Runtime]
  /// Devices and their RuntimeIDs
  public let devices: [RuntimeID: [Device]]
  /// DevicePairs and thier IDs
  public let pairs: [UUID: DevicePair]

  // swiftlint:disable:next function_body_length
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    devicetypes = try container.decode([DeviceType].self, forKey: .devicetypes)
    runtimes = try container.decode([Runtime].self, forKey: .runtimes)
    let devices = try container.decode([String: [Device]].self, forKey: .devices)
    let pairs = try container.decode([String: DevicePair].self, forKey: .pairs)

    self.devices = try devices.reduce(
      into: [RuntimeID: [Device]]()
    ) { partialResult, pair in
      let (runtimeString, devices) = pair
      let suffix = try RuntimeID.suffix(forString: runtimeString)
      try partialResult[.init(suffix: suffix)] = devices
    }

    self.pairs = try pairs.reduce(
      into: [UUID: DevicePair]()
    ) { partialResult, pair in
      guard let id = UUID(uuidString: pair.key) else {
        throw DecodingError.dataCorrupted(
          .init(
            codingPath: [],
            debugDescription: "Invalid DevicePair ID: \(pair.key)"
          )
        )
      }
      partialResult[id] = pair.value
    }
  }
}
