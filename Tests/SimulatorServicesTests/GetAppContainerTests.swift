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

// #if !os(iOS) && !os(watchOS) && !os(tvOS)
//
//  import Foundation
//
//  @available(macOS 10.15.4, *)
//  public struct GetAppContainer: Subcommand {
//    public typealias OutputType = Path
//
//    public enum Error: Swift.Error {
//      case missingData
//      case invalidData(Data)
//      case invalidPath(String)
//    }
//
//    public let appBundleIdentifier: String
//    public let container: ContainerID
//    public let simulator: SimulatorID
//
//    public var arguments: [String] {
//      [
//        "get_app_container",
//        simulator.description,
//        appBundleIdentifier,
//        container.description
//      ]
//    }
//
//    public init(
//      appBundleIdentifier: String,
//      container: ContainerID,
//      simulator: SimulatorID
//    ) {
//      self.appBundleIdentifier = appBundleIdentifier
//      self.container = container
//      self.simulator = simulator
//    }
//
//    public func parse(_ data: Data?) throws -> Path {
//      guard let data = data else {
//        throw Error.missingData
//      }
//
//      guard let text = String(bytes: data, encoding: .utf8) else {
//        throw Error.invalidData(data)
//      }
//
//      return text.trimmingCharacters(in: .whitespacesAndNewlines)
//    }
//
//    public func recover(_ error: Process.UncaughtSignalError) throws {
//      guard let text = error.data.flatMap({ String(data: $0, encoding: .utf8) }) else {
//        throw error
//      }
//
//      let lines = text.components(separatedBy: .newlines)
//        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//        .filter { !$0.isEmpty }
//
//      guard let errorString = lines.last?
//        .trimmingCharacters(in: .whitespacesAndNewlines) else {
//        throw error
//      }
//
//      guard errorString == "No such file or directory" else {
//        throw error
//      }
//    }
//  }
//
// #endif
