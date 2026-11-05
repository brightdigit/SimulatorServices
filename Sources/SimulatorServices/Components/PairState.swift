//
//  PairState.swift
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

/// Represents the state of an Apple Watch and iPhone pair.
public enum PairState: Hashable, Decodable, Sendable, RawDefined, RandomEnum {
  /// The devices are actively connected.
  case activeConnected

  /// The devices are actively disconnected.
  case activeDisconnected

  /// The devices are unavailable for pairing.
  case unavailable

  /// Represents an unknown state with additional information.
  case unknown(String)

  /// Available raw options for `PairState`.
  public enum RawAvailableOptions: String, CaseIterable, Sendable {
    case activeConnected = "(active, disconnected)"
    case activeDisconnected = "(active, connected)"
    case unavailable = "(unavailable)"
  }

  /// Each raw option and the case it stands for.
  public static let rawOptions: BidirectionalMap<RawAvailableOptions, Self> = [
    .activeConnected: .activeConnected,
    .unavailable: .unavailable,
    .activeDisconnected: .activeDisconnected,
  ]

  /// Retrieves the associated string for an unknown state.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}

extension PairState: RawMapped {}
