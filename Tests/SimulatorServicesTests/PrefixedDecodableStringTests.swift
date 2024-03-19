//
//  PrefixedDecodableStringTests.swift
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

@testable import SimulatorServices
import XCTest

internal struct MockPDS: PrefixedDecodableString, LosslessStringConvertible, Equatable {
  let suffix: String
  static let decodableStringPrefix: String = UUID().uuidString

  init(suffix: any StringProtocol) throws {
    self.suffix = .init(suffix)
  }
}

final class PrefixedDecodableStringTests: XCTestCase {
  func testSuffix() throws {
    let mockSuffixes: [String] = .random(withCountIn: 20 ... 50) {
      UUID().uuidString
    }

    let mockStrings = mockSuffixes.map {
      MockPDS.decodableStringPrefix + $0
    }

    for (suffix, description) in zip(mockSuffixes, mockStrings) {
      let actualWSuffix: MockPDS = try .init(suffix: suffix)
      let actualWDesc: MockPDS? = .init(description)

      XCTAssertEqual(actualWDesc, actualWDesc)
      XCTAssertEqual(actualWDesc?.suffix, suffix)
      XCTAssertEqual(actualWSuffix.description, description)
    }
  }

  func testInvalidSuffix() throws {
    let mockStrings: [String] = .random(withCountIn: 20 ... 50) {
      UUID().uuidString
    }

    for string in mockStrings {
      let error: PrefixMismatchError?
      do {
        _ = try MockRD.suffix(forString: string)
        error = nil
      } catch let caughtError as PrefixMismatchError {
        error = caughtError
      }
      XCTAssertEqual(error?.singleStringValue, string)
    }
  }
}
