//
//  RuntimeDelete.swift
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

/// Deletes simulator runtime images with `simctl runtime delete <identifier…>`.
///
/// A disk-image runtime with booted simulators is deleted anyway:
/// `simctl` shuts them down and unmounts the image first.
/// The delete is synchronous. When it returns, the image is already gone
/// from ``RuntimeList``.
///
/// If `simctl` fails, ``SimCtl/run(_:)`` throws a ``SimCtlError`` with its
/// standard error verbatim. An identifier that doesn't match any image fails
/// with ``SimCtlError/Reason/noMatchingRuntime``.
public struct RuntimeDelete: Subcommand {
  /// Nothing. `simctl` prints nothing when the delete succeeds.
  public typealias OutputType = Void

  /// The identifiers of the images to delete (``RuntimeImage/identifier``).
  public let identifiers: [UUID]

  /// Arguments to pass to `simctl`
  public var arguments: [String] {
    ["runtime", "delete"] + identifiers.map(\.uuidString)
  }

  /// Delete one or more runtime images.
  /// - Parameters:
  ///   - identifier: The identifier of an image to delete.
  ///   - identifiers: The identifiers of more images to delete.
  public init(_ identifier: UUID, _ identifiers: UUID...) {
    self.identifiers = [identifier] + identifiers
  }

  /// Delete runtime images.
  /// - Parameter identifiers: The identifiers of the images to delete.
  ///   Returns `nil` if it's empty, since `simctl` needs at least one.
  public init?(_ identifiers: [UUID]) {
    guard !identifiers.isEmpty else {
      return nil
    }
    self.identifiers = identifiers
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
