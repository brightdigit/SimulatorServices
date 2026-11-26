//
//  FSEventsPathWatcher.swift
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

  /// Watches paths with FSEvents, using file-level events so a single file
  /// such as `/var/db/xcode_select_link` can be watched through its folder.
  ///
  /// FSEvents is recursive, so a change inside `Xcode.app` (for example its
  /// `Info.plist` written at the end of an App Store install or a `.xip`
  /// expansion) counts as well as the bundle appearing or going away.
  /// Directories that don't exist yet, such as a missing `~/Applications`,
  /// are watched by path.
  internal struct FSEventsPathWatcher: PathWatching {
    /// How long FSEvents coalesces changes before reporting them, in seconds.
    internal let latency: TimeInterval

    internal init(latency: TimeInterval = 1.0) {
      self.latency = latency
    }

    internal func watch(
      _ paths: WatchedPaths,
      onChange: @escaping @Sendable () -> Void
    ) -> (any PathWatch)? {
      guard !paths.streamPaths.isEmpty else {
        return nil
      }
      return FSEventsPathWatch(paths: paths, latency: latency, onChange: onChange)
    }
  }
#endif
