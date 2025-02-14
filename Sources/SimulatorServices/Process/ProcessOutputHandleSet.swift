//
//  ProcessOutputHandleSet.swift
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

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
internal struct ProcessOutputHandleSet {
  private let output: FileHandle
  private let error: FileHandle

  // swift-format-ignore: NoLeadingUnderscores
  private var _outputResult: Result<Data?, any Error>?

  // swift-format-ignore: NoLeadingUnderscores
  private var _errorResult: Result<Data?, any Error>?

  internal var outputResult: Result<Data?, any Error> {
    guard let outputResult = _outputResult else {
      preconditionFailure("Must call readToEnd first.")
    }
    return outputResult
  }

  internal var errorData: Data? {
    guard let errorResult = _errorResult else {
      preconditionFailure("Must call readToEnd first.")
    }

    return try? errorResult.get()
  }

  internal init(output: FileHandle, error: FileHandle) {
    self.output = output
    self.error = error
    _outputResult = nil
    _errorResult = nil
  }

  internal mutating func readToEnd() {
    _outputResult = Result { try output.readToEnd() }
    _errorResult = Result { try error.readToEnd() }
  }
}
