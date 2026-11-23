//
//  XcodeLocatorTests.swift
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

  @Suite("XcodeLocator scanning")
  internal struct XcodeLocatorTests {
    private let temp: TemporaryDirectory
    private let applications: URL
    private let userApplications: URL

    internal init() throws {
      temp = try TemporaryDirectory()
      applications = try temp.directory("Applications")
      userApplications = temp.url.appending(
        path: "Home/Applications", directoryHint: .isDirectory
      )
    }

    @Test("Reads recorded xcode-select -p with DEVELOPER_DIR cleared")
    internal func selectedDeveloperDirectory() async throws {
      let runner = RecordingToolRunner([
        "xcode-select": try XcodeToolOutput.recorded("xcode-select-p.stdout")
      ])
      let url = try await locator(runner).selectedDeveloperDirectory()
      #expect(
        url.path(percentEncoded: false) == "/Applications/Xcode.app/Contents/Developer/"
      )
      let invocation = try #require(runner.invocations.first)
      #expect(invocation.executable == URL(filePath: "/usr/bin/xcode-select"))
      #expect(invocation.arguments == ["-p"])
      #expect(invocation.environment == ["PATH": "/usr/bin"])
    }

    @Test("Lists Xcode bundles in every application folder, newest first")
    internal func installedXcodes() async throws {
      try temp.bundle(
        in: applications, name: "Xcode.app", version: "27.1", build: "27A9275"
      )
      try temp.bundle(
        in: applications,
        name: "Instruments.app",
        bundleIdentifier: "com.apple.dt.Instruments",
        version: "27.1"
      )
      try temp.bundle(in: applications, name: "NotAnApp", version: "99.0")
      try FileManager.default.createDirectory(
        at: userApplications, withIntermediateDirectories: true
      )
      try temp.bundle(
        in: userApplications,
        name: "Xcode-beta.app",
        version: "27.2",
        build: "27B5028f"
      )

      let snapshot = await locator(RecordingToolRunner()).snapshot()
      #expect(
        snapshot.installed.map(\.url.lastPathComponent) == ["Xcode-beta.app", "Xcode.app"]
      )
      #expect(snapshot.installed.map(\.build) == ["27B5028f", "27A9275"])
      #expect(snapshot.selectedDeveloperDirectory == nil)
    }

    @Test("Adds Spotlight results outside the folders, without duplicates")
    internal func spotlight() async throws {
      let xcode = try temp.bundle(in: applications, name: "Xcode.app", version: "27.1")
      let downloads = try temp.directory("Downloads")
      let expanded = try temp.bundle(in: downloads, name: "Xcode 26.app", version: "26.4")
      let runner = RecordingToolRunner([
        "mdfind": XcodeToolOutput.text(
          """
          \(xcode.path(percentEncoded: false))
          \(expanded.path(percentEncoded: false))
          /nonexistent/Xcode.app
          """
        )
      ])
      let snapshot = await locator(runner, usesSpotlight: true).snapshot()
      #expect(snapshot.installed.map(\.version) == ["27.1", "26.4"])
      let query = runner.invocations.filter { $0.executable.lastPathComponent == "mdfind" }
      #expect(
        query.map(\.arguments) == [["kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'"]]
      )
    }

    @Test("A failing Spotlight leaves the folder scan")
    internal func spotlightUnavailable() async throws {
      try temp.bundle(in: applications, name: "Xcode.app", version: "27.1")
      let snapshot = await locator(RecordingToolRunner(), usesSpotlight: true).snapshot()
      #expect(snapshot.installed.count == 1)
    }

    @Test("Lists xcode-select's Xcode even outside the application folders")
    internal func selectedOutsideApplications() async throws {
      let external = try temp.directory("Volumes/External")
      let xcode = try temp.bundle(in: external, name: "Xcode.app", version: "27.1")
      let developer = xcode.appending(path: "Contents/Developer")
      let runner = RecordingToolRunner([
        "xcode-select": XcodeToolOutput.text(developer.path(percentEncoded: false) + "\n")
      ])
      let locator = locator(runner)
      let snapshot = await locator.snapshot()
      #expect(snapshot.installed.map(\.url) == [xcode])
      let resolution = await locator.resolution(pinnedXcode: nil)
      #expect(resolution == .ready(snapshot.installed[0], source: .xcodeSelect))
    }

    @Test("A symlinked Xcode is listed once")
    internal func symlinkDedupe() async throws {
      let real = try temp.bundle(in: applications, name: "Xcode_27.1.app", version: "27.1")
      let link = applications.appending(path: "Xcode.app", directoryHint: .isDirectory)
      try FileManager.default.createSymbolicLink(at: link, withDestinationURL: real)
      let snapshot = await locator(RecordingToolRunner()).snapshot()
      #expect(snapshot.installed.count == 1)
    }

    @Test("A pinned Xcode that was deleted falls back to Automatic")
    internal func deletedPin() async throws {
      let pinned = try temp.bundle(
        in: applications, name: "Xcode-beta.app", version: "27.2"
      )
      let xcode = try temp.bundle(in: applications, name: "Xcode.app", version: "27.1")
      let developer = xcode.appending(path: "Contents/Developer")
      let runner = RecordingToolRunner([
        "xcode-select": XcodeToolOutput.text(developer.path(percentEncoded: false) + "\n")
      ])
      let locator = locator(runner)
      #expect(await locator.resolution(pinnedXcode: pinned).installation?.version == "27.2")

      try FileManager.default.removeItem(at: pinned)
      let resolution = await locator.resolution(pinnedXcode: pinned)
      #expect(resolution.installation?.version == "27.1")
      #expect(
        resolution == .ready(try #require(resolution.installation), source: .xcodeSelect)
      )
    }
  }

  extension XcodeLocatorTests {
    private func locator(
      _ runner: RecordingToolRunner,
      usesSpotlight: Bool = false
    ) -> XcodeLocator {
      XcodeLocator(
        configuration: .init(
          applicationDirectories: [applications, userApplications],
          usesSpotlight: usesSpotlight,
          baseEnvironment: ["PATH": "/usr/bin", "DEVELOPER_DIR": "/inherited"]
        ),
        runner: runner,
        watcher: ManualPathWatcher()
      )
    }
  }
#endif
