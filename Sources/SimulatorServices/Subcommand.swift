//
//  Subcommand.swift
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

/// Subcommand to be run from `simctl`
public protocol Subcommand: Sendable {
  /// The output type of the subcommand
  associatedtype OutputType

  /// Arguments to be passed to `simctl`
  var arguments: [String] { get }

  /// Optional function for recovering from a process error.
  /// - Parameter error: ``UncaughtSignal`` received.
  /// - SeeAlso: ``GetAppContainer/recover(_:)``
  /// - Throws: Tries to parse the error otherwise returns it again.
  func recover(_ error: ProcessError) throws

  /// Convert the data into the desiginated ``OutputType``.
  /// - Parameter data: Data received from the `simctl`
  /// - Throws: An error if the parsing failed.
  /// - Returns: The parsed ``OutputType``.
  func parse(_ data: Data?) throws -> OutputType
}

extension Subcommand {
  /// Optional function for recovering from a process error.
  /// - Parameter error: ``UncaughtSignal`` received.
  /// - Throws: Tries to parse the error otherwise returns it again.
  /// By default it'll just throw the error back.
  /// - SeeAlso: ``GetAppContainer/recover(_:)``
  public func recover(_ error: ProcessError) throws { throw error }
}
