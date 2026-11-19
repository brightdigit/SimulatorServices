//
//  SimctlSnapshot+HardwareNames.swift
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

extension SimctlSnapshot {
  /// The device each hardware-specific runtime is for, by image identifier,
  /// such as "iPhone Duo".
  ///
  /// A runtime is hardware-specific when its identifier has a variant
  /// (`iOS-27-2-iPhone19-4`), or when its build is from a device train
  /// (``BuildNumber/isDeviceTrain``) and `simctl list -j` reports exactly
  /// one supported device type for it, as for iPhone Duo's 27.1 runtimes
  /// under the general `iOS-27-1` identifier. Requiring both keeps a general
  /// runtime that supports one device, such as visionOS's, general.
  ///
  /// The name is that single device type, or else the variant itself.
  public var hardwareNames: [UUID: String] {
    var names: [UUID: String] = [:]
    for image in images {
      let entry = list.runtimes.first {
        $0.identifier == image.runtimeIdentifier && $0.buildversion == image.build
      }
      let onlyDevice = entry.flatMap { entry in
        entry.supportedDeviceTypes.count == 1 ? entry.supportedDeviceTypes[0].name : nil
      }
      if let variant = image.runtimeIdentifier.variant {
        names[image.identifier] = onlyDevice ?? variant
      } else if let onlyDevice, BuildNumber(image.build)?.isDeviceTrain == true {
        names[image.identifier] = onlyDevice
      }
    }
    return names
  }
}
