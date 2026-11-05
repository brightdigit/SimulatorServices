//
//  DeviceState.swift
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

/// State for the device.
public enum DeviceState: Hashable, Decodable, Sendable, RawDefined {
  /// Represents a booted state for the device.
  case booted

  /// The device is booting.
  case booting

  /// Represents a creating state for the device.
  case creating

  /// The device is shutting down.
  case shuttingDown

  /// Represents a shutdown state for the device.
  case shutdown

  /// Represents an unknown state for the device with a custom string.
  case unknown(String)

  /// Available raw options for the device state.
  public enum RawAvailableOptions: String, Sendable, RawReversable, CaseIterable {
    case booted = "Booted"
    case booting = "Booting"
    case creating = "Creating"
    case shuttingDown = "Shutting Down"
    case shutdown = "Shutdown"
  }

  /// Each raw option and the case it stands for.
  public static let rawOptions: BidirectionalMap<RawAvailableOptions, Self> = [
    .booted: .booted,
    .booting: .booting,
    .creating: .creating,
    .shuttingDown: .shuttingDown,
    .shutdown: .shutdown,
  ]

  /// Retrieves the custom string for an unknown device state.
  ///
  /// - Returns: The custom string representing the unknown state if applicable,
  /// otherwise nil.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}

extension DeviceState: RawMapped {}

extension DeviceState.RawAvailableOptions {
  /// The type these options stand for.
  public typealias OptionType = DeviceState
}
