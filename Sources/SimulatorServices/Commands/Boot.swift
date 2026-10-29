//
//  Boot.swift
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

/// Boots a simulator device with `simctl boot <udid>`.
///
/// If `simctl` fails, ``SimCtl/run(_:)`` throws a ``SimCtlError`` with its
/// standard error verbatim. An unknown UDID fails with
/// ``SimCtlError/Reason/invalidDevice``, and a booted device with
/// ``SimCtlError/Reason/invalidState``.
public struct Boot: Subcommand {
  /// Nothing. `simctl` prints nothing when the device boots.
  public typealias OutputType = Void

  /// The UDID of the device to boot (``Device/udid``).
  public let udid: UUID

  /// Arguments to pass to `simctl`
  public var arguments: [String] { ["boot", udid.uuidString] }

  /// Boot a device.
  /// - Parameter udid: The UDID of the device to boot.
  public init(_ udid: UUID) { self.udid = udid }

  /// Does nothing. `simctl` prints nothing when the device boots.
  /// - Parameter _: Standard output from the `simctl` call.
  public func parse(_: Data?) {}

  /// Throws a ``SimCtlError`` with `simctl`'s standard error.
  /// - Parameter error: The error from running `simctl`.
  /// - Throws: ``SimCtlError``, or `error` for a timeout.
  public func recover(_ error: ProcessError) throws {
    throw SimCtlError.from(error, arguments: arguments)
  }
}
