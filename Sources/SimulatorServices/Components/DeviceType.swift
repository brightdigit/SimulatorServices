//
//  DeviceType.swift
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

/// A type representing a specific device configuration.
public struct DeviceType: Decodable, Equatable, Sendable {
  /// The family of products the device belongs to.
  public let productFamily: ProductFamily  // deviceType

  /// The path to the bundle.
  public let bundlePath: Path  // URL?

  /// The maximum runtime version supported by the device.
  public let maxRuntimeVersion: Int

  /// The maximum runtime version as a string.
  public let maxRuntimeVersionString: Version

  /// The unique identifier of the device.
  public let identifier: DeviceTypeID  // identifier

  /// The model identifier of the device.
  public let modelIdentifier: ModelID  // model

  /// The minimum runtime version as a string.
  public let minRuntimeVersionString: Version

  /// The minimum runtime version supported by the device.
  public let minRuntimeVersion: Int

  /// The name of the device.
  public let name: String
}
