//
//  DeviceTypeID.swift
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

public enum DeviceTypeID: PrefixedDecodableString, Equatable, Sendable, RandomEnum, RawDefined {
  public static let decodableStringPrefix: String = "com.apple.CoreSimulator.SimDeviceType."

  case AppleTV1080p
  case AppleTV4K1080p
  case AppleTV4K2ndgeneration1080p
  case AppleTV4K2ndgeneration4K
  case AppleTV4K3rdgeneration1080p
  case AppleTV4K3rdgeneration4K
  case AppleTV4K4K
  case AppleVisionPro
  case AppleWatchSE40mm
  case AppleWatchSE40mm2ndgeneration
  case AppleWatchSE44mm
  case AppleWatchSE44mm2ndgeneration
  case AppleWatchSeries238mm
  case AppleWatchSeries242mm
  case AppleWatchSeries338mm
  case AppleWatchSeries342mm
  case AppleWatchSeries440mm
  case AppleWatchSeries444mm
  case AppleWatchSeries540mm
  case AppleWatchSeries544mm
  case AppleWatchSeries640mm
  case AppleWatchSeries644mm
  case AppleWatchSeries741mm
  case AppleWatchSeries745mm
  case AppleWatchSeries841mm
  case AppleWatchSeries845mm
  case AppleWatchSeries941mm
  case AppleWatchSeries945mm
  case AppleWatchUltra249mm
  case AppleWatchUltra49mm
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
  case unknown(String)

  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .AppleTV1080p: self = .AppleTV1080p
    case .AppleTV4K1080p: self = .AppleTV4K1080p
    case .AppleTV4K2ndgeneration1080p: self = .AppleTV4K2ndgeneration1080p
    case .AppleTV4K2ndgeneration4K: self = .AppleTV4K2ndgeneration4K
    case .AppleTV4K3rdgeneration1080p: self = .AppleTV4K3rdgeneration1080p
    case .AppleTV4K3rdgeneration4K: self = .AppleTV4K3rdgeneration4K
    case .AppleTV4K4K: self = .AppleTV4K4K
    case .AppleVisionPro: self = .AppleVisionPro
    case .AppleWatchSE40mm: self = .AppleWatchSE40mm
    case .AppleWatchSE40mm2ndgeneration: self = .AppleWatchSE40mm2ndgeneration
    case .AppleWatchSE44mm: self = .AppleWatchSE44mm
    case .AppleWatchSE44mm2ndgeneration: self = .AppleWatchSE44mm2ndgeneration
    case .AppleWatchSeries238mm: self = .AppleWatchSeries238mm
    case .AppleWatchSeries242mm: self = .AppleWatchSeries242mm
    case .AppleWatchSeries338mm: self = .AppleWatchSeries338mm
    case .AppleWatchSeries342mm: self = .AppleWatchSeries342mm
    case .AppleWatchSeries440mm: self = .AppleWatchSeries440mm
    case .AppleWatchSeries444mm: self = .AppleWatchSeries444mm
    case .AppleWatchSeries540mm: self = .AppleWatchSeries540mm
    case .AppleWatchSeries544mm: self = .AppleWatchSeries544mm
    case .AppleWatchSeries640mm: self = .AppleWatchSeries640mm
    case .AppleWatchSeries644mm: self = .AppleWatchSeries644mm
    case .AppleWatchSeries741mm: self = .AppleWatchSeries741mm
    case .AppleWatchSeries745mm: self = .AppleWatchSeries745mm
    case .AppleWatchSeries841mm: self = .AppleWatchSeries841mm
    case .AppleWatchSeries845mm: self = .AppleWatchSeries845mm
    case .AppleWatchSeries941mm: self = .AppleWatchSeries941mm
    case .AppleWatchSeries945mm: self = .AppleWatchSeries945mm
    case .AppleWatchUltra249mm: self = .AppleWatchUltra249mm
    case .AppleWatchUltra49mm: self = .AppleWatchUltra49mm
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
    }
  }

  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }

  public enum RawAvailableOptions: String, CaseIterable, RawReversable {
    public typealias OptionType = DeviceTypeID
    
    case AppleTV1080p = "Apple-TV-1080p"
    case AppleTV4K1080p = "Apple-TV-4K-1080p"
    case AppleTV4K2ndgeneration1080p = "Apple-TV-4K-2nd-generation-1080p"
    case AppleTV4K2ndgeneration4K = "Apple-TV-4K-2nd-generation-4K"
    case AppleTV4K3rdgeneration1080p = "Apple-TV-4K-3rd-generation-1080p"
    case AppleTV4K3rdgeneration4K = "Apple-TV-4K-3rd-generation-4K"
    case AppleTV4K4K = "Apple-TV-4K-4K"
    case AppleVisionPro = "Apple-Vision-Pro"
    case AppleWatchSE40mm = "Apple-Watch-SE-40mm"
    case AppleWatchSE40mm2ndgeneration = "Apple-Watch-SE-40mm-2nd-generation"
    case AppleWatchSE44mm = "Apple-Watch-SE-44mm"
    case AppleWatchSE44mm2ndgeneration = "Apple-Watch-SE-44mm-2nd-generation"
    case AppleWatchSeries238mm = "Apple-Watch-Series-2-38mm"
    case AppleWatchSeries242mm = "Apple-Watch-Series-2-42mm"
    case AppleWatchSeries338mm = "Apple-Watch-Series-3-38mm"
    case AppleWatchSeries342mm = "Apple-Watch-Series-3-42mm"
    case AppleWatchSeries440mm = "Apple-Watch-Series-4-40mm"
    case AppleWatchSeries444mm = "Apple-Watch-Series-4-44mm"
    case AppleWatchSeries540mm = "Apple-Watch-Series-5-40mm"
    case AppleWatchSeries544mm = "Apple-Watch-Series-5-44mm"
    case AppleWatchSeries640mm = "Apple-Watch-Series-6-40mm"
    case AppleWatchSeries644mm = "Apple-Watch-Series-6-44mm"
    case AppleWatchSeries741mm = "Apple-Watch-Series-7-41mm"
    case AppleWatchSeries745mm = "Apple-Watch-Series-7-45mm"
    case AppleWatchSeries841mm = "Apple-Watch-Series-8-41mm"
    case AppleWatchSeries845mm = "Apple-Watch-Series-8-45mm"
    case AppleWatchSeries941mm = "Apple-Watch-Series-9-41mm"
    case AppleWatchSeries945mm = "Apple-Watch-Series-9-45mm"
    case AppleWatchUltra249mm = "Apple-Watch-Ultra-2-49mm"
    case AppleWatchUltra49mm = "Apple-Watch-Ultra-49mm"
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
    
    public init?(option rawOption: OptionType) {
      switch rawOption {
      case .AppleTV1080p: self = .AppleTV1080p
      case .AppleTV4K1080p: self = .AppleTV4K1080p
      case .AppleTV4K2ndgeneration1080p: self = .AppleTV4K2ndgeneration1080p
      case .AppleTV4K2ndgeneration4K: self = .AppleTV4K2ndgeneration4K
      case .AppleTV4K3rdgeneration1080p: self = .AppleTV4K3rdgeneration1080p
      case .AppleTV4K3rdgeneration4K: self = .AppleTV4K3rdgeneration4K
      case .AppleTV4K4K: self = .AppleTV4K4K
      case .AppleVisionPro: self = .AppleVisionPro
      case .AppleWatchSE40mm: self = .AppleWatchSE40mm
      case .AppleWatchSE40mm2ndgeneration: self = .AppleWatchSE40mm2ndgeneration
      case .AppleWatchSE44mm: self = .AppleWatchSE44mm
      case .AppleWatchSE44mm2ndgeneration: self = .AppleWatchSE44mm2ndgeneration
      case .AppleWatchSeries238mm: self = .AppleWatchSeries238mm
      case .AppleWatchSeries242mm: self = .AppleWatchSeries242mm
      case .AppleWatchSeries338mm: self = .AppleWatchSeries338mm
      case .AppleWatchSeries342mm: self = .AppleWatchSeries342mm
      case .AppleWatchSeries440mm: self = .AppleWatchSeries440mm
      case .AppleWatchSeries444mm: self = .AppleWatchSeries444mm
      case .AppleWatchSeries540mm: self = .AppleWatchSeries540mm
      case .AppleWatchSeries544mm: self = .AppleWatchSeries544mm
      case .AppleWatchSeries640mm: self = .AppleWatchSeries640mm
      case .AppleWatchSeries644mm: self = .AppleWatchSeries644mm
      case .AppleWatchSeries741mm: self = .AppleWatchSeries741mm
      case .AppleWatchSeries745mm: self = .AppleWatchSeries745mm
      case .AppleWatchSeries841mm: self = .AppleWatchSeries841mm
      case .AppleWatchSeries845mm: self = .AppleWatchSeries845mm
      case .AppleWatchSeries941mm: self = .AppleWatchSeries941mm
      case .AppleWatchSeries945mm: self = .AppleWatchSeries945mm
      case .AppleWatchUltra249mm: self = .AppleWatchUltra249mm
      case .AppleWatchUltra49mm: self = .AppleWatchUltra49mm
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
      case .unknown(_): return nil
      }
    }
  }
}
