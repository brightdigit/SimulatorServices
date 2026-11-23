//
//  XcodeResolution.swift
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

/// The Xcode that runs `simctl`, or that none can.
///
/// This is what gates the app: ``xcodeRequired(selectedDeveloperDirectory:)``
/// shows "Xcode Is Required", and only that case does.
public enum XcodeResolution: Sendable, Hashable {
  /// Run `simctl` from this Xcode.
  case ready(XcodeInstallation, source: Source)
  /// No Xcode is installed. `selectedDeveloperDirectory` is what
  /// `xcode-select -p` printed, if anything, for the Command Line Tools note.
  case xcodeRequired(selectedDeveloperDirectory: URL?)

  /// Why an installation was chosen.
  public enum Source: Sendable, Hashable {
    /// The pinned Xcode (``XcodePreference/pinned(_:)``).
    case pinned
    /// Automatic: the full Xcode `xcode-select -p` points at.
    case xcodeSelect
    /// Automatic: `xcode-select` points at the Command Line Tools, at an
    /// Xcode that's gone, or couldn't be read, so the newest installed
    /// Xcode (betas included) is used.
    case newestInstalled
  }

  /// The Xcode in use, or `nil` when Xcode is required.
  public var installation: XcodeInstallation? {
    guard case .ready(let installation, _) = self else {
      return nil
    }
    return installation
  }

  /// The `DEVELOPER_DIR` for every `simctl` call, or
  /// `nil` when Xcode is required. It's set even when it's `xcode-select`'s
  /// choice, so every call uses the Xcode this resolution names.
  public var developerDirectory: URL? {
    installation?.developerDirectory
  }

  /// The Command Line Tools directory when Xcode is required and
  /// `xcode-select` points at the Command Line Tools, for the note under the
  /// explanation. `nil` otherwise.
  public var commandLineToolsDirectory: URL? {
    guard
      case .xcodeRequired(let selected?) = self,
      SimCtl.isCommandLineTools(selected)
    else {
      return nil
    }
    return selected
  }
}
