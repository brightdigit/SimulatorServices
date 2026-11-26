//
//  FSEventsPathWatcherTests.swift
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

  /// Runs real FSEvents on a temporary folder.
  ///
  /// Nothing here reads the Mac's installed Xcodes.
  @Suite(
    "FSEvents path watcher",
    .enabled(if: Platform.isMacOS),
    .timeLimit(.minutes(1))
  )
  internal struct FSEventsPathWatcherTests {
    /// Whether watching `paths` reports a change while `touch` runs.
    ///
    /// `touch` runs every 200 ms until a change arrives or `timeout` passes.
    /// FSEvents only reports events after the stream starts, so repeating
    /// it means the test can't race the start.
    private static func reportsChange(
      _ paths: WatchedPaths,
      timeout: Duration = .seconds(30),
      touch: @escaping @Sendable (Int) -> Void
    ) async throws -> Bool {
      let (changes, continuation) = AsyncStream.makeStream(of: Void.self)
      let watch = try #require(
        FSEventsPathWatcher(latency: 0.1).watch(paths) { continuation.yield() }
      )
      defer { watch.cancel() }
      let writer = Task {
        var index = 0
        while !Task.isCancelled {
          touch(index)
          index += 1
          try? await Task.sleep(for: .milliseconds(200))
        }
      }
      defer { writer.cancel() }
      return await firstChange(changes, continuation, timeout: timeout)
    }

    /// Whether `changes` emits before `timeout` passes. Finishes
    /// `continuation` either way.
    private static func firstChange(
      _ changes: AsyncStream<Void>,
      _ continuation: AsyncStream<Void>.Continuation,
      timeout: Duration
    ) async -> Bool {
      await withTaskGroup(of: Bool.self) { group in
        group.addTask {
          var iterator = changes.makeAsyncIterator()
          return await iterator.next() != nil
        }
        group.addTask {
          try? await Task.sleep(for: timeout)
          return false
        }
        let first = await group.next() ?? false
        group.cancelAll()
        continuation.finish()
        return first
      }
    }

    @Test("Reports a bundle appearing in a watched folder")
    internal func directoryChange() async throws {
      let temp = try TemporaryDirectory()
      let applications = try temp.directory("Applications")
      let reported = try await Self.reportsChange(
        WatchedPaths(directories: [applications], files: [])
      ) { index in
        _ = try? temp.bundle(in: applications, name: "Xcode\(index).app", version: "27.1")
      }
      #expect(reported)
    }

    @Test("Reports a watched symlink being replaced, as xcode-select -s does")
    internal func fileReplaced() async throws {
      let temp = try TemporaryDirectory()
      let database = try temp.directory("db")
      let link = database.appending(path: "xcode_select_link")
      let reported = try await Self.reportsChange(
        WatchedPaths(directories: [], files: [link])
      ) { index in
        try? FileManager.default.removeItem(at: link)
        try? FileManager.default.createSymbolicLink(
          atPath: link.path(percentEncoded: false),
          withDestinationPath: "/Applications/Xcode\(index).app/Contents/Developer"
        )
      }
      #expect(reported)
    }

    @Test("Ignores other files next to a watched file")
    internal func siblingIgnored() async throws {
      let temp = try TemporaryDirectory()
      let database = try temp.directory("db")
      let reported = try await Self.reportsChange(
        WatchedPaths(
          directories: [], files: [database.appending(path: "xcode_select_link")]
        ),
        timeout: .milliseconds(1_500)
      ) { index in
        try? Data("\(index)".utf8).write(to: database.appending(path: "other"))
      }
      #expect(!reported)
    }

    @Test("No paths means no watch")
    internal func noPaths() {
      let watch = FSEventsPathWatcher().watch(WatchedPaths(directories: [], files: [])) {}
      #expect(watch == nil)
    }
  }
#endif
