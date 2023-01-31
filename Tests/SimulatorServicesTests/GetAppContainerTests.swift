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

    let tmpPath = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try "No such file or directory".write(to: tmpPath, atomically: true, encoding: .utf8)
    let standardError = try FileHandle(forReadingFrom: tmpPath)

    let error = UncaughtSignal(reason: Process.TerminationReason.uncaughtSignal, status: 2, standardError: standardError, output: nil).map(ProcessError.uncaughtSignal)

    guard let error else {
      XCTAssertNotNil(error)
      return
    }
    try appContainer.recover(error)
  }
}
