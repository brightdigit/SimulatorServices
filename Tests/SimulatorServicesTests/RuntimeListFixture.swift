//
//  RuntimeListFixture.swift
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
import XCTest

@testable import SimulatorServices

/// `simctl runtime list -j` output recorded with Xcode 27.1 (27A9275)
/// on macOS 27.0.1, copied from Stewed's `docs/fixtures/simctl/`.
/// User paths are scrubbed to `/Users/USER/`; everything else is verbatim.
internal enum RuntimeListFixture: String, CaseIterable {
  /// 14 images, all `Ready` and deletable, cryptex directories with `sizeBytes` 128.
  case xcode271 = "xcode-27.1-27A9275"
  /// 30 images, including legacy and cryptex disk images.
  case xcode271RuntimeDelete = "xcode-27.1-27A9275-runtime-delete"

  internal func data() throws -> Data {
    let url = try XCTUnwrap(
      Bundle.module.url(
        forResource: "runtime-list",
        withExtension: "json",
        subdirectory: "Resources/simctl/\(rawValue)"
      )
    )
    return try Data(contentsOf: url)
  }

  internal func images() throws -> [RuntimeImage] {
    try RuntimeList().parse(data())
  }
}

extension Array where Element == RuntimeImage {
  internal func image(_ identifier: String) throws -> RuntimeImage {
    try XCTUnwrap(first { $0.identifier.uuidString == identifier })
  }
}
