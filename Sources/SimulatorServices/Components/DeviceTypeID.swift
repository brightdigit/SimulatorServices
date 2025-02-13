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

  public enum RawAvailableOptions: String, CaseIterable, RawReversable {
    // swift-format-ignore: AllPublicDeclarationsHaveDocumentation
    public typealias OptionType = DeviceTypeID

    case appleTV1080p = "Apple-TV-1080p"
    case appleTV4K1080p = "Apple-TV-4K-1080p"
    case appleTV4K2ndgeneration1080p = "Apple-TV-4K-2nd-generation-1080p"
    case appleTV4K2ndgeneration4K = "Apple-TV-4K-2nd-generation-4K"
    case appleTV4K3rdgeneration1080p = "Apple-TV-4K-3rd-generation-1080p"
    case appleTV4K3rdgeneration4K = "Apple-TV-4K-3rd-generation-4K"
    case appleTV4K4K = "Apple-TV-4K-4K"
    case appleVisionPro = "Apple-Vision-Pro"
    case appleWatchSE40mm = "Apple-Watch-SE-40mm"
    case appleWatchSE40mm2ndgeneration = "Apple-Watch-SE-40mm-2nd-generation"
    case appleWatchSE44mm = "Apple-Watch-SE-44mm"
    case appleWatchSE44mm2ndgeneration = "Apple-Watch-SE-44mm-2nd-generation"
    case appleWatchSeries238mm = "Apple-Watch-Series-2-38mm"
    case appleWatchSeries242mm = "Apple-Watch-Series-2-42mm"
    case appleWatchSeries338mm = "Apple-Watch-Series-3-38mm"
    case appleWatchSeries342mm = "Apple-Watch-Series-3-42mm"
    case appleWatchSeries440mm = "Apple-Watch-Series-4-40mm"
    case appleWatchSeries444mm = "Apple-Watch-Series-4-44mm"
    case appleWatchSeries540mm = "Apple-Watch-Series-5-40mm"
    case appleWatchSeries544mm = "Apple-Watch-Series-5-44mm"
    case appleWatchSeries640mm = "Apple-Watch-Series-6-40mm"
    case appleWatchSeries644mm = "Apple-Watch-Series-6-44mm"
    case appleWatchSeries741mm = "Apple-Watch-Series-7-41mm"
    case appleWatchSeries745mm = "Apple-Watch-Series-7-45mm"
    case appleWatchSeries841mm = "Apple-Watch-Series-8-41mm"
    case appleWatchSeries845mm = "Apple-Watch-Series-8-45mm"
    case appleWatchSeries941mm = "Apple-Watch-Series-9-41mm"
    case appleWatchSeries945mm = "Apple-Watch-Series-9-45mm"
    case appleWatchUltra249mm = "Apple-Watch-Ultra-2-49mm"
    case appleWatchUltra49mm = "Apple-Watch-Ultra-49mm"
    case iPad5thgeneration = "iPad--5th-generation-"
    case iPad6thgeneration = "iPad--6th-generation-"
    case iPad7thgeneration = "iPad--7th-generation-"
    case iPad8thgeneration = "iPad--8th-generation-"
    case iPad10thgeneration = "iPad-10th-generation"
    case iPad9thgeneration = "iPad-9th-generation"
    case iPadAir3rdgeneration = "iPad-Air--3rd-generation-"
    case iPadAir4thgeneration = "iPad-Air--4th-generation-"
    case iPadAir2 = "iPad-Air-2"
    case iPadAir5thgeneration = "iPad-Air-5th-generation"
    case iPadPro = "iPad-Pro"
    case iPadPro105inch = "iPad-Pro--10-5-inch-"
    case iPadPro11inch = "iPad-Pro--11-inch-"
    case iPadPro11inch2ndgeneration = "iPad-Pro--11-inch---2nd-generation-"
    case iPadPro129inch2ndgeneration = "iPad-Pro--12-9-inch---2nd-generation-"
    case iPadPro129inch3rdgeneration = "iPad-Pro--12-9-inch---3rd-generation-"
    case iPadPro129inch4thgeneration = "iPad-Pro--12-9-inch---4th-generation-"
    case iPadPro97inch = "iPad-Pro--9-7-inch-"
    case iPadPro11inch3rdgeneration = "iPad-Pro-11-inch-3rd-generation"
    case iPadPro11inch4thgeneration16GB = "iPad-Pro-11-inch-4th-generation-16GB"
    case iPadPro11inch4thgeneration8GB = "iPad-Pro-11-inch-4th-generation-8GB"
    case iPadPro129inch5thgeneration = "iPad-Pro-12-9-inch-5th-generation"
    case iPadPro129inch6thgeneration16GB = "iPad-Pro-12-9-inch-6th-generation-16GB"
    case iPadPro129inch6thgeneration8GB = "iPad-Pro-12-9-inch-6th-generation-8GB"
    case iPadmini5thgeneration = "iPad-mini--5th-generation-"
    case iPadmini4 = "iPad-mini-4"
    case iPadmini6thgeneration = "iPad-mini-6th-generation"
    case iPhone11 = "iPhone-11"
    case iPhone11Pro = "iPhone-11-Pro"
    case iPhone11ProMax = "iPhone-11-Pro-Max"
    case iPhone12 = "iPhone-12"
    case iPhone12Pro = "iPhone-12-Pro"
    case iPhone12ProMax = "iPhone-12-Pro-Max"
    case iPhone12mini = "iPhone-12-mini"
    case iPhone13 = "iPhone-13"
    case iPhone13Pro = "iPhone-13-Pro"
    case iPhone13ProMax = "iPhone-13-Pro-Max"
    case iPhone13mini = "iPhone-13-mini"
    case iPhone14 = "iPhone-14"
    case iPhone14Plus = "iPhone-14-Plus"
    case iPhone14Pro = "iPhone-14-Pro"
    case iPhone14ProMax = "iPhone-14-Pro-Max"
    case iPhone15 = "iPhone-15"
    case iPhone15Plus = "iPhone-15-Plus"
    case iPhone15Pro = "iPhone-15-Pro"
    case iPhone15ProMax = "iPhone-15-Pro-Max"
    case iPhone6s = "iPhone-6s"
    case iPhone6sPlus = "iPhone-6s-Plus"
    case iPhone7 = "iPhone-7"
    case iPhone7Plus = "iPhone-7-Plus"
    case iPhone8 = "iPhone-8"
    case iPhone8Plus = "iPhone-8-Plus"
    case iPhoneSE = "iPhone-SE"
    case iPhoneSE2ndgeneration = "iPhone-SE--2nd-generation-"
    case iPhoneSE3rdgeneration = "iPhone-SE-3rd-generation"
    case iPhoneX = "iPhone-X"
    case iPhoneXR = "iPhone-XR"
    case iPhoneXS = "iPhone-XS"
    case iPhoneXSMax = "iPhone-XS-Max"
    case iPodtouch7thgeneration = "iPod-touch--7th-generation-"
    case iPhone16 = "iPhone-16"
    case iPhone16Plus = "iPhone-16-Plus"
    case iPhone16Pro = "iPhone-16-Pro"
    case iPhone16ProMax = "iPhone-16-Pro-Max"
    case iPadPro11inchM416GB = "iPad-Pro-11-inch-M4-16GB"
    case iPadPro11inchM48GB = "iPad-Pro-11-inch-M4-8GB"
    case iPadPro13inchM416GB = "iPad-Pro-13-inch-M4-16GB"
    case iPadPro13inchM48GB = "iPad-Pro-13-inch-M4-8GB"
    case iPadAir11inchM2 = "iPad-Air-11-inch-M2"
    case iPadAir13inchM2 = "iPad-Air-13-inch-M2"
    case iPadminiA17Pro = "iPad-mini-A17-Pro"
    case appleWatchSeries1042mm = "Apple-Watch-Series-10-42mm"
    case appleWatchSeries1046mm = "Apple-Watch-Series-10-46mm"

    // swift-format-ignore: AllPublicDeclarationsHaveDocumentation
    public init?(option rawOption: OptionType) {
      switch rawOption {
      case .appleTV1080p: self = .appleTV1080p
      case .appleTV4K1080p: self = .appleTV4K1080p
      case .appleTV4K2ndgeneration1080p: self = .appleTV4K2ndgeneration1080p
      case .appleTV4K2ndgeneration4K: self = .appleTV4K2ndgeneration4K
      case .appleTV4K3rdgeneration1080p: self = .appleTV4K3rdgeneration1080p
      case .appleTV4K3rdgeneration4K: self = .appleTV4K3rdgeneration4K
      case .appleTV4K4K: self = .appleTV4K4K
      case .appleVisionPro: self = .appleVisionPro
      case .appleWatchSE40mm: self = .appleWatchSE40mm
      case .appleWatchSE40mm2ndgeneration: self = .appleWatchSE40mm2ndgeneration
      case .appleWatchSE44mm: self = .appleWatchSE44mm
      case .appleWatchSE44mm2ndgeneration: self = .appleWatchSE44mm2ndgeneration
      case .appleWatchSeries238mm: self = .appleWatchSeries238mm
      case .appleWatchSeries242mm: self = .appleWatchSeries242mm
      case .appleWatchSeries338mm: self = .appleWatchSeries338mm
      case .appleWatchSeries342mm: self = .appleWatchSeries342mm
      case .appleWatchSeries440mm: self = .appleWatchSeries440mm
      case .appleWatchSeries444mm: self = .appleWatchSeries444mm
      case .appleWatchSeries540mm: self = .appleWatchSeries540mm
      case .appleWatchSeries544mm: self = .appleWatchSeries544mm
      case .appleWatchSeries640mm: self = .appleWatchSeries640mm
      case .appleWatchSeries644mm: self = .appleWatchSeries644mm
      case .appleWatchSeries741mm: self = .appleWatchSeries741mm
      case .appleWatchSeries745mm: self = .appleWatchSeries745mm
      case .appleWatchSeries841mm: self = .appleWatchSeries841mm
      case .appleWatchSeries845mm: self = .appleWatchSeries845mm
      case .appleWatchSeries941mm: self = .appleWatchSeries941mm
      case .appleWatchSeries945mm: self = .appleWatchSeries945mm
      case .appleWatchUltra249mm: self = .appleWatchUltra249mm
      case .appleWatchUltra49mm: self = .appleWatchUltra49mm
      case .iPad5thgeneration: self = .iPad5thgeneration
      case .iPad6thgeneration: self = .iPad6thgeneration
      case .iPad7thgeneration: self = .iPad7thgeneration
      case .iPad8thgeneration: self = .iPad8thgeneration
      case .iPad10thgeneration: self = .iPad10thgeneration
      case .iPad9thgeneration: self = .iPad9thgeneration
      case .iPadAir3rdgeneration: self = .iPadAir3rdgeneration
      case .iPadAir4thgeneration: self = .iPadAir4thgeneration
      case .iPadAir2: self = .iPadAir2
      case .iPadAir5thgeneration: self = .iPadAir5thgeneration
      case .iPadPro: self = .iPadPro
      case .iPadPro105inch: self = .iPadPro105inch
      case .iPadPro11inch: self = .iPadPro11inch
      case .iPadPro11inch2ndgeneration: self = .iPadPro11inch2ndgeneration
      case .iPadPro129inch2ndgeneration: self = .iPadPro129inch2ndgeneration
      case .iPadPro129inch3rdgeneration: self = .iPadPro129inch3rdgeneration
      case .iPadPro129inch4thgeneration: self = .iPadPro129inch4thgeneration
      case .iPadPro97inch: self = .iPadPro97inch
      case .iPadPro11inch3rdgeneration: self = .iPadPro11inch3rdgeneration
      case .iPadPro11inch4thgeneration16GB: self = .iPadPro11inch4thgeneration16GB
      case .iPadPro11inch4thgeneration8GB: self = .iPadPro11inch4thgeneration8GB
      case .iPadPro129inch5thgeneration: self = .iPadPro129inch5thgeneration
      case .iPadPro129inch6thgeneration16GB: self = .iPadPro129inch6thgeneration16GB
      case .iPadPro129inch6thgeneration8GB: self = .iPadPro129inch6thgeneration8GB
      case .iPadmini5thgeneration: self = .iPadmini5thgeneration
      case .iPadmini4: self = .iPadmini4
      case .iPadmini6thgeneration: self = .iPadmini6thgeneration
      case .iPhone11: self = .iPhone11
      case .iPhone11Pro: self = .iPhone11Pro
      case .iPhone11ProMax: self = .iPhone11ProMax
      case .iPhone12: self = .iPhone12
      case .iPhone12Pro: self = .iPhone12Pro
      case .iPhone12ProMax: self = .iPhone12ProMax
      case .iPhone12mini: self = .iPhone12mini
      case .iPhone13: self = .iPhone13
      case .iPhone13Pro: self = .iPhone13Pro
      case .iPhone13ProMax: self = .iPhone13ProMax
      case .iPhone13mini: self = .iPhone13mini
      case .iPhone14: self = .iPhone14
      case .iPhone14Plus: self = .iPhone14Plus
      case .iPhone14Pro: self = .iPhone14Pro
      case .iPhone14ProMax: self = .iPhone14ProMax
      case .iPhone15: self = .iPhone15
      case .iPhone15Plus: self = .iPhone15Plus
      case .iPhone15Pro: self = .iPhone15Pro
      case .iPhone15ProMax: self = .iPhone15ProMax
      case .iPhone6s: self = .iPhone6s
      case .iPhone6sPlus: self = .iPhone6sPlus
      case .iPhone7: self = .iPhone7
      case .iPhone7Plus: self = .iPhone7Plus
      case .iPhone8: self = .iPhone8
      case .iPhone8Plus: self = .iPhone8Plus
      case .iPhoneSE: self = .iPhoneSE
      case .iPhoneSE2ndgeneration: self = .iPhoneSE2ndgeneration
      case .iPhoneSE3rdgeneration: self = .iPhoneSE3rdgeneration
      case .iPhoneX: self = .iPhoneX
      case .iPhoneXR: self = .iPhoneXR
      case .iPhoneXS: self = .iPhoneXS
      case .iPhoneXSMax: self = .iPhoneXSMax
      case .iPodtouch7thgeneration: self = .iPodtouch7thgeneration
      case .iPhone16: self = .iPhone16
      case .iPhone16Plus: self = .iPhone16Plus
      case .iPhone16Pro: self = .iPhone16Pro
      case .iPhone16ProMax: self = .iPhone16ProMax
      case .iPadPro11inchM416GB: self = .iPadPro11inchM416GB
      case .iPadPro11inchM48GB: self = .iPadPro11inchM48GB
      case .iPadPro13inchM416GB: self = .iPadPro13inchM416GB
      case .iPadPro13inchM48GB: self = .iPadPro13inchM48GB
      case .iPadAir11inchM2: self = .iPadAir11inchM2
      case .iPadAir13inchM2: self = .iPadAir13inchM2
      case .iPadminiA17Pro: self = .iPadminiA17Pro
      case .appleWatchSeries1042mm: self = .appleWatchSeries1042mm
      case .appleWatchSeries1046mm: self = .appleWatchSeries1046mm
      case .unknown: return nil
      }
    }
  }

  // swift-format-ignore: AllPublicDeclarationsHaveDocumentation
  public static let decodableStringPrefix: String = "com.apple.CoreSimulator.SimDeviceType."

  // swift-format-ignore: AllPublicDeclarationsHaveDocumentation
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .appleTV1080p: self = .appleTV1080p
    case .appleTV4K1080p: self = .appleTV4K1080p
    case .appleTV4K2ndgeneration1080p: self = .appleTV4K2ndgeneration1080p
    case .appleTV4K2ndgeneration4K: self = .appleTV4K2ndgeneration4K
    case .appleTV4K3rdgeneration1080p: self = .appleTV4K3rdgeneration1080p
    case .appleTV4K3rdgeneration4K: self = .appleTV4K3rdgeneration4K
    case .appleTV4K4K: self = .appleTV4K4K
    case .appleVisionPro: self = .appleVisionPro
    case .appleWatchSE40mm: self = .appleWatchSE40mm
    case .appleWatchSE40mm2ndgeneration: self = .appleWatchSE40mm2ndgeneration
    case .appleWatchSE44mm: self = .appleWatchSE44mm
    case .appleWatchSE44mm2ndgeneration: self = .appleWatchSE44mm2ndgeneration
    case .appleWatchSeries238mm: self = .appleWatchSeries238mm
    case .appleWatchSeries242mm: self = .appleWatchSeries242mm
    case .appleWatchSeries338mm: self = .appleWatchSeries338mm
    case .appleWatchSeries342mm: self = .appleWatchSeries342mm
    case .appleWatchSeries440mm: self = .appleWatchSeries440mm
    case .appleWatchSeries444mm: self = .appleWatchSeries444mm
    case .appleWatchSeries540mm: self = .appleWatchSeries540mm
    case .appleWatchSeries544mm: self = .appleWatchSeries544mm
    case .appleWatchSeries640mm: self = .appleWatchSeries640mm
    case .appleWatchSeries644mm: self = .appleWatchSeries644mm
    case .appleWatchSeries741mm: self = .appleWatchSeries741mm
    case .appleWatchSeries745mm: self = .appleWatchSeries745mm
    case .appleWatchSeries841mm: self = .appleWatchSeries841mm
    case .appleWatchSeries845mm: self = .appleWatchSeries845mm
    case .appleWatchSeries941mm: self = .appleWatchSeries941mm
    case .appleWatchSeries945mm: self = .appleWatchSeries945mm
    case .appleWatchUltra249mm: self = .appleWatchUltra249mm
    case .appleWatchUltra49mm: self = .appleWatchUltra49mm
    case .iPad5thgeneration: self = .iPad5thgeneration
    case .iPad6thgeneration: self = .iPad6thgeneration
    case .iPad7thgeneration: self = .iPad7thgeneration
    case .iPad8thgeneration: self = .iPad8thgeneration
    case .iPad10thgeneration: self = .iPad10thgeneration
    case .iPad9thgeneration: self = .iPad9thgeneration
    case .iPadAir3rdgeneration: self = .iPadAir3rdgeneration
    case .iPadAir4thgeneration: self = .iPadAir4thgeneration
    case .iPadAir2: self = .iPadAir2
    case .iPadAir5thgeneration: self = .iPadAir5thgeneration
    case .iPadPro: self = .iPadPro
    case .iPadPro105inch: self = .iPadPro105inch
    case .iPadPro11inch: self = .iPadPro11inch
    case .iPadPro11inch2ndgeneration: self = .iPadPro11inch2ndgeneration
    case .iPadPro129inch2ndgeneration: self = .iPadPro129inch2ndgeneration
    case .iPadPro129inch3rdgeneration: self = .iPadPro129inch3rdgeneration
    case .iPadPro129inch4thgeneration: self = .iPadPro129inch4thgeneration
    case .iPadPro97inch: self = .iPadPro97inch
    case .iPadPro11inch3rdgeneration: self = .iPadPro11inch3rdgeneration
    case .iPadPro11inch4thgeneration16GB: self = .iPadPro11inch4thgeneration16GB
    case .iPadPro11inch4thgeneration8GB: self = .iPadPro11inch4thgeneration8GB
    case .iPadPro129inch5thgeneration: self = .iPadPro129inch5thgeneration
    case .iPadPro129inch6thgeneration16GB: self = .iPadPro129inch6thgeneration16GB
    case .iPadPro129inch6thgeneration8GB: self = .iPadPro129inch6thgeneration8GB
    case .iPadmini5thgeneration: self = .iPadmini5thgeneration
    case .iPadmini4: self = .iPadmini4
    case .iPadmini6thgeneration: self = .iPadmini6thgeneration
    case .iPhone11: self = .iPhone11
    case .iPhone11Pro: self = .iPhone11Pro
    case .iPhone11ProMax: self = .iPhone11ProMax
    case .iPhone12: self = .iPhone12
    case .iPhone12Pro: self = .iPhone12Pro
    case .iPhone12ProMax: self = .iPhone12ProMax
    case .iPhone12mini: self = .iPhone12mini
    case .iPhone13: self = .iPhone13
    case .iPhone13Pro: self = .iPhone13Pro
    case .iPhone13ProMax: self = .iPhone13ProMax
    case .iPhone13mini: self = .iPhone13mini
    case .iPhone14: self = .iPhone14
    case .iPhone14Plus: self = .iPhone14Plus
    case .iPhone14Pro: self = .iPhone14Pro
    case .iPhone14ProMax: self = .iPhone14ProMax
    case .iPhone15: self = .iPhone15
    case .iPhone15Plus: self = .iPhone15Plus
    case .iPhone15Pro: self = .iPhone15Pro
    case .iPhone15ProMax: self = .iPhone15ProMax
    case .iPhone6s: self = .iPhone6s
    case .iPhone6sPlus: self = .iPhone6sPlus
    case .iPhone7: self = .iPhone7
    case .iPhone7Plus: self = .iPhone7Plus
    case .iPhone8: self = .iPhone8
    case .iPhone8Plus: self = .iPhone8Plus
    case .iPhoneSE: self = .iPhoneSE
    case .iPhoneSE2ndgeneration: self = .iPhoneSE2ndgeneration
    case .iPhoneSE3rdgeneration: self = .iPhoneSE3rdgeneration
    case .iPhoneX: self = .iPhoneX
    case .iPhoneXR: self = .iPhoneXR
    case .iPhoneXS: self = .iPhoneXS
    case .iPhoneXSMax: self = .iPhoneXSMax
    case .iPodtouch7thgeneration: self = .iPodtouch7thgeneration
    case .iPhone16: self = .iPhone16
    case .iPhone16Plus: self = .iPhone16Plus
    case .iPhone16Pro: self = .iPhone16Pro
    case .iPhone16ProMax: self = .iPhone16ProMax
    case .iPadPro11inchM416GB: self = .iPadPro11inchM416GB
    case .iPadPro11inchM48GB: self = .iPadPro11inchM48GB
    case .iPadPro13inchM416GB: self = .iPadPro13inchM416GB
    case .iPadPro13inchM48GB: self = .iPadPro13inchM48GB
    case .iPadAir11inchM2: self = .iPadAir11inchM2
    case .iPadAir13inchM2: self = .iPadAir13inchM2
    case .iPadminiA17Pro: self = .iPadminiA17Pro
    case .appleWatchSeries1042mm: self = .appleWatchSeries1042mm
    case .appleWatchSeries1046mm: self = .appleWatchSeries1046mm
    }
  }

  /// If the items is an unknown value, return the String.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else { return nil }
    return string
  }
}

extension DeviceTypeID: PrefixedDecodableString {}
extension DeviceTypeID: Equatable {}
extension DeviceTypeID: Sendable {}
extension DeviceTypeID: RandomEnum {}
extension DeviceTypeID: RawDefined {}

// swiftlint:enable all
