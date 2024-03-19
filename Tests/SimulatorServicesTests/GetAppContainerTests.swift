//
//  GetAppContainerTests.swift
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

@testable import SimulatorServices
import XCTest

public class GetAppContainerTests: XCTestCase {
  static let utf32String = "Hello, playground".data(using: .utf32)!

  func testArguments() {
    let appBundleIdentifier = UUID().uuidString
    let container = ContainerID.appGroup(UUID().uuidString)
    let simulator = SimulatorID.id(.init())
    let appContainer = GetAppContainer(appBundleIdentifier: appBundleIdentifier, container: container, simulator: simulator)
    let expectedArgs = [
      "get_app_container",
      simulator.description,
      appBundleIdentifier,
      container.description
    ]
    let actualArgs = appContainer.arguments
    XCTAssertEqual(actualArgs, expectedArgs)
  }

  func testInit() {
    let appBundleIdentifier = UUID().uuidString
    let container = ContainerID.appGroup(UUID().uuidString)
    let simulator = SimulatorID.id(.init())
    let appContainer = GetAppContainer(appBundleIdentifier: appBundleIdentifier, container: container, simulator: simulator)

    XCTAssertEqual(appContainer.appBundleIdentifier, appBundleIdentifier)
    XCTAssertEqual(appContainer.container, container)
    XCTAssertEqual(appContainer.simulator, simulator)
  }

  func testParseString() throws {
    let appBundleIdentifier = UUID().uuidString
    let container = ContainerID.appGroup(UUID().uuidString)
    let simulator = SimulatorID.id(.init())
    let appContainer = GetAppContainer(appBundleIdentifier: appBundleIdentifier, container: container, simulator: simulator)

    let expectedPath = UUID().uuidString
    let actualPath = try appContainer.parse(
      expectedPath.appending(String(repeating: Character(" "), count: .random(in: 3 ... 10))).data(using: .utf8)
    )
    XCTAssertEqual(expectedPath, actualPath)
  }

  func testParseEmptyEncoding() {
    let appBundleIdentifier = UUID().uuidString
    let container = ContainerID.appGroup(UUID().uuidString)
    let simulator = SimulatorID.id(.init())
    let appContainer = GetAppContainer(appBundleIdentifier: appBundleIdentifier, container: container, simulator: simulator)

    XCTAssertThrowsError(try appContainer.parse(nil)) { error in
      XCTAssertEqual(error as? GetAppContainer.Error, GetAppContainer.Error.missingData)
    }
  }

  func testParseInvalidEncoding() {
    let appBundleIdentifier = UUID().uuidString
    let container = ContainerID.appGroup(UUID().uuidString)
    let simulator = SimulatorID.id(.init())
    let appContainer = GetAppContainer(appBundleIdentifier: appBundleIdentifier, container: container, simulator: simulator)

    XCTAssertThrowsError(try appContainer.parse(Self.utf32String)) { error in
      XCTAssertEqual(error as? GetAppContainer.Error, GetAppContainer.Error.invalidData(Self.utf32String))
    }
  }

  func testRecover() throws {
    let appBundleIdentifier = UUID().uuidString
    let container = ContainerID.appGroup(UUID().uuidString)
    let simulator = SimulatorID.id(.init())
    let appContainer = GetAppContainer(appBundleIdentifier: appBundleIdentifier, container: container, simulator: simulator)

    let error: ProcessError?
    if #available(iOS 13.4, *) {
      let tmpPath = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
      try "No such file or directory".write(to: tmpPath, atomically: true, encoding: .utf8)
      let standardError = try FileHandle(forReadingFrom: tmpPath)
      error = UncaughtSignal(reason: 2, status: 2, standardError: standardError, output: nil).map(ProcessError.uncaughtSignal)
    } else {
      error = UncaughtSignal(reason: 2, status: 2, data: "No such file or directory".data(using: .utf8), output: nil).map(ProcessError.uncaughtSignal)
    }

    guard let error else {
      XCTAssertNotNil(error)
      return
    }
    try appContainer.recover(error)
  }
}
