//
//  Platform.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
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

/// Platform detection for SimulatorServices's unit tests.
///
/// Suites that drive `simctl`, `xcode-select`, `mdfind`, FSEvents or
/// swift-subprocess take `.enabled(if: Platform.isMacOS)`. Their files stay
/// inside `#if os(macOS)` as well, because the APIs they test only exist on
/// macOS.
///
/// This shadows the library's ``SimulatorServices/Platform`` in this target, so
/// tests of that type spell it `SimulatorServices.Platform`.
internal enum Platform {
  /// True on macOS, where the live `simctl`, Xcode-discovery, FSEvents and
  /// subprocess APIs exist. False on Linux and the iOS-family simulators.
  internal static let isMacOS: Bool = {
    #if os(macOS)
      return true
    #else
      return false
    #endif
  }()
}
