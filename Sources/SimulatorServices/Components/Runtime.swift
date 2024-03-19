//
//  Runtime.swift
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

/// A structure representing a runtime.
public struct Runtime: Decodable, Equatable, Sendable {
  /// A structure representing a supported device type for the runtime.
  public struct SupportedDeviceType: Decodable, Equatable, Sendable {
    /// The bundle path of the device type.
    public let bundlePath: Path // URL?

    /// The name of the device type.
    public let name: String

    /// The identifier of the device type.
    public let identifier: DeviceTypeID // identifier

    /// The product family of the device type.
    public let productFamily: ProductFamily // deviceType
  }

  /// An array of supported device types for the runtime.
  public let supportedDeviceTypes: [SupportedDeviceType]

  /// The bundle path of the runtime.
  public let bundlePath: Path

  /// The build version of the runtime.
  public let buildversion: String

  /// The platform of the runtime.
  public let platform: Platform

  /// The root path of the runtime.
  public let runtimeRoot: Path

  /// The identifier of the runtime.
  public let identifier: RuntimeID

  /// The version of the runtime.
  public let version: Version

  /// A boolean indicating whether the runtime is internal.
  public let isInternal: Bool

  /// A boolean indicating whether the runtime is available.
  public let isAvailable: Bool

  /// The name of the runtime.
  public let name: String
}
