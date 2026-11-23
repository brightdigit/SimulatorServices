//
//  XcodeLocatorLiveTests.swift
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
#if os(macOS)

  import Foundation
  import Testing

  @testable import SimulatorServices

  /// Runs the read-only `xcode-select -p` and `mdfind` on this Mac.
  ///
  /// The result depends on the Mac's Xcodes, so opt in with
  /// `STEWED_XCODE_INTEGRATION_TESTS=1`.
  @Suite(
    "XcodeLocator on this Mac",
    .enabled(
      if: ProcessInfo.processInfo.environment["STEWED_XCODE_INTEGRATION_TESTS"] == "1"
    )
  )
  internal struct XcodeLocatorLiveTests {
    @Test("Resolves an installed Xcode the way xcode-select does")
    internal func live() async throws {
      let locator = XcodeLocator()
      let snapshot = await locator.snapshot()
      let resolution = await locator.resolve(snapshot, pinnedXcode: nil)
      let installation = try #require(resolution.installation)
      #expect(snapshot.installed.contains(installation))
      let developer = try #require(resolution.developerDirectory)
      #expect(FileManager.default.fileExists(atPath: developer.path(percentEncoded: false)))
    }
  }
#endif
