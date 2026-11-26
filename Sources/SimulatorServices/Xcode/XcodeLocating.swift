//
//  XcodeLocating.swift
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

import Foundation

/// Finds the installed Xcodes and the `xcode-select` target, and reports
/// when either changes.
///
/// Conforming types decide how to look (a folder scan, Spotlight, a file
/// watcher) and which Xcode to use from the ``XcodeSnapshot`` they report.
public protocol XcodeLocating: Sendable {
  /// Looks now: every installed Xcode and `xcode-select -p`.
  func snapshot() async -> XcodeSnapshot

  /// Emits a snapshot when iteration starts, then again whenever an Xcode
  /// is installed or removed or `xcode-select -s` changes. Unchanged
  /// rescans aren't emitted. Watching stops when the iterating task is
  /// cancelled.
  func snapshots() -> AsyncStream<XcodeSnapshot>

  /// The Xcode at `url`, for a pinned one outside the scanned folders, or
  /// `nil` if it isn't a readable Xcode (for example it was deleted).
  func installation(at url: URL) async -> XcodeInstallation?

  /// `url` with symlinks resolved, for comparing paths.
  func canonicalURL(_ url: URL) -> URL
}
