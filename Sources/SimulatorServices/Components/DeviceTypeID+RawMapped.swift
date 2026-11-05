//
//  DeviceTypeID+RawMapped.swift
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

extension DeviceTypeID: RawMapped {
  /// Each raw option and the case it stands for.
  public static let rawOptions: BidirectionalMap<RawAvailableOptions, Self> = [
    .appleTV1080p: .appleTV1080p,
    .appleTV4K1080p: .appleTV4K1080p,
    .appleTV4K2ndgeneration1080p: .appleTV4K2ndgeneration1080p,
    .appleTV4K2ndgeneration4K: .appleTV4K2ndgeneration4K,
    .appleTV4K3rdgeneration1080p: .appleTV4K3rdgeneration1080p,
    .appleTV4K3rdgeneration4K: .appleTV4K3rdgeneration4K,
    .appleTV4K4K: .appleTV4K4K,
    .appleVisionPro: .appleVisionPro,
    .appleWatchSE40mm: .appleWatchSE40mm,
    .appleWatchSE40mm2ndgeneration: .appleWatchSE40mm2ndgeneration,
    .appleWatchSE44mm: .appleWatchSE44mm,
    .appleWatchSE44mm2ndgeneration: .appleWatchSE44mm2ndgeneration,
    .appleWatchSeries238mm: .appleWatchSeries238mm,
    .appleWatchSeries242mm: .appleWatchSeries242mm,
    .appleWatchSeries338mm: .appleWatchSeries338mm,
    .appleWatchSeries342mm: .appleWatchSeries342mm,
    .appleWatchSeries440mm: .appleWatchSeries440mm,
    .appleWatchSeries444mm: .appleWatchSeries444mm,
    .appleWatchSeries540mm: .appleWatchSeries540mm,
    .appleWatchSeries544mm: .appleWatchSeries544mm,
    .appleWatchSeries640mm: .appleWatchSeries640mm,
    .appleWatchSeries644mm: .appleWatchSeries644mm,
    .appleWatchSeries741mm: .appleWatchSeries741mm,
    .appleWatchSeries745mm: .appleWatchSeries745mm,
    .appleWatchSeries841mm: .appleWatchSeries841mm,
    .appleWatchSeries845mm: .appleWatchSeries845mm,
    .appleWatchSeries941mm: .appleWatchSeries941mm,
    .appleWatchSeries945mm: .appleWatchSeries945mm,
    .appleWatchUltra249mm: .appleWatchUltra249mm,
    .appleWatchUltra49mm: .appleWatchUltra49mm,
    .iPad5thgeneration: .iPad5thgeneration,
    .iPad6thgeneration: .iPad6thgeneration,
    .iPad7thgeneration: .iPad7thgeneration,
    .iPad8thgeneration: .iPad8thgeneration,
    .iPad10thgeneration: .iPad10thgeneration,
    .iPad9thgeneration: .iPad9thgeneration,
    .iPadAir3rdgeneration: .iPadAir3rdgeneration,
    .iPadAir4thgeneration: .iPadAir4thgeneration,
    .iPadAir2: .iPadAir2,
    .iPadAir5thgeneration: .iPadAir5thgeneration,
    .iPadPro: .iPadPro,
    .iPadPro105inch: .iPadPro105inch,
    .iPadPro11inch: .iPadPro11inch,
    .iPadPro11inch2ndgeneration: .iPadPro11inch2ndgeneration,
    .iPadPro129inch2ndgeneration: .iPadPro129inch2ndgeneration,
    .iPadPro129inch3rdgeneration: .iPadPro129inch3rdgeneration,
    .iPadPro129inch4thgeneration: .iPadPro129inch4thgeneration,
    .iPadPro97inch: .iPadPro97inch,
    .iPadPro11inch3rdgeneration: .iPadPro11inch3rdgeneration,
    .iPadPro11inch4thgeneration16GB: .iPadPro11inch4thgeneration16GB,
    .iPadPro11inch4thgeneration8GB: .iPadPro11inch4thgeneration8GB,
    .iPadPro129inch5thgeneration: .iPadPro129inch5thgeneration,
    .iPadPro129inch6thgeneration16GB: .iPadPro129inch6thgeneration16GB,
    .iPadPro129inch6thgeneration8GB: .iPadPro129inch6thgeneration8GB,
    .iPadmini5thgeneration: .iPadmini5thgeneration,
    .iPadmini4: .iPadmini4,
    .iPadmini6thgeneration: .iPadmini6thgeneration,
    .iPhone11: .iPhone11,
    .iPhone11Pro: .iPhone11Pro,
    .iPhone11ProMax: .iPhone11ProMax,
    .iPhone12: .iPhone12,
    .iPhone12Pro: .iPhone12Pro,
    .iPhone12ProMax: .iPhone12ProMax,
    .iPhone12mini: .iPhone12mini,
    .iPhone13: .iPhone13,
    .iPhone13Pro: .iPhone13Pro,
    .iPhone13ProMax: .iPhone13ProMax,
    .iPhone13mini: .iPhone13mini,
    .iPhone14: .iPhone14,
    .iPhone14Plus: .iPhone14Plus,
    .iPhone14Pro: .iPhone14Pro,
    .iPhone14ProMax: .iPhone14ProMax,
    .iPhone15: .iPhone15,
    .iPhone15Plus: .iPhone15Plus,
    .iPhone15Pro: .iPhone15Pro,
    .iPhone15ProMax: .iPhone15ProMax,
    .iPhone6s: .iPhone6s,
    .iPhone6sPlus: .iPhone6sPlus,
    .iPhone7: .iPhone7,
    .iPhone7Plus: .iPhone7Plus,
    .iPhone8: .iPhone8,
    .iPhone8Plus: .iPhone8Plus,
    .iPhoneSE: .iPhoneSE,
    .iPhoneSE2ndgeneration: .iPhoneSE2ndgeneration,
    .iPhoneSE3rdgeneration: .iPhoneSE3rdgeneration,
    .iPhoneX: .iPhoneX,
    .iPhoneXR: .iPhoneXR,
    .iPhoneXS: .iPhoneXS,
    .iPhoneXSMax: .iPhoneXSMax,
    .iPodtouch7thgeneration: .iPodtouch7thgeneration,
    .iPhone16: .iPhone16,
    .iPhone16Plus: .iPhone16Plus,
    .iPhone16Pro: .iPhone16Pro,
    .iPhone16ProMax: .iPhone16ProMax,
    .iPadPro11inchM416GB: .iPadPro11inchM416GB,
    .iPadPro11inchM48GB: .iPadPro11inchM48GB,
    .iPadPro13inchM416GB: .iPadPro13inchM416GB,
    .iPadPro13inchM48GB: .iPadPro13inchM48GB,
    .iPadAir11inchM2: .iPadAir11inchM2,
    .iPadAir13inchM2: .iPadAir13inchM2,
    .iPadminiA17Pro: .iPadminiA17Pro,
    .appleWatchSeries1042mm: .appleWatchSeries1042mm,
    .appleWatchSeries1046mm: .appleWatchSeries1046mm,
  ]
}
