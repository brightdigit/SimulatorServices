//
//  SimctlFixtureBuildTests.swift
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

/// Runs every version and build in the recorded `simctl` fixtures through the
/// parsers, so a new recording with an unexpected format fails here.
@Suite("Recorded simctl fixtures")
internal struct SimctlFixtureBuildTests {
  @Test(
    "Every runtime list version and build parses",
    arguments: SimctlSnapshotFixture.recordings
  )
  internal func runtimeListParses(recording: String) throws {
    let images = try SimctlSnapshotFixture.images(recording)
    #expect(!images.isEmpty)
    for image in images {
      #expect(VersionNumber(image.version) != nil, "\(image.version)")
      let build = try #require(BuildNumber(image.build), "\(image.build)")
      #expect(build.description == image.build)
    }
  }

  @Test(
    "Every list runtime version and buildversion parses",
    arguments: SimctlSnapshotFixture.recordings
  )
  internal func listParses(recording: String) throws {
    let runtimes = try SimctlSnapshotFixture.snapshot(recording).list.runtimes
    #expect(!runtimes.isEmpty)
    for runtime in runtimes {
      #expect(VersionNumber(runtime.version.description) != nil, "\(runtime.version)")
      #expect(BuildNumber(runtime.buildversion) != nil, "\(runtime.buildversion)")
    }
  }

  @Test("Two installed xrOS 27.2 betas: 24N5093f is newer than 24N5088l")
  internal func installedBetasOrder() throws {
    let images = try SimctlSnapshotFixture.images("xcode-27.1-27A9275-runtime-delete")
      .filter { $0.platformIdentifier == "com.apple.platform.xrsimulator" }
      .compactMap { VersionedBuild(version: $0.version, build: $0.build) }
      .filter { $0.build.suffix != nil }
    #expect(images.count == 2)
    let newest = try #require(images.max())
    let oldest = try #require(images.min())
    #expect(newest.build.description == "24N5093f")
    #expect(oldest.build.description == "24N5088l")
    #expect(newest.isSameVersion(as: oldest))
    #expect(newest.isNewer(than: oldest))
  }

  @Test("Each platform's runtimes sort by version, then build")
  internal func platformOrder() throws {
    let images = try SimctlSnapshotFixture.images("xcode-27.1-27A9275-runtime-delete")
      .filter { $0.platformIdentifier == "com.apple.platform.iphonesimulator" }
      .compactMap { VersionedBuild(version: $0.version, build: $0.build) }
    #expect(
      images.sorted().map(\.description) == [
        "15.5 (19F70)", "16.0 (20A360)", "17.5 (21F79)", "18.3.1 (22D8075)",
        "18.5 (22F77)", "26.3.1 (23D8133)", "26.5 (23F77)", "27.0 (24A434)",
        "27.1 (24A94232)", "27.1 (24A94401)", "27.2 (24B5089g)",
      ]
    )
  }
}
