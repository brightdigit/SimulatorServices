//
//  ManualPathWatcher.swift
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
  import Synchronization

  @testable import SimulatorServices

  /// A ``PathWatching`` whose changes the test triggers with ``signal()``.
  internal final class ManualPathWatcher: PathWatching {
    internal final class Watch: PathWatch {
      internal let onChange: @Sendable () -> Void
      internal let cancelled = Mutex(false)

      internal init(_ onChange: @escaping @Sendable () -> Void) {
        self.onChange = onChange
      }

      internal func cancel() {
        cancelled.withLock { $0 = true }
      }
    }

    private let state = Mutex<(paths: WatchedPaths?, watch: Watch?)>((nil, nil))
    private let fails: Bool

    /// What was watched, if watching started.
    internal var watchedPaths: WatchedPaths? {
      state.withLock { $0.paths }
    }

    // `nil` (never started) differs from `false` (started, not cancelled).
    // swiftlint:disable discouraged_optional_boolean
    /// Whether the watch was cancelled, or `nil` if it never started.
    internal var isCancelled: Bool? {
      state.withLock { $0.watch }?.cancelled.withLock { $0 }
    }
    // swiftlint:enable discouraged_optional_boolean

    /// - Parameter fails: Act as if FSEvents couldn't start.
    internal init(fails: Bool = false) {
      self.fails = fails
    }

    internal func watch(
      _ paths: WatchedPaths,
      onChange: @escaping @Sendable () -> Void
    ) -> (any PathWatch)? {
      guard !fails else {
        return nil
      }
      let watch = Watch(onChange)
      state.withLock { $0 = (paths, watch) }
      return watch
    }

    /// Reports a change.
    internal func signal() {
      state.withLock { $0.watch }?.onChange()
    }
  }
#endif
