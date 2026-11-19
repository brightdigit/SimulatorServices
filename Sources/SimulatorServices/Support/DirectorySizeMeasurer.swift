//
//  DirectorySizeMeasurer.swift
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

#if os(macOS)
  import Foundation

  /// Sums the allocated size of every file under a directory, like `du`.
  ///
  /// Use it for runtime images whose `sizeBytes` isn't their size
  /// (``SimctlSnapshot/imagesNeedingMeasurement``): cryptex image
  /// directories hold a few large files, so this is quick. It runs off the
  /// caller's actor.
  public struct DirectorySizeMeasurer: Sendable {
    private static let keys: Set<URLResourceKey> = [
      .isRegularFileKey, .totalFileAllocatedSizeKey,
    ]

    /// Creates a measurer.
    public init() {}

    private static func measure(_ path: String) -> Int64? {
      guard
        let enumerator = FileManager.default.enumerator(
          at: URL(filePath: path, directoryHint: .isDirectory),
          includingPropertiesForKeys: Array(keys)
        )
      else {
        return nil
      }
      var total: Int64 = 0
      for case let url as URL in enumerator {
        guard
          let values = try? url.resourceValues(forKeys: keys),
          values.isRegularFile == true
        else {
          continue
        }
        total += Int64(values.totalFileAllocatedSize ?? 0)
      }
      return total > 0 ? total : nil
    }

    /// The allocated size of everything under a directory.
    /// - Parameter path: The directory, such as a runtime image's `path`.
    /// - Returns: The total in bytes, or `nil` if the directory can't be
    ///   read or holds nothing.
    @concurrent
    public func sizeBytes(at path: String) async -> Int64? {
      Self.measure(path)
    }
  }
#endif
