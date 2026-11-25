//
//  XcodeSnapshotUpdates.swift
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

  /// The state behind one ``XcodeLocator/snapshots()`` stream.
  ///
  /// Nothing runs until the stream is first iterated. The watch belongs to
  /// this actor, which the stream owns, so it stops when the iterating task
  /// is cancelled or the stream is released.
  internal actor XcodeSnapshotUpdates {
    private let paths: WatchedPaths
    private let watcher: any PathWatching
    private let pollingInterval: Duration
    private let scan: @Sendable () async -> XcodeSnapshot

    private var watch: (any PathWatch)?
    private var started = false
    private var last: XcodeSnapshot?
    /// A change arrived while nobody was waiting.
    private var pendingChange = false
    /// The ``next()`` call waiting for a change.
    private var waiter: CheckedContinuation<Bool, Never>?

    internal init(
      paths: WatchedPaths,
      watcher: any PathWatching,
      pollingInterval: Duration,
      scan: @escaping @Sendable () async -> XcodeSnapshot
    ) {
      self.paths = paths
      self.watcher = watcher
      self.pollingInterval = pollingInterval
      self.scan = scan
    }

    /// The next snapshot: the current one first, then each change. `nil`
    /// ends the stream because the iterating task was cancelled.
    internal func next() async -> XcodeSnapshot? {
      guard started else {
        started = true
        // Watch before the first scan so a change in between isn't missed.
        watch = watcher.watch(paths) { [weak self] in
          Task { await self?.signal() }
        }
        let current = await scan()
        last = current
        return current
      }
      while await waitForChange() {
        let current = await scan()
        if current != last {
          last = current
          return current
        }
      }
      return nil
    }

    private func signal() {
      guard let waiter else {
        pendingChange = true
        return
      }
      self.waiter = nil
      waiter.resume(returning: true)
    }

    private func cancelWaiting() {
      let waiter = waiter
      self.waiter = nil
      waiter?.resume(returning: false)
    }

    /// Waits for a change, or for the polling interval when watching
    /// couldn't start.
    ///
    /// - Returns: `false` when the task is cancelled.
    private func waitForChange() async -> Bool {
      guard watch != nil else {
        do {
          try await Task.sleep(for: pollingInterval)
          return true
        } catch {
          return false
        }
      }
      return await withTaskCancellationHandler {
        // The closure runs in this actor's isolation, so checking for a
        // pending change and parking the continuation is one step.
        await withCheckedContinuation { continuation in
          if Task.isCancelled {
            continuation.resume(returning: false)
          } else if pendingChange {
            pendingChange = false
            continuation.resume(returning: true)
          } else {
            waiter = continuation
          }
        }
      } onCancel: {
        Task { await self.cancelWaiting() }
      }
    }

    deinit {
      watch?.cancel()
    }
  }
#endif
