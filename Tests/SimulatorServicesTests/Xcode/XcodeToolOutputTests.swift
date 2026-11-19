//
//  XcodeToolOutputTests.swift
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

@Suite("Xcode tool output")
internal struct XcodeToolOutputTests {
  private static let simctlNotFound =
    "xcrun: error: unable to find utility \"simctl\", not a developer tool or in PATH\n"

  @Test("Parses recorded xcode-select -p as a directory")
  internal func recordedXcodeSelect() throws {
    let output = XcodeToolOutput(
      standardOutput: try XcodeFixture.data("xcode-select-p.stdout")
    )
    let url = try output.developerDirectory()
    #expect(
      url == XcodeFixture.directoryURL("/Applications/Xcode.app/Contents/Developer")
    )
    #expect(url.hasDirectoryPath)
  }

  @Test("Parses recorded xcode-select -p with DEVELOPER_DIR set")
  internal func recordedDeveloperDirectory() throws {
    let output = XcodeToolOutput(
      standardOutput: try XcodeFixture.data("xcode-select-p-developer-dir.stdout")
    )
    let url = try output.developerDirectory()
    #expect(SimCtl.isCommandLineTools(url))
  }

  @Test("Keeps spaces in paths and skips blank lines")
  internal func spacesAndBlankLines() throws {
    let output = XcodeFixture.output(
      "\n  /Applications/Xcode 27 beta.app/Contents/Developer  \n\n"
    )
    let url = try output.developerDirectory()
    #expect(
      url.path(percentEncoded: false)
        == "/Applications/Xcode 27 beta.app/Contents/Developer/"
    )
  }

  @Test("A non-zero exit carries stderr verbatim")
  internal func failure() {
    let output = XcodeFixture.output(
      "",
      exitCode: 72,
      standardError: Self.simctlNotFound
    )
    let expected = XcodeDiscoveryError.commandFailed(
      command: "xcode-select -p",
      exitCode: 72,
      standardError: Self.simctlNotFound
    )
    #expect(throws: expected) {
      try output.developerDirectory()
    }
    #expect(expected.errorDescription?.contains("exit code 72: xcrun: error") == true)
  }

  @Test("Empty output is an error")
  internal func empty() {
    #expect(throws: XcodeDiscoveryError.emptyOutput(command: "xcode-select -p")) {
      try XcodeFixture.output(" \n").developerDirectory()
    }
  }

  @Test("A relative path is an error")
  internal func relative() {
    let expected = XcodeDiscoveryError.notAnAbsolutePath(
      command: "xcode-select -p",
      output: "Developer"
    )
    #expect(throws: expected) {
      try XcodeFixture.output("Developer\n").developerDirectory()
    }
  }

  @Test("Parses recorded mdfind output")
  internal func recordedSpotlight() throws {
    let output = XcodeToolOutput(
      standardOutput: try XcodeFixture.data("mdfind-xcode.stdout")
    )
    #expect(
      output.spotlightResults() == [XcodeFixture.directoryURL("/Applications/Xcode.app")]
    )
  }

  @Test("Spotlight results skip blanks, relative paths and the Trash")
  internal func spotlightFiltering() {
    let output = XcodeFixture.output(
      """
      /Applications/Xcode-beta.app

      relative/Xcode.app
      /Users/USER/.Trash/Xcode-old.app
      /Volumes/External/.Trashes/501/Xcode.app
      /Volumes/External/Xcode 26.app

      """
    )
    #expect(
      output.spotlightResults() == [
        XcodeFixture.directoryURL("/Applications/Xcode-beta.app"),
        XcodeFixture.directoryURL("/Volumes/External/Xcode 26.app"),
      ]
    )
  }

  @Test("A failed Spotlight query finds nothing")
  internal func spotlightFailure() {
    let output = XcodeFixture.output("/Applications/Xcode.app\n", exitCode: 1)
    #expect(output.spotlightResults().isEmpty)
  }
}
