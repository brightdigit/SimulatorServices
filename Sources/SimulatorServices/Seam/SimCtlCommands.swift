//
//  SimCtlCommands.swift
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

/// The `simctl` calls an app that manages runtimes and simulators makes,
/// one item per call.
///
/// ``LiveSimCtlCommands`` runs them through ``SimCtl``; tests use a fake,
/// so no test runs a real `simctl` mutation.
public protocol SimCtlCommands: SimCtlDeletionCommands {
  /// `simctl runtime list -j` and `simctl list -j`.
  func snapshot() async throws(SimCtlError) -> SimctlSnapshot
  /// `simctl boot <udid>`.
  func boot(_ udid: UUID) async throws(SimCtlError)
  /// `simctl erase <udid>`.
  func erase(_ udid: UUID) async throws(SimCtlError)
  /// Runs every later call from this Xcode.
  ///
  /// - Parameter developerDirectory: The value for `DEVELOPER_DIR`, or
  ///   `nil` to use the one `xcode-select` points to.
  func useDeveloperDirectory(_ developerDirectory: URL?) async
}
