//
//  XcodeResolution+Resolve.swift
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

extension XcodeResolution {
  /// Resolves the Xcode to use, in this order:
  ///
  /// 1. The pinned Xcode, if it's installed. A pinned Xcode that's been
  ///    deleted falls back to Automatic.
  /// 2. Automatic: the Xcode `xcode-select -p` points at, if it's a full
  ///    Xcode that's installed.
  /// 3. Automatic: otherwise the newest installed Xcode, betas included.
  /// 4. Otherwise Xcode is required.
  ///
  /// - Parameters:
  ///   - snapshot: The installed Xcodes, newest first, and `xcode-select`.
  ///   - pinnedXcode: The pinned Xcode, as the app or its
  ///     developer directory, or `nil` for Automatic.
  ///   - canonicalURL: Resolves symlinks before paths are compared.
  public static func resolve(
    _ snapshot: XcodeSnapshot,
    pinnedXcode: URL?,
    canonicalURL: (URL) -> URL
  ) -> Self {
    let installed = snapshot.installed
    if let pinnedXcode,
      let pinned = installed.installation(
        forDeveloperDirectory: SimCtl.developerDirectory(for: pinnedXcode),
        canonicalURL: canonicalURL
      )
    {
      return .ready(pinned, source: .pinned)
    }
    if let selected = snapshot.selectedDeveloperDirectory,
      let installation = installed.installation(
        forDeveloperDirectory: selected,
        canonicalURL: canonicalURL
      )
    {
      return .ready(installation, source: .xcodeSelect)
    }
    if let newest = installed.first {
      return .ready(newest, source: .newestInstalled)
    }
    return .xcodeRequired(selectedDeveloperDirectory: snapshot.selectedDeveloperDirectory)
  }
}
