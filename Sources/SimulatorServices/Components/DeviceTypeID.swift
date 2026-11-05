//
//  DeviceTypeID.swift
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

/// Simulator Model
public enum DeviceTypeID {
  case appleTV1080p
  case appleTV4K1080p
  case appleTV4K2ndgeneration1080p
  case appleTV4K2ndgeneration4K
  case appleTV4K3rdgeneration1080p
  case appleTV4K3rdgeneration4K
  case appleTV4K4K
  case appleVisionPro
  case appleWatchSE40mm
  case appleWatchSE40mm2ndgeneration
  case appleWatchSE44mm
  case appleWatchSE44mm2ndgeneration
  case appleWatchSeries238mm
  case appleWatchSeries242mm
  case appleWatchSeries338mm
  case appleWatchSeries342mm
  case appleWatchSeries440mm
  case appleWatchSeries444mm
  case appleWatchSeries540mm
  case appleWatchSeries544mm
  case appleWatchSeries640mm
  case appleWatchSeries644mm
  case appleWatchSeries741mm
  case appleWatchSeries745mm
  case appleWatchSeries841mm
  case appleWatchSeries845mm
  case appleWatchSeries941mm
  case appleWatchSeries945mm
  case appleWatchUltra249mm
  case appleWatchUltra49mm
  case iPad5thgeneration
  case iPad6thgeneration
  case iPad7thgeneration
  case iPad8thgeneration
  case iPad10thgeneration
  case iPad9thgeneration
  case iPadAir3rdgeneration
  case iPadAir4thgeneration
  case iPadAir2
  case iPadAir5thgeneration
  case iPadPro
  case iPadPro105inch
  case iPadPro11inch
  case iPadPro11inch2ndgeneration
  case iPadPro129inch2ndgeneration
  case iPadPro129inch3rdgeneration
  case iPadPro129inch4thgeneration
  case iPadPro97inch
  case iPadPro11inch3rdgeneration
  case iPadPro11inch4thgeneration16GB
  case iPadPro11inch4thgeneration8GB
  case iPadPro129inch5thgeneration
  case iPadPro129inch6thgeneration16GB
  case iPadPro129inch6thgeneration8GB
  case iPadmini5thgeneration
  case iPadmini4
  case iPadmini6thgeneration
  case iPhone11
  case iPhone11Pro
  case iPhone11ProMax
  case iPhone12
  case iPhone12Pro
  case iPhone12ProMax
  case iPhone12mini
  case iPhone13
  case iPhone13Pro
  case iPhone13ProMax
  case iPhone13mini
  case iPhone14
  case iPhone14Plus
  case iPhone14Pro
  case iPhone14ProMax
  case iPhone15
  case iPhone15Plus
  case iPhone15Pro
  case iPhone15ProMax
  case iPhone6s
  case iPhone6sPlus
  case iPhone7
  case iPhone7Plus
  case iPhone8
  case iPhone8Plus
  case iPhoneSE
  case iPhoneSE2ndgeneration
  case iPhoneSE3rdgeneration
  case iPhoneX
  case iPhoneXR
  case iPhoneXS
  case iPhoneXSMax
  case iPodtouch7thgeneration
  case iPhone16
  case iPhone16Plus
  case iPhone16Pro
  case iPhone16ProMax
  case iPadPro11inchM416GB
  case iPadPro11inchM48GB
  case iPadPro13inchM416GB
  case iPadPro13inchM48GB
  case iPadAir11inchM2
  case iPadAir13inchM2
  case iPadminiA17Pro
  case appleWatchSeries1042mm
  case appleWatchSeries1046mm
  case unknown(String)

  /// The prefix of every device type identifier.
  public static let decodableStringPrefix: String =
    "com.apple.CoreSimulator.SimDeviceType."

  /// If the items is an unknown value, return the String.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else { return nil }
    return string
  }
}

extension DeviceTypeID: PrefixedDecodableString {}
extension DeviceTypeID: Hashable {}
extension DeviceTypeID: Sendable {}
extension DeviceTypeID: RandomEnum {}
extension DeviceTypeID: RawDefined {}
