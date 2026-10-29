//
//  DeviceDelete.swift
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

/// Deletes simulator devices with `simctl delete <udid…>`.
///
/// If `simctl` fails, ``SimCtl/run(_:)`` throws a ``SimCtlError`` with its
/// standard error verbatim. An unknown UDID fails with
/// ``SimCtlError/Reason/invalidDevice``.
/// - SeeAlso: ``DeleteUnavailable``
public struct DeviceDelete: Subcommand {
  /// Nothing. `simctl` prints nothing when the delete succeeds.
  public typealias OutputType = Void

  /// The UDIDs of the devices to delete (``Device/udid``).
  public let udids: [UUID]

  /// Arguments to pass to `simctl`
  public var arguments: [String] {
    ["delete"] + udids.map(\.uuidString)
  }

  /// Delete one or more devices.
  /// - Parameters:
  ///   - udid: The UDID of a device to delete.
  ///   - udids: The UDIDs of more devices to delete.
  public init(_ udid: UUID, _ udids: UUID...) {
    self.udids = [udid] + udids
  }

  /// Delete devices.
  /// - Parameter udids: The UDIDs of the devices to delete.
  ///   Returns `nil` if it's empty, since `simctl` needs at least one.
  public init?(_ udids: [UUID]) {
    guard !udids.isEmpty else {
      return nil
    }
    self.udids = udids
  }

  /// Does nothing. `simctl` prints nothing when the delete succeeds.
  /// - Parameter _: Standard output from the `simctl` call.
  public func parse(_: Data?) {}

  /// Throws a ``SimCtlError`` with `simctl`'s standard error.
  /// - Parameter error: The error from running `simctl`.
  /// - Throws: ``SimCtlError``, or `error` for a timeout.
  public func recover(_ error: ProcessError) throws {
    throw SimCtlError.from(error, arguments: arguments)
  }
}
