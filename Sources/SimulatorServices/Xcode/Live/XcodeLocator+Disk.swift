//
//  XcodeLocator+Disk.swift
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

  extension XcodeLocator {
    /// The `.app` bundles directly inside `directories`.
    ///
    /// Missing or unreadable folders are skipped.
    internal static func bundles(in directories: [URL]) -> [URL] {
      directories.flatMap { directory in
        let contents =
          (try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
          )) ?? []
        return
          contents
          .filter { $0.pathExtension == "app" }
          .sorted { $0.lastPathComponent < $1.lastPathComponent }
      }
    }

    /// Reads the bundle at `url`, or returns `nil` if it isn't a readable
    /// Xcode (for example it's half-installed or was deleted).
    internal static func installation(at url: URL) -> XcodeInstallation? {
      let contents = url.appending(path: "Contents", directoryHint: .isDirectory)
      let info = contents.appending(path: "Info.plist", directoryHint: .notDirectory)
      guard let infoPlist = try? Data(contentsOf: info) else {
        return nil
      }
      let version = contents.appending(
        path: "version.plist",
        directoryHint: .notDirectory
      )
      return XcodeInstallation(
        bundleAt: url,
        infoPlist: infoPlist,
        versionPlist: try? Data(contentsOf: version)
      )
    }

    /// `url` with symlinks resolved by `realpath(3)`, even when its last
    /// components don't exist.
    ///
    /// Not `resolvingSymlinksInPath()`: it gives up on a missing path, and it
    /// turns `/private/var/…` back into `/var/…`, while FSEvents reports the
    /// `/private` form.
    internal static func canonicalURL(_ url: URL) -> URL {
      let standardized = url.standardizedFileURL
      let hint: URL.DirectoryHint =
        standardized.hasDirectoryPath ? .isDirectory : .notDirectory
      if let resolved = realpath(standardized.path(percentEncoded: false), nil) {
        defer { free(resolved) }
        return URL(filePath: String(cString: resolved), directoryHint: hint)
      }
      let parent = standardized.deletingLastPathComponent()
      guard parent.path(percentEncoded: false) != standardized.path(percentEncoded: false)
      else {
        return standardized
      }
      return canonicalURL(parent)
        .appending(path: standardized.lastPathComponent, directoryHint: hint)
    }
  }
#endif
