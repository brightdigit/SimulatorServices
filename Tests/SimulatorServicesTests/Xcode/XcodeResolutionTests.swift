//
//  XcodeResolutionTests.swift
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

@Suite("Xcode resolution")
internal struct XcodeResolutionTests {
  private let clt = SimCtl.commandLineToolsDirectory
  private let xcode = XcodeFixture.xcode
  private let beta = XcodeFixture.beta

  private func resolve(
    _ installed: [XcodeInstallation],
    selected: URL?,
    pinned: URL? = nil
  ) -> XcodeResolution {
    XcodeResolution.resolve(
      XcodeSnapshot(installed: installed, selectedDeveloperDirectory: selected),
      pinnedXcode: pinned,
      canonicalURL: { $0 }
    )
  }

  @Test("No Xcode with the Command Line Tools selected requires Xcode, with the note")
  internal func commandLineToolsOnly() {
    let resolution = resolve([], selected: clt)
    #expect(resolution == .xcodeRequired(selectedDeveloperDirectory: clt))
    #expect(resolution.commandLineToolsDirectory == clt)
    #expect(resolution.installation == nil)
    #expect(resolution.developerDirectory == nil)
  }

  @Test("No Xcode and no xcode-select requires Xcode, without the note")
  internal func noDeveloperTools() {
    let resolution = resolve([], selected: nil)
    #expect(resolution == .xcodeRequired(selectedDeveloperDirectory: nil))
    #expect(resolution.commandLineToolsDirectory == nil)
  }

  @Test("No Xcode with xcode-select at a deleted Xcode requires Xcode, without the note")
  internal func selectedXcodeDeleted() {
    let resolution = resolve([], selected: xcode.developerDirectory)
    #expect(
      resolution == .xcodeRequired(selectedDeveloperDirectory: xcode.developerDirectory)
    )
    #expect(resolution.commandLineToolsDirectory == nil)
  }

  @Test("Automatic uses xcode-select's Xcode and still sets DEVELOPER_DIR")
  internal func xcodeSelect() {
    let resolution = resolve(
      [beta, xcode],
      selected: URL(filePath: "/Applications/Xcode.app/Contents/Developer/")
    )
    #expect(resolution == .ready(xcode, source: .xcodeSelect))
    #expect(resolution.developerDirectory == xcode.developerDirectory)
  }

  @Test("Automatic uses the newest Xcode when xcode-select is the Command Line Tools")
  internal func newestOverCommandLineTools() {
    let resolution = resolve([beta, xcode], selected: clt)
    #expect(resolution == .ready(beta, source: .newestInstalled))
    #expect(resolution.developerDirectory == beta.developerDirectory)
    #expect(resolution.commandLineToolsDirectory == nil)
  }

  @Test("Automatic uses the newest Xcode when xcode-select can't be read")
  internal func newestWithoutXcodeSelect() {
    #expect(
      resolve([beta, xcode], selected: nil) == .ready(beta, source: .newestInstalled)
    )
  }

  @Test("Automatic uses the newest Xcode when xcode-select's Xcode was deleted")
  internal func newestOverDeletedSelection() {
    let resolution = resolve(
      [xcode],
      selected: XcodeFixture.directoryURL("/Applications/Xcode_26.app/Contents/Developer")
    )
    #expect(resolution == .ready(xcode, source: .newestInstalled))
  }

  @Test("A pinned Xcode wins over xcode-select")
  internal func pinned() {
    let resolution = resolve(
      [beta, xcode],
      selected: xcode.developerDirectory,
      pinned: URL(filePath: "/Applications/Xcode-beta.app")
    )
    #expect(resolution == .ready(beta, source: .pinned))
    #expect(resolution.developerDirectory == beta.developerDirectory)
  }

  @Test("A pin can name the developer directory instead of the app")
  internal func pinnedDeveloperDirectory() {
    let resolution = resolve(
      [beta, xcode],
      selected: clt,
      pinned: xcode.developerDirectory
    )
    #expect(resolution == .ready(xcode, source: .pinned))
  }

  @Test("A deleted pinned Xcode falls back to xcode-select")
  internal func pinnedDeletedFallsBackToXcodeSelect() {
    let resolution = resolve(
      [xcode], selected: xcode.developerDirectory, pinned: beta.url
    )
    #expect(resolution == .ready(xcode, source: .xcodeSelect))
  }

  @Test("A deleted pinned Xcode falls back to the newest Xcode")
  internal func pinnedDeletedFallsBackToNewest() {
    let older = XcodeFixture.installation("Xcode_26.4.app", "26.4", "17E192")
    let resolution = resolve([xcode, older], selected: clt, pinned: beta.url)
    #expect(resolution == .ready(xcode, source: .newestInstalled))
  }

  @Test("A deleted pinned Xcode with nothing else installed requires Xcode")
  internal func pinnedDeletedNothingInstalled() {
    let resolution = resolve([], selected: clt, pinned: beta.url)
    #expect(resolution == .xcodeRequired(selectedDeveloperDirectory: clt))
  }

  @Test("A pin through a symlink matches the real bundle")
  internal func pinnedThroughSymlink() {
    let link = XcodeFixture.directoryURL("/Applications/Xcode-current.app")
    let canonical: (URL) -> URL = { url in
      let path = url.path(percentEncoded: false)
      return URL(filePath: path.replacing("Xcode-current.app", with: "Xcode-beta.app"))
    }
    let resolution = XcodeResolution.resolve(
      XcodeSnapshot(installed: [beta, xcode], selectedDeveloperDirectory: clt),
      pinnedXcode: link,
      canonicalURL: canonical
    )
    #expect(resolution == .ready(beta, source: .pinned))
  }
}
