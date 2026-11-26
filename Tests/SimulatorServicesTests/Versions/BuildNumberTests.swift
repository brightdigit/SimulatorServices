//
//  BuildNumberTests.swift
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

import Testing

@testable import SimulatorServices

@Suite("BuildNumber")
internal struct BuildNumberTests {
  /// A build string and the parts it should parse into.
  internal struct Parsed: Sendable, CustomTestStringConvertible {
    internal let string: String
    internal let major: Int
    internal let train: Character
    internal let number: Int
    internal let suffix: Character?

    internal var testDescription: String { string }

    internal init(
      _ string: String,
      _ major: Int,
      _ train: Character,
      _ number: Int,
      _ suffix: Character? = nil
    ) {
      self.string = string
      self.major = major
      self.train = train
      self.number = number
      self.suffix = suffix
    }
  }

  @Test(
    "Parses real builds from the recorded simctl fixtures",
    arguments: [
      Parsed("24B5089g", 24, "B", 5_089, "g"),
      Parsed("24N5093f", 24, "N", 5_093, "f"),
      Parsed("24N5088l", 24, "N", 5_088, "l"),
      Parsed("24S5091f", 24, "S", 5_091, "f"),
      Parsed("24K5093g", 24, "K", 5_093, "g"),
      Parsed("21T575", 21, "T", 575),
      Parsed("23F77", 23, "F", 77),
      Parsed("24A434", 24, "A", 434),
      Parsed("24A94232", 24, "A", 94_232),
      Parsed("22S99", 22, "S", 99),
    ]
  )
  internal func parses(expected: Parsed) throws {
    let build = try #require(BuildNumber(expected.string))
    #expect(build.major == expected.major)
    #expect(build.train == expected.train)
    #expect(build.number == expected.number)
    #expect(build.suffix == expected.suffix)
    #expect(build.description == expected.string)
  }

  @Test(
    "Rejects strings that aren't number, train, number, optional suffix",
    arguments: [
      "", "24", "24B", "B5089g", "24b5089g", "24B5089G", "24B5089gg", "24BB5089",
      "24B5089g ", " 24B5089g", "24B-5089", "24B5089g1", "24B99999999999999999999",
      "２4B5089g",
    ]
  )
  internal func rejects(string: String) {
    #expect(BuildNumber(string) == nil)
  }

  @Test(
    "Orders by number, train, number, suffix, numbers numerically",
    arguments: [
      ("24A5305f", "24A5318c"),
      // xrOS 27.2 betas both installed in the runtime-delete fixture.
      ("24N5088l", "24N5093f"),
      // The second number is compared numerically, not as a string.
      ("24A999a", "24A5089a"),
      ("23F77", "23F100"),
      // iOS 27.1 finals both installed in the runtime-delete fixture.
      ("24A94232", "24A94401"),
      // Leading number, then train.
      ("23F77", "24A434"),
      ("9A100", "10A1"),
      ("24A5089g", "24B5089a"),
      // Suffix last; no suffix sorts first.
      ("24B5089f", "24B5089g"),
      ("24B70", "24B70a"),
    ]
  )
  internal func orders(older: String, newer: String) throws {
    let lhs = try #require(BuildNumber(older))
    let rhs = try #require(BuildNumber(newer))
    #expect(lhs < rhs)
    #expect(!(rhs < lhs))
    #expect(lhs != rhs)
  }

  @Test("Equal builds are neither newer nor older")
  internal func equal() throws {
    let lhs = try #require(BuildNumber("24B5089g"))
    let rhs = try #require(BuildNumber("24B5089g"))
    #expect(lhs == rhs)
    #expect(!(lhs < rhs))
    #expect(!(rhs < lhs))
  }

  @Test("Sorts a mixed list of fixture builds")
  internal func sorts() throws {
    let builds = try ["24N5093f", "21T575", "24A94232", "24N5088l", "23F77", "24B5089g"]
      .map { try #require(BuildNumber($0)) }
    #expect(
      builds.sorted().map(\.description) == [
        "21T575", "23F77", "24A94232", "24B5089g", "24N5088l", "24N5093f",
      ]
    )
  }

  /// iPhone Duo's builds have five or more digits after the train letter.
  @Test("Device-train builds")
  internal func deviceTrainBuilds() {
    #expect(BuildNumber("24A94232")?.isDeviceTrain == true)
    #expect(BuildNumber("24B91016s")?.isDeviceTrain == true)
    #expect(BuildNumber("24B114")?.isDeviceTrain == false)
    #expect(BuildNumber("24B5089g")?.isDeviceTrain == false)
    #expect(BuildNumber("24B8117")?.isDeviceTrain == false)
  }
}
