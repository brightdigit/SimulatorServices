//
//  SimctlSnapshotFixture.swift
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

/// Decodes a recorded `simctl` fixture in `Resources/simctl/` for
/// Swift Testing suites.
internal enum SimctlSnapshotFixture {
  /// A recorded file is missing from the test bundle.
  internal struct MissingResource: Error {
    internal let path: String
  }

  /// The recordings with both `runtime-list.json` and `list.json`.
  internal static let recordings = [
    "xcode-27.1-27A9275",
    "xcode-27.1-27A9275-runtime-delete",
  ]

  /// A recorded file's contents.
  internal static func data(_ recording: String, _ name: String) throws -> Data {
    let url = Bundle.module.url(
      forResource: name,
      withExtension: nil,
      subdirectory: "simctl/\(recording)"
    )
    guard let url else {
      throw MissingResource(path: "\(recording)/\(name)")
    }
    return try Data(contentsOf: url)
  }

  /// The images in a recording's `simctl runtime list -j` file.
  internal static func images(
    _ recording: String,
    runtimeList: String = "runtime-list.json"
  ) throws -> [RuntimeImage] {
    try RuntimeList().parse(data(recording, runtimeList))
  }

  /// A snapshot from a recording's JSON files.
  ///
  /// - Parameters:
  ///   - recording: The fixture directory.
  ///   - runtimeList: The `simctl runtime list -j` file.
  ///   - list: The `simctl list -j` file.
  /// - Returns: Both files decoded with SimulatorServices.
  /// - Throws: ``MissingResource``, or a decoding failure.
  internal static func snapshot(
    _ recording: String,
    runtimeList: String = "runtime-list.json",
    list: String = "list.json"
  ) throws -> SimctlSnapshot {
    SimctlSnapshot(
      images: try images(recording, runtimeList: runtimeList),
      list: try List().parse(data(recording, list))
    )
  }
}
