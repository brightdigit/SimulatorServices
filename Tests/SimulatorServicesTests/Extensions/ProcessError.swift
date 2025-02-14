//
//  ProcessError.swift
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

@testable import SimulatorServices

@available(macOS 10.15, iOS 13.4, tvOS 13.4, watchOS 6.4, *)
extension ProcessError {
  internal init?(withMessage message: String) throws {
    let tmpPath = FileManager.default.temporaryDirectory.appendingPathComponent(
      UUID().uuidString
    )
    try message.write(
      to: tmpPath,
      atomically: true,
      encoding: .utf8
    )
    let standardError = try FileHandle(forReadingFrom: tmpPath)
    let signal = UncaughtSignal(
      reason: 2,
      status: 2,
      standardError: standardError,
      output: nil
    )

    guard let signal else {
      return nil
    }

    self = .uncaughtSignal(signal)
  }
}
