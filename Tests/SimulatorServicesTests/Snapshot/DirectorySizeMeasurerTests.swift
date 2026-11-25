//
//  DirectorySizeMeasurerTests.swift
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
  import Testing

  @testable import SimulatorServices

  @Suite(.enabled(if: Platform.isMacOS))
  internal struct DirectorySizeMeasurerTests {
    @Test
    internal func measuresAllocatedBytesUnderADirectory() async throws {
      let directory = FileManager.default.temporaryDirectory
        .appending(path: "DirectorySizeMeasurerTests-\(UUID().uuidString)")
      try FileManager.default.createDirectory(
        at: directory.appending(path: "Restore"),
        withIntermediateDirectories: true
      )
      defer { try? FileManager.default.removeItem(at: directory) }
      try Data(count: 100_000).write(to: directory.appending(path: "Restore/a"))
      try Data(count: 50_000).write(to: directory.appending(path: "b"))

      let measurer = DirectorySizeMeasurer()
      let size = try #require(await measurer.sizeBytes(at: directory.path))
      #expect(size >= 150_000)
      #expect(await measurer.sizeBytes(at: "/nonexistent/\(UUID())") == nil)
    }
  }
#endif
