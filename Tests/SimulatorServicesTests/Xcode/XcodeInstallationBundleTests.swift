//
//  XcodeInstallationBundleTests.swift
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

@Suite("Xcode bundle plists")
internal struct XcodeInstallationBundleTests {
  private let app = XcodeFixture.directoryURL("/Applications/Xcode.app")

  @Test("Prefers the recorded version.plist over Info.plist")
  internal func recorded() throws {
    // Recorded Xcode 27.2: Info.plist says 27B47, version.plist says 27B48.
    let installation = XcodeInstallation(
      bundleAt: URL(filePath: "/Applications/Xcode.app"),
      infoPlist: try XcodeFixture.data("Info.plist"),
      versionPlist: try XcodeFixture.data("version.plist")
    )
    #expect(installation == XcodeInstallation(url: app, version: "27.2", build: "27B48"))
    #expect(
      installation?.developerDirectory.path(percentEncoded: false)
        == "/Applications/Xcode.app/Contents/Developer/"
    )
  }

  @Test("Falls back to Info.plist without version.plist")
  internal func infoPlistOnly() throws {
    let installation = XcodeInstallation(
      bundleAt: app,
      infoPlist: try XcodeFixture.data("Info.plist"),
      versionPlist: nil
    )
    #expect(installation == XcodeInstallation(url: app, version: "27.2", build: "27B47"))
  }

  @Test("The build is optional")
  internal func noBuild() throws {
    let installation = XcodeInstallation(
      bundleAt: app,
      infoPlist: try XcodeFixture.plist(["CFBundleIdentifier": "com.apple.dt.Xcode"]),
      versionPlist: try XcodeFixture.plist(["CFBundleShortVersionString": "27.0"])
    )
    #expect(installation == XcodeInstallation(url: app, version: "27.0", build: nil))
  }

  @Test("Other apps aren't Xcode")
  internal func otherApp() throws {
    let installation = XcodeInstallation(
      bundleAt: XcodeFixture.directoryURL("/Applications/Instruments.app"),
      infoPlist: try XcodeFixture.plist([
        "CFBundleIdentifier": "com.apple.dt.Instruments",
        "CFBundleShortVersionString": "27.2",
      ]),
      versionPlist: try XcodeFixture.data("version.plist")
    )
    #expect(installation == nil)
  }

  @Test("No version anywhere means no installation")
  internal func noVersion() throws {
    let installation = XcodeInstallation(
      bundleAt: app,
      infoPlist: try XcodeFixture.plist([
        "CFBundleIdentifier": "com.apple.dt.Xcode", "DTXcodeBuild": "27B47",
      ]),
      versionPlist: nil
    )
    #expect(installation == nil)
  }

  @Test("A plist that doesn't parse is ignored")
  internal func garbage() {
    let installation = XcodeInstallation(
      bundleAt: app,
      infoPlist: Data("nope".utf8),
      versionPlist: nil
    )
    #expect(installation == nil)
  }
}
