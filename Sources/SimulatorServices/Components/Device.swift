//
//  Device.swift
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

import Foundation

/// Represents a device used in simulation.
public struct Device: Decodable, Equatable, Sendable {
  /// The path to the data directory.
  public let dataPath: Path  // URL?

  /// The size of the data directory.
  public let dataPathSize: Int?

  /// The path to the log directory.
  public let logPath: Path  // URL?

  /// The unique identifier for the device.
  public let udid: UUID

  /// Indicates if the device is available.
  public let isAvailable: Bool

  /// The size of the log directory.
  public let logPathSize: Int?

  /// The timestamp when the device was last booted.
  public let lastBootedAt: Date?

  /// The identifier for the device type.
  public let deviceTypeIdentifier: DeviceTypeID  // Identifier (Device)

  /// The current state of the device.
  public let state: DeviceState  // DeviceState

  /// The name of the device.
  public let name: String
}
