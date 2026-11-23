//
//  XcodeLocating+Resolve.swift
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

extension XcodeLocating {
  /// Resolves a snapshot: pinned, then `xcode-select`, then newest installed.
  ///
  /// A pinned Xcode that isn't in the snapshot (for example one picked with
  /// Choose Xcode… outside `/Applications`) is read from disk and used if
  /// it's still there.
  public func resolve(
    _ snapshot: XcodeSnapshot,
    pinnedXcode: URL?
  ) async -> XcodeResolution {
    var installed = snapshot.installed
    if let pinnedXcode, let pinned = await installation(at: pinnedXcode) {
      installed.append(pinned)
    }
    return XcodeResolution.resolve(
      XcodeSnapshot(
        installed: installed,
        selectedDeveloperDirectory: snapshot.selectedDeveloperDirectory
      ),
      pinnedXcode: pinnedXcode,
      canonicalURL: canonicalURL
    )
  }

  /// Looks now and resolves.
  public func resolution(pinnedXcode: URL?) async -> XcodeResolution {
    await resolve(snapshot(), pinnedXcode: pinnedXcode)
  }
}
