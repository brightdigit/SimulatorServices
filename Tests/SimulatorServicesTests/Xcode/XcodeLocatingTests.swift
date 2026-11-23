//
//  XcodeLocatingTests.swift
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

import Foundation
import Testing

@testable import SimulatorServices

@Suite("XcodeLocating resolution")
internal struct XcodeLocatingTests {
  /// A locator with a fixed snapshot and Xcodes readable outside it.
  internal struct FixedLocator: XcodeLocating {
    internal let current: XcodeSnapshot
    internal let readable: [XcodeInstallation]

    internal func snapshot() async -> XcodeSnapshot {
      current
    }

    internal func snapshots() -> AsyncStream<XcodeSnapshot> {
      AsyncStream { continuation in
        continuation.yield(current)
        continuation.finish()
      }
    }

    internal func installation(at url: URL) async -> XcodeInstallation? {
      readable.first { $0.url == url.asDirectory }
    }

    internal func canonicalURL(_ url: URL) -> URL {
      url
    }
  }

  private let clt = SimCtl.commandLineToolsDirectory
  private let external = XcodeInstallation(
    url: XcodeFixture.directoryURL("/Volumes/External/Xcode.app"),
    version: "26.4",
    build: "17E192"
  )

  @Test("A pinned Xcode outside the scanned folders is read and used")
  internal func pinnedOutsideScannedFolders() async {
    let locator = FixedLocator(
      current: XcodeSnapshot(
        installed: [XcodeFixture.xcode], selectedDeveloperDirectory: clt
      ),
      readable: [external]
    )
    let resolution = await locator.resolution(pinnedXcode: external.url)
    #expect(resolution == .ready(external, source: .pinned))
  }

  @Test("A pinned Xcode that can't be read falls back to Automatic")
  internal func pinnedUnreadable() async {
    let locator = FixedLocator(
      current: XcodeSnapshot(
        installed: [XcodeFixture.xcode], selectedDeveloperDirectory: clt
      ),
      readable: []
    )
    let resolution = await locator.resolution(pinnedXcode: external.url)
    #expect(resolution == .ready(XcodeFixture.xcode, source: .newestInstalled))
  }

  @Test("Automatic doesn't read anything extra")
  internal func automatic() async {
    let locator = FixedLocator(
      current: XcodeSnapshot(installed: [], selectedDeveloperDirectory: clt),
      readable: [external]
    )
    let resolution = await locator.resolution(pinnedXcode: nil)
    #expect(resolution == .xcodeRequired(selectedDeveloperDirectory: clt))
  }
}
