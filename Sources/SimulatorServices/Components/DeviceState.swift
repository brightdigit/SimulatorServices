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
public enum DeviceState: Equatable, Decodable, Sendable, RawDefined {
  /// Represents a booted state for the device.
  case booted

  /// Represents a creating state for the device.
  case creating

  /// Represents a shutdown state for the device.
  case shutdown

  /// Represents an unknown state for the device with a custom string.
  case unknown(String)

  /// Available raw options for the device state.
  public enum RawAvailableOptions: String {
    case booted = "Booted"
    case creating = "Creating"
    case shutdown = "Shutdown"
  }

  /// Initializes the device state with a raw option.
  ///
  /// - Parameter rawOption: The raw option to initialize from.
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .booted: self = .booted

    case .creating: self = .creating

    case .shutdown: self = .shutdown
    }
  }

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
