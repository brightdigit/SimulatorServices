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

    /// Creates the raw option for a kind, or `nil` for an unknown kind.
    /// - Parameter option: The kind.
    public init?(option: RuntimeImageKind) {
      switch option {
      case .diskImage: self = .diskImage
      case .cryptexDiskImage: self = .cryptexDiskImage
      case .patchableCryptexDiskImage: self = .patchableCryptexDiskImage
      case .legacyDownload: self = .legacyDownload
      case .bundledWithXcode: self = .bundledWithXcode
      case .unknown: return nil
      }
    }
  }

  /// Whether the runtime is a disk image (plain, cryptex or patchable cryptex).
  public var isDiskImage: Bool {
    switch self {
    case .diskImage, .cryptexDiskImage, .patchableCryptexDiskImage: true
    case .legacyDownload, .bundledWithXcode, .unknown: false
    }
  }

  /// Creates a kind from a raw option.
  /// - Parameter rawOption: The raw option.
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .diskImage: self = .diskImage
    case .cryptexDiskImage: self = .cryptexDiskImage
    case .patchableCryptexDiskImage: self = .patchableCryptexDiskImage
    case .legacyDownload: self = .legacyDownload
    case .bundledWithXcode: self = .bundledWithXcode
    }
  }

  /// The raw string of an unknown kind, otherwise `nil`.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}

extension RuntimeImageKind: CustomStringConvertible {}
