//
//  RawDefinedTests.swift
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

import XCTest

@testable import SimulatorServices

// swiftlint:disable all
// swift-format-ignore
internal enum MockRD: RawDefined, PrefixedDecodableString, RandomEnum, Equatable {
  internal init(rawOption: Choice) {
    switch rawOption {
    case .A:
      self = .A

    case .B:
      self = .B

    case .C:
      self = .C
    }
  }

  internal func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }

  internal typealias RawAvailableOptions = Choice

  internal static let decodableStringPrefix: String = UUID().uuidString
  case A
  case B
  case C
  case unknown(String)

  internal enum Choice: String, RawReversable, CaseIterable {
    init?(option: MockRD) {
      switch option {
      case .A:
        self = .A

      case .B:
        self = .B

      case .C:
        self = .C

      case .unknown:
        return nil
      }
    }

    internal typealias OptionType = MockRD

    case A
    case B
    case C
  }
}

internal final class RawDefinedTests: XCTestCase {
  internal func testInit() throws {
    let mockItems: [MockRD] = .random(withCountIn: 20...50) {
      Bool.random() ? .random() : .unknown(UUID().uuidString)
    }

    for item in mockItems {
      let actualDescription = item.description
      let actualSuffixInit: MockRD = try .init(suffix: item.suffix)
      let actualDescInit = MockRD(actualDescription)
      XCTAssertEqual(actualSuffixInit, actualDescInit)
    }
  }
}
// swiftlint:enable all
