//
//  XcodeSnapshot.swift
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

/// What's on disk when an ``XcodeLocating`` looked: the installed Xcodes
/// and the `xcode-select -p` target. Which Xcode to use is decided from
/// this.
public struct XcodeSnapshot: Sendable, Hashable {
  /// Every installed Xcode, newest first, with duplicates removed.
  public let installed: [XcodeInstallation]
  /// What `xcode-select -p` printed with `DEVELOPER_DIR` cleared, or `nil`
  /// if it failed.
  public let selectedDeveloperDirectory: URL?

  /// Creates a snapshot.
  public init(installed: [XcodeInstallation], selectedDeveloperDirectory: URL?) {
    self.installed = installed
    self.selectedDeveloperDirectory = selectedDeveloperDirectory
  }
}
