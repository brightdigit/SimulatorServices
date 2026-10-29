//
//  RuntimeImageState.swift
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

// swiftlint:disable cyclomatic_complexity
/// State of a simulator runtime disk image,
/// as reported in `state` by `simctl runtime list -j`.
///
/// `Ready` is recorded from real output.
/// The other names are the disk image states CoreSimulator defines.
public enum RuntimeImageState: Equatable, Hashable, Decodable, Sendable, RawDefined {
  /// The image is being copied.
  case copying
  /// The image is being verified.
  case verifying
  /// The image is being read.
  case reading
  /// The image is being expanded.
  case expanding
  /// The image is being mounted.
  case mounting
  /// The image is mounted and usable.
  case ready
  /// The image can't be used.
  case unusable
  /// The image is being deleted.
  case deleting
  /// The image is being unmounted.
  case unmounting
  /// A state this package doesn't know, with the raw string.
  case unknown(String)

  /// Raw values of the known states.
  public enum RawAvailableOptions: String, CaseIterable, Sendable, RawReversable {
    case copying = "Copying"
    case verifying = "Verifying"
    case reading = "Reading"
    case expanding = "Expanding"
    case mounting = "Mounting"
    case ready = "Ready"
    case unusable = "Unusable"
    case deleting = "Deleting"
    case unmounting = "Unmounting"

    /// Creates the raw option for a state, or `nil` for an unknown state.
    /// - Parameter option: The state.
    public init?(option: RuntimeImageState) {
      switch option {
      case .copying: self = .copying
      case .verifying: self = .verifying
      case .reading: self = .reading
      case .expanding: self = .expanding
      case .mounting: self = .mounting
      case .ready: self = .ready
      case .unusable: self = .unusable
      case .deleting: self = .deleting
      case .unmounting: self = .unmounting
      case .unknown: return nil
      }
    }
  }

  /// Whether a delete is in progress for this image.
  public var isPendingDelete: Bool { self == .deleting }

  /// Creates a state from a raw option.
  /// - Parameter rawOption: The raw option.
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .copying: self = .copying
    case .verifying: self = .verifying
    case .reading: self = .reading
    case .expanding: self = .expanding
    case .mounting: self = .mounting
    case .ready: self = .ready
    case .unusable: self = .unusable
    case .deleting: self = .deleting
    case .unmounting: self = .unmounting
    }
  }

  /// The raw string of an unknown state, otherwise `nil`.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
// swiftlint:enable cyclomatic_complexity

extension RuntimeImageState: CustomStringConvertible {}
