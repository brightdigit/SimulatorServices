//
//  XcodeInstallationArrayTests.swift
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

@Suite("Xcode selection")
internal struct XcodeInstallationArrayTests {
  private let xcode = XcodeFixture.xcode
  private let beta = XcodeFixture.beta
  private let xcode2710 = XcodeFixture.installation("Xcode_27.10.app", "27.10")
  private let xcode26 = XcodeFixture.installation("Xcode_26.4.app", "26.4", "17E192")

  @Test("Orders newest version first, comparing numerically")
  internal func ordering() {
    let sorted = [xcode26, xcode, xcode2710, beta].normalized(canonicalURL: { $0 })
    #expect(sorted == [xcode2710, beta, xcode, xcode26])
  }

  @Test("Equal versions are ordered by path")
  internal func ties() {
    let other = XcodeFixture.installation("Xcode-27.1.app", "27.1.0", "27A9275")
    let sorted = [xcode, other].normalized(canonicalURL: { $0 })
    #expect(sorted == [other, xcode])
  }

  @Test("A version that doesn't parse sorts last")
  internal func unparsedVersion() {
    let odd = XcodeFixture.installation("Aardvark.app", "27.2 beta")
    let sorted = [odd, xcode26].normalized(canonicalURL: { $0 })
    #expect(sorted == [xcode26, odd])
  }

  @Test("The same bundle found twice is listed once")
  internal func duplicates() {
    let viaSpotlight = XcodeInstallation(
      url: URL(filePath: "/Applications/Xcode.app"),
      version: "27.1",
      build: "27A9275"
    )
    #expect(
      [xcode, viaSpotlight].normalized(canonicalURL: { $0 }) == [xcode]
    )
  }

  @Test("A symlink to a listed bundle is listed once, keeping the first URL")
  internal func symlinks() {
    let link = XcodeFixture.installation("Xcode-link.app", "27.1", "27A9275")
    let canonical: (URL) -> URL = { url in
      url.lastPathComponent == "Xcode-link.app" ? xcode.url : url
    }
    #expect([link, xcode].normalized(canonicalURL: canonical) == [link])
  }

  @Test("Matches a developer directory to an installation")
  internal func matchesDeveloperDirectory() {
    let selected = URL(filePath: "/Applications/Xcode-beta.app/Contents/Developer")
    #expect(
      [xcode, beta].installation(
        forDeveloperDirectory: selected,
        canonicalURL: { $0 }
      ) == beta
    )
    #expect(
      [xcode, beta].installation(
        forDeveloperDirectory: SimCtl.commandLineToolsDirectory,
        canonicalURL: { $0 }
      ) == nil
    )
  }
}
