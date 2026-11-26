//
//  RuntimeImageKind.swift
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

/// Kind of a simulator runtime image,
/// as reported in `kind` by `simctl runtime list -j`.
public enum RuntimeImageKind: Equatable, Hashable, Decodable, Sendable, RawDefined {
  /// A plain disk image (`.dmg`).
  case diskImage
  /// A cryptex disk image.
  case cryptexDiskImage
  /// A patchable cryptex disk image.
  case patchableCryptexDiskImage
  /// A legacy runtime bundle (`.simruntime`) that isn't a disk image,
  /// in `/Library/Developer/CoreSimulator/Profiles/Runtimes`.
  case legacyDownload
  /// A runtime bundled with Xcode.
  case bundledWithXcode
  /// A kind this package doesn't know, with the raw string.
  case unknown(String)

  /// Raw values of the known kinds.
  public enum RawAvailableOptions: String, CaseIterable, Sendable, RawReversable {
    case diskImage = "Disk Image"
    case cryptexDiskImage = "Cryptex Disk Image"
    case patchableCryptexDiskImage = "Patchable Cryptex Disk Image"
    case legacyDownload = "Legacy Download"
    case bundledWithXcode = "Bundled with Xcode"
  }

  /// The kinds that are disk images: plain, cryptex and patchable cryptex.
  public static let diskImageKinds: Set<RuntimeImageKind> = [
    .diskImage, .cryptexDiskImage, .patchableCryptexDiskImage,
  ]

  /// Each raw option and the case it stands for.
  public static let rawOptions: BidirectionalMap<RawAvailableOptions, Self> = [
    .diskImage: .diskImage,
    .cryptexDiskImage: .cryptexDiskImage,
    .patchableCryptexDiskImage: .patchableCryptexDiskImage,
    .legacyDownload: .legacyDownload,
    .bundledWithXcode: .bundledWithXcode,
  ]

  /// The raw string of an unknown kind, otherwise `nil`.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}

extension RuntimeImageKind: CustomStringConvertible {}

extension RuntimeImageKind: RawMapped {}

extension RuntimeImageKind {
  /// Whether the runtime is a disk image (plain, cryptex or patchable cryptex).
  public var isDiskImage: Bool {
    Self.diskImageKinds.contains(self)
  }
}

extension RuntimeImageKind.RawAvailableOptions {
  /// The type these options stand for.
  public typealias OptionType = RuntimeImageKind
}
