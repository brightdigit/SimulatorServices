//
//  XcodePreferenceTests.swift
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

@Suite("Xcode preference")
internal struct XcodePreferenceTests {
  @Test("Automatic is stored as an empty string")
  internal func automatic() {
    #expect(XcodePreference.automatic.rawValue.isEmpty)
    #expect(XcodePreference(rawValue: "") == .automatic)
    #expect(XcodePreference.automatic.pinnedXcode == nil)
  }

  @Test("A pinned Xcode round-trips through its path")
  internal func pinned() {
    let url = URL(filePath: "/Volumes/External/Xcode.app", directoryHint: .isDirectory)
    let preference = XcodePreference.pinned(url)
    #expect(XcodePreference(rawValue: preference.rawValue) == preference)
    #expect(preference.pinnedXcode == url)
  }

  @Test("A path with spaces isn't percent-encoded")
  internal func spaces() {
    let url = URL(filePath: "/Applications/Xcode 27.app", directoryHint: .isDirectory)
    #expect(XcodePreference.pinned(url).rawValue == "/Applications/Xcode 27.app/")
  }
}
