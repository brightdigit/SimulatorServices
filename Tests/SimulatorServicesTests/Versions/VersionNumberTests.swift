//
//  VersionNumberTests.swift
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

@Suite("VersionNumber")
internal struct VersionNumberTests {
  @Test(
    "Parses dotted versions from the recorded fixtures",
    arguments: [
      ("27.2", [27, 2]),
      ("18.3.1", [18, 3, 1]),
      ("26.3.1", [26, 3, 1]),
      ("2.5", [2, 5]),
      ("8.5", [8, 5]),
      ("27", [27]),
    ]
  )
  internal func parses(string: String, components: [Int]) throws {
    let version = try #require(VersionNumber(string))
    #expect(version.components == components)
    #expect(version.description == string)
  }

  @Test(
    "Rejects anything but dot-separated ASCII digits",
    arguments: ["", ".", "27.", ".1", "27..1", "27.1b", "-27.1", "+27", "27 .1", "２７.1"]
  )
  internal func rejects(string: String) {
    #expect(VersionNumber(string) == nil)
  }

  @Test("Rejects empty or negative components")
  internal func rejectsComponents() {
    #expect(VersionNumber(components: []) == nil)
    #expect(VersionNumber(components: [27, -1]) == nil)
  }

  @Test(
    "Orders numerically, component by component",
    arguments: [
      ("27.1", "27.1.1"),
      ("27.9", "27.10"),
      ("27.1", "27.2"),
      ("9.4", "10.5"),
      ("18.3.1", "18.5"),
      ("26.5", "27.0"),
      ("2.5", "26.5"),
    ]
  )
  internal func orders(older: String, newer: String) throws {
    let lhs = try #require(VersionNumber(older))
    let rhs = try #require(VersionNumber(newer))
    #expect(lhs < rhs)
    #expect(!(rhs < lhs))
    #expect(lhs != rhs)
  }

  @Test("Never compares as strings")
  internal func notStringOrder() throws {
    // As strings, "27.10" < "27.9" and "10.5" < "9.4".
    #expect(try #require(VersionNumber("27.10")) > #require(VersionNumber("27.9")))
    #expect(try #require(VersionNumber("10.5")) > #require(VersionNumber("9.4")))
  }

  @Test("Trailing zero components are insignificant")
  internal func trailingZeros() throws {
    let short = try #require(VersionNumber("27.1"))
    let long = try #require(VersionNumber("27.1.0"))
    #expect(short == long)
    #expect(short.hashValue == long.hashValue)
    #expect(!(short < long))
    #expect(!(long < short))
    #expect(Set([short, long]).count == 1)
  }

  @Test(
    "X.Y key",
    arguments: [
      ("27.1", "27.1"),
      ("27.1.1", "27.1"),
      ("18.3.1", "18.3"),
      ("27", "27.0"),
    ]
  )
  internal func majorMinor(string: String, key: String) throws {
    let version = try #require(VersionNumber(string))
    #expect(version.majorMinor.description == key)
  }

  @Test("Same X.Y means same version; a later minor doesn't")
  internal func sameVersionKey() throws {
    let base = try #require(VersionNumber("27.1")).majorMinor
    #expect(try #require(VersionNumber("27.1.1")).majorMinor == base)
    #expect(try #require(VersionNumber("27.2")).majorMinor != base)
    #expect(try #require(VersionNumber("28.1")).majorMinor != base)
    #expect(base < MajorMinorVersion(major: 27, minor: 10))
  }
}
