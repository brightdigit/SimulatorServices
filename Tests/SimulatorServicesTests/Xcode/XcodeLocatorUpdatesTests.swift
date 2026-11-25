//
//  XcodeLocatorUpdatesTests.swift
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

  @Suite("XcodeLocator updates", .enabled(if: Platform.isMacOS))
  internal struct XcodeLocatorUpdatesTests {
    private let temp: TemporaryDirectory
    private let applications: URL
    private let link: URL

    internal init() throws {
      temp = try TemporaryDirectory()
      applications = try temp.directory("Applications")
      link = try temp.directory("db").appending(path: "xcode_select_link")
    }

    /// Polls `condition` until it's true, failing after five seconds.
    private static func waitUntil(_ condition: () -> Bool) async throws {
      let deadline = ContinuousClock.now + .seconds(5)
      while !condition() {
        guard ContinuousClock.now < deadline else {
          Issue.record("Timed out waiting for condition")
          return
        }
        try await Task.sleep(for: .milliseconds(10))
      }
    }

    /// Iterates `locator`'s snapshots in a task, forwarding each one to
    /// the returned stream, which finishes when the task is cancelled.
    private static func forward(
      _ locator: XcodeLocator
    ) -> (consumer: Task<Void, Never>, emitted: AsyncStream<XcodeSnapshot>) {
      let (emitted, continuation) = AsyncStream.makeStream(of: XcodeSnapshot.self)
      let consumer = Task {
        for await snapshot in locator.snapshots() {
          continuation.yield(snapshot)
        }
        continuation.finish()
      }
      return (consumer, emitted)
    }

    private func locator(
      _ runner: RecordingToolRunner,
      watcher: any PathWatching,
      pollingInterval: Duration = .seconds(5)
    ) -> XcodeLocator {
      XcodeLocator(
        configuration: .init(
          applicationDirectories: [applications],
          usesSpotlight: false,
          baseEnvironment: [:],
          pollingInterval: pollingInterval,
          xcodeSelectLink: link
        ),
        runner: runner,
        watcher: watcher
      )
    }

    @Test("Watches the application folders and the xcode-select link")
    internal func watchedPaths() async throws {
      let watcher = ManualPathWatcher()
      var iterator = locator(RecordingToolRunner(), watcher: watcher)
        .snapshots().makeAsyncIterator()
      _ = await iterator.next()
      let paths = try #require(watcher.watchedPaths)
      #expect(paths.directories == [applications])
      #expect(paths.files == [link])
    }

    @Test("Emits the current snapshot, then each change, and stops when cancelled")
    internal func updates() async throws {
      let watcher = ManualPathWatcher()
      let runner = RecordingToolRunner()
      let (consumer, emitted) = Self.forward(locator(runner, watcher: watcher))
      var iterator = emitted.makeAsyncIterator()
      #expect(await iterator.next()?.installed.isEmpty == true)

      try temp.bundle(in: applications, name: "Xcode.app", version: "27.1")
      watcher.signal()
      #expect(await iterator.next()?.installed.map(\.version) == ["27.1"])

      // A change that doesn't affect the snapshot is rescanned, not emitted.
      _ = try temp.directory("Applications/Other.app")
      watcher.signal()
      try await Self.waitUntil { runner.count("xcode-select") == 3 }

      // `xcode-select -s` changes the selection without touching the folder.
      let developer = applications.appending(path: "Xcode.app/Contents/Developer")
      runner.set(
        "xcode-select", XcodeToolOutput.text(developer.path(percentEncoded: false) + "\n")
      )
      watcher.signal()
      let selected = await iterator.next()?.selectedDeveloperDirectory
      let app = selected.flatMap(SimCtl.xcodeURL(forDeveloperDirectory:))
      #expect(app?.lastPathComponent == "Xcode.app")

      consumer.cancel()
      await consumer.value
      #expect(await iterator.next() == nil)
      #expect(watcher.isCancelled == true)
    }

    @Test("A stream that's never iterated does nothing")
    internal func notIterated() {
      let watcher = ManualPathWatcher()
      let runner = RecordingToolRunner()
      _ = locator(runner, watcher: watcher).snapshots()
      #expect(watcher.isCancelled == nil)
      #expect(runner.invocations.isEmpty)
    }

    @Test("Polls when the paths can't be watched")
    internal func polling() async throws {
      let locator = locator(
        RecordingToolRunner(),
        watcher: ManualPathWatcher(fails: true),
        pollingInterval: .milliseconds(20)
      )
      var iterator = locator.snapshots().makeAsyncIterator()
      #expect(await iterator.next()?.installed.isEmpty == true)
      try temp.bundle(in: applications, name: "Xcode.app", version: "27.1")
      #expect(await iterator.next()?.installed.map(\.version) == ["27.1"])
    }
  }
#endif
