//
//  WatchedPathsTests.swift
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

  @Suite("Watched paths", .enabled(if: Platform.isMacOS))
  internal struct WatchedPathsTests {
    private let paths = WatchedPaths(
      directories: [
        URL(filePath: "/Applications", directoryHint: .isDirectory),
        URL(filePath: "/Users/USER/Applications", directoryHint: .isDirectory),
      ],
      files: [URL(filePath: "/var/db/xcode_select_link")],
      canonicalURL: { url in
        // `/var` is a symlink to `/private/var`.
        let path = url.path(percentEncoded: false)
        return path.hasPrefix("/var/")
          ? URL(filePath: "/private" + path, directoryHint: .isDirectory)
          : url
      }
    )

    @Test("Streams the directories and each file's real parent, once each")
    internal func streamPaths() {
      #expect(
        paths.streamPaths == [
          "/Applications", "/Users/USER/Applications", "/private/var/db",
        ])
    }

    @Test(
      "Anything inside a watched directory matches",
      arguments: [
        "/Applications",
        "/Applications/Xcode.app",
        "/Applications/Xcode-beta.app/Contents/Info.plist",
        "/Users/USER/Applications/Xcode.app/",
      ]
    )
    internal func directoryMatches(path: String) {
      #expect(paths.matches(path))
    }

    @Test(
      "Only the watched file matches in its folder",
      arguments: [
        ("/private/var/db/xcode_select_link", true),
        ("/var/db/xcode_select_link", true),
        ("/private/var/db/diagnostics/logdata.statistics.0.txt", false),
        ("/private/var/db/xcode_select_link.new", false),
        ("/ApplicationsOther/Xcode.app", false),
        ("/", false),
      ]
    )
    internal func fileMatches(path: String, expected: Bool) {
      #expect(paths.matches(path) == expected)
    }

    @Test("Resolves a symlinked parent on disk")
    internal func liveCanonicalURL() throws {
      let temp = try TemporaryDirectory()
      let real = try temp.directory("real")
      let linked = temp.url.appending(path: "linked", directoryHint: .isDirectory)
      try FileManager.default.createSymbolicLink(at: linked, withDestinationURL: real)
      let file = linked.appending(path: "missing-link")
      let watched = WatchedPaths(directories: [], files: [file])
      let stream = try #require(watched.streamPaths.first)
      #expect(watched.streamPaths.count == 1)
      #expect(stream.hasPrefix("/private/var/"))
      #expect(stream.hasSuffix("/real"))
      #expect(watched.matches(stream + "/missing-link"))
      #expect(!watched.matches(stream + "/other"))
    }

    @Test("Keeps the /private form FSEvents reports")
    internal func privateVar() {
      let url = XcodeLocator.canonicalURL(
        URL(filePath: "/var/db/xcode_select_link-missing")
      )
      #expect(
        url.path(percentEncoded: false) == "/private/var/db/xcode_select_link-missing"
      )
    }
  }
#endif
