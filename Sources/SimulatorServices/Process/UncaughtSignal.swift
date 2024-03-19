//
//  UncaughtSignal.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

/// Reason for the termination.
public typealias TerminationReason = Int

/// Details of a process error when it exists with an error code.
public struct UncaughtSignal: Equatable, CustomStringConvertible, Sendable {
  private static let exitReason = 1

  /// The reason code of the process termination.
  public let reason: TerminationReason

  /// The status code of the process.
  public let status: Int

  /// Data returned from standard error.
  public let data: Data?

  /// Data returned from standard output.
  public let output: Data?

  public var description: String {
    if let errorText = data.flatMap({ String(bytes: $0, encoding: .utf8) }) {
      return errorText
    } else {
      return "Termination Reason: \(reason) with status: \(status)"
    }
  }

  private init(
    uncheckedReason: TerminationReason,
    uncheckedStatus: Int,
    data: Data?,
    output: Data?
  ) {
    reason = uncheckedReason
    status = uncheckedStatus
    self.data = data
    self.output = output
  }

  init?(
    reason: TerminationReason,
    status: Int,
    data: Data?,
    output: Data?
  ) {
    if reason == UncaughtSignal.exitReason, status == 0 {
      return nil
    }
    self.init(
      uncheckedReason: reason,
      uncheckedStatus: status,
      data: data,
      output: output
    )
  }

  @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
  init?(
    reason: TerminationReason,
    status: Int,
    standardError: FileHandle,
    output: Data?
  ) {
    if reason == UncaughtSignal.exitReason, status == 0 {
      return nil
    }
    let reason = reason
    let status = status
    let data = try? standardError.readToEnd()

    self.init(
      uncheckedReason: reason,
      uncheckedStatus: Int(status),
      data: data,
      output: output
    )
  }

  @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
  init?(
    termination: TerminationResult,
    data: Data?,
    output: Data?
  ) {
    self.init(
      reason: termination.reason,
      status: termination.status,
      data: data,
      output: output
    )
  }
}
