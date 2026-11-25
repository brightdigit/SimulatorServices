//
//  XcodeLocator+Configuration.swift
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
    /// Where to look, what to watch, and which tools to run.
    internal struct Configuration: Sendable {
      /// `/Applications` and `~/Applications`.
      internal static var defaultApplicationDirectories: [URL] {
        [
          URL(filePath: "/Applications", directoryHint: .isDirectory),
          FileManager.default.homeDirectoryForCurrentUser
            .appending(path: "Applications", directoryHint: .isDirectory),
        ]
      }

      /// Folders scanned (one level deep) for Xcode bundles, and watched.
      internal var applicationDirectories: [URL]
      /// Whether to ask Spotlight for Xcodes elsewhere.
      ///
      /// That finds, for example, an expanded `.xip` in `~/Downloads`. Those
      /// places aren't watched.
      internal var usesSpotlight: Bool
      /// The environment commands inherit. `DEVELOPER_DIR` is cleared for
      /// `xcode-select`.
      internal var baseEnvironment: [String: String]
      /// How often to rescan when FSEvents can't watch.
      internal var pollingInterval: Duration
      /// The symlink `xcode-select -s` replaces, watched for changes.
      ///
      /// The selection itself is read with `xcode-select -p`, which falls
      /// back to another Xcode when the link's target is gone.
      internal var xcodeSelectLink: URL
      /// `xcode-select`.
      internal var xcodeSelectURL: URL
      /// `mdfind`.
      internal var mdfindURL: URL

      internal init(
        applicationDirectories: [URL] = Self.defaultApplicationDirectories,
        usesSpotlight: Bool = true,
        baseEnvironment: [String: String] = ProcessInfo.processInfo.environment,
        pollingInterval: Duration = .seconds(5),
        xcodeSelectLink: URL = URL(filePath: "/var/db/xcode_select_link"),
        xcodeSelectURL: URL = URL(filePath: "/usr/bin/xcode-select"),
        mdfindURL: URL = URL(filePath: "/usr/bin/mdfind")
      ) {
        self.applicationDirectories = applicationDirectories
        self.usesSpotlight = usesSpotlight
        self.baseEnvironment = baseEnvironment
        self.pollingInterval = pollingInterval
        self.xcodeSelectLink = xcodeSelectLink
        self.xcodeSelectURL = xcodeSelectURL
        self.mdfindURL = mdfindURL
      }
    }
  }
#endif
