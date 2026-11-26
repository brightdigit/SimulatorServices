//
//  XcodeLocator.swift
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

  /// The live ``XcodeLocating``.
  ///
  /// - Installed Xcodes are the bundles directly inside
  ///   `Configuration.applicationDirectories` whose `CFBundleIdentifier`
  ///   is `com.apple.dt.Xcode`, the ones Spotlight finds, and the one
  ///   `xcode-select -p` points at wherever it is.
  /// - ``snapshots()`` rescans when the application directories or the
  ///   `xcode-select` link change, and polls if FSEvents can't start.
  ///
  /// `simctl` itself is found by SimulatorServices' `SimCtl.find`, with the
  /// resolution's `developerDirectory`.
  public struct XcodeLocator: XcodeLocating {
    internal let configuration: Configuration
    private let runner: any XcodeToolRunning
    private let watcher: any PathWatching

    internal init(
      configuration: Configuration = Configuration(),
      runner: any XcodeToolRunning = XcodeToolRunner(),
      watcher: any PathWatching = FSEventsPathWatcher()
    ) {
      self.configuration = configuration
      self.runner = runner
      self.watcher = watcher
    }

    /// The live locator: the default folders, `xcode-select`, Spotlight
    /// and FSEvents.
    public init() {
      self.init(
        configuration: Configuration(),
        runner: XcodeToolRunner(),
        watcher: FSEventsPathWatcher()
      )
    }

    /// `xcode-select -p`, with `DEVELOPER_DIR` cleared because `xcode-select`
    /// prints it when it's set.
    internal func selectedDeveloperDirectory() async throws(XcodeDiscoveryError) -> URL {
      let output = try await runner.run(
        executable: configuration.xcodeSelectURL,
        arguments: ["-p"],
        environment: SimCtl.environment(
          configuration.baseEnvironment,
          developerDirectory: nil
        )
      )
      return try output.developerDirectory()
    }

    /// Looks now: every installed Xcode and `xcode-select -p`.
    ///
    /// Scans the application directories, Spotlight when it's enabled, and
    /// the selected Xcode.
    /// - Returns: The installed Xcodes and the selected developer directory.
    public func snapshot() async -> XcodeSnapshot {
      async let spotlight = configuration.usesSpotlight ? spotlightBundles() : []
      let selected = try? await selectedDeveloperDirectory()
      var candidates = Self.bundles(in: configuration.applicationDirectories)
      candidates += await spotlight
      if let selected, let app = SimCtl.xcodeURL(forDeveloperDirectory: selected) {
        candidates.append(app)
      }
      let installed = candidates.compactMap(Self.installation(at:))
        .normalized(canonicalURL: Self.canonicalURL)
      return XcodeSnapshot(installed: installed, selectedDeveloperDirectory: selected)
    }

    /// Emits a snapshot when iteration starts, then each change.
    ///
    /// Changes come from FSEvents on the application directories and the
    /// `xcode-select` link, or from polling every
    /// `Configuration.pollingInterval` when FSEvents can't start.
    /// Spotlight-only locations aren't watched.
    public func snapshots() -> AsyncStream<XcodeSnapshot> {
      let updates = XcodeSnapshotUpdates(
        paths: WatchedPaths(
          directories: configuration.applicationDirectories,
          files: [configuration.xcodeSelectLink]
        ),
        watcher: watcher,
        pollingInterval: configuration.pollingInterval
      ) { [self] in
        await snapshot()
      }
      return AsyncStream { await updates.next() }
    }

    /// The Xcode at `url`, for a pinned one outside the scanned folders.
    /// - Parameter url: The Xcode app bundle.
    /// - Returns: The installation, or `nil` if it isn't a readable Xcode
    ///   (for example it was deleted).
    public func installation(at url: URL) async -> XcodeInstallation? {
      Self.installation(at: url)
    }

    /// `url` with symlinks resolved, for comparing paths.
    /// - Parameter url: The URL to resolve.
    /// - Returns: The resolved URL.
    public func canonicalURL(_ url: URL) -> URL {
      Self.canonicalURL(url)
    }

    private func spotlightBundles() async -> [URL] {
      let query = "kMDItemCFBundleIdentifier == '\(XcodeInstallation.bundleIdentifier)'"
      let output = try? await runner.run(
        executable: configuration.mdfindURL,
        arguments: [query],
        environment: configuration.baseEnvironment
      )
      return output?.spotlightResults() ?? []
    }
  }
#endif
