//
//  VersionedBuildTests.swift
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

@Suite("VersionedBuild")
internal struct VersionedBuildTests {
  @Test("Parses a version and build together")
  internal func parses() throws {
    let value = try #require(VersionedBuild(version: "27.2", build: "24B5089g"))
    #expect(value.version.components == [27, 2])
    #expect(value.build.description == "24B5089g")
    #expect(value.description == "27.2 (24B5089g)")
    #expect(VersionedBuild(version: "27.x", build: "24B5089g") == nil)
    #expect(VersionedBuild(version: "27.2", build: "beta") == nil)
  }

  @Test(
    "Compares the version first, then the build",
    arguments: [
      // Same version: the build decides (xrOS 27.2 betas in the fixtures).
      ("27.2", "24N5088l", "27.2", "24N5093f"),
      ("27.1", "24A5305f", "27.1", "24A5318c"),
      // Different version: the version decides, whatever the build says.
      ("27.1", "24B9000z", "27.1.1", "24B1a"),
      ("27.9", "24Z9999z", "27.10", "24A1a"),
    ]
  )
  internal func newer(
    olderVersion: String,
    olderBuild: String,
    newerVersion: String,
    newerBuild: String
  ) throws {
    let older = try #require(VersionedBuild(version: olderVersion, build: olderBuild))
    let newer = try #require(VersionedBuild(version: newerVersion, build: newerBuild))
    #expect(newer.isNewer(than: older))
    #expect(!older.isNewer(than: newer))
    #expect(older < newer)
  }

  @Test("A value isn't newer than itself")
  internal func notNewerThanItself() throws {
    let value = try #require(VersionedBuild(version: "27.2", build: "24B5089g"))
    #expect(!value.isNewer(than: value))
  }

  @Test("Same version means the same X.Y")
  internal func sameVersion() throws {
    let beta = try #require(VersionedBuild(version: "27.1", build: "24B5089g"))
    let patch = try #require(VersionedBuild(version: "27.1.1", build: "24B6000a"))
    let next = try #require(VersionedBuild(version: "27.2", build: "24C5000a"))
    #expect(beta.isSameVersion(as: patch))
    #expect(!beta.isSameVersion(as: next))
  }
}
