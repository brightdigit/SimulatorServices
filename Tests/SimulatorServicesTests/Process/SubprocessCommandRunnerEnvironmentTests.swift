//
//  SubprocessCommandRunnerEnvironmentTests.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
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

  /// What the live runner passes on to a child's environment.
  @Suite("Subprocess command runner environment", .enabled(if: Platform.isMacOS))
  internal struct SubprocessCommandRunnerEnvironmentTests {
    private let runner = SubprocessCommandRunner()

    @Test("Variables xcodebuild injects are dropped; the rest are kept")
    internal func removesInjectedVariables() {
      let filtered = SubprocessCommandRunner.removingInjectedVariables([
        "DYLD_INSERT_LIBRARIES": "/tmp/libXCTestBundleInject.dylib",
        "__XPC_DYLD_LIBRARY_PATH": "/tmp",
        "XCTestConfigurationFilePath": "/tmp/config",
        "XCInjectBundleInto": "/tmp/host",
        "DEVELOPER_DIR": "/Applications/Xcode.app/Contents/Developer",
        "PATH": "/usr/bin:/bin",
      ])
      #expect(
        filtered == [
          "DEVELOPER_DIR": "/Applications/Xcode.app/Contents/Developer",
          "PATH": "/usr/bin:/bin",
        ]
      )
    }

    @Test("An explicit environment reaches the child without injected variables")
    internal func explicitEnvironmentIsFiltered() async throws {
      let output = try await runner.run(
        Command(
          executableURL: URL(fileURLWithPath: "/usr/bin/env"),
          arguments: [],
          environment: ["KEEP_ME": "1", "DYLD_PRINT_LIBRARIES": "1"]
        )
      )
      let printed = String(decoding: output.standardOutput, as: UTF8.self)
      #expect(printed.contains("KEEP_ME=1"))
      #expect(!printed.contains("DYLD_"))
    }
  }
#endif
