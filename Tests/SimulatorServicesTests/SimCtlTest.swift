import XCTest
@testable import SimulatorServices

extension Data {
  static func random () -> Data {
    let bytes : [UInt8] = (0...255).map{_ in UInt8.random(in: 0...255)}
    return Data(bytes)
  }
}

class MockSimCtlProcess : _SimCtlProcess {
  internal init(result: Result<Data?, Error>, executableURL: URL? = nil, arguments: [String]? = nil) {
    self.result = result
    self.executableURL = executableURL
    self.arguments = arguments
  }
  
  let result : Result<Data?, Error>
  var executableURL: URL?
  
  var arguments: [String]?
  
  func run(timeout: DispatchTime) async throws -> Data? {
    return try result.get()
  }
  
  
}

class MockSubcommand<OutputType> : Subcommand {
  internal init(arguments: [String] = [String](), callback: @escaping (Data?) throws -> OutputType) {
    self.callback = callback
    self.arguments = arguments
  }
  
  let callback : (Data?) throws -> OutputType
  func parse(_ data: Data?) throws -> OutputType {
    try self.callback(data)
  }
  
  
  var arguments = [String]()
  
  
}

public class SimCtlTests: XCTestCase {
  func testInit() {
    let expectedXcRunURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let simctl = SimCtl(xcRunURL: expectedXcRunURL)
    XCTAssertEqual(expectedXcRunURL, simctl.xcRunURL)
  }
  
  func testRunSubcommandParse() async throws {
    let expectedUUID = UUID()
    let expectedData = Data.random()
    let expectedXcRunURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let simctl = SimCtl(xcRunURL: expectedXcRunURL, processFactory: MockSimCtlProcess(result: .success(expectedData)))
    let commandExpectation = expectation(description: "subcommand run")
    let command = MockSubcommand { actualData in
      XCTAssertEqual(actualData, expectedData)
      commandExpectation.fulfill()
      return expectedUUID
    }
    let actualUUID = try await simctl.run(command)
    await waitForExpectations(timeout: 1.0) { error in
      XCTAssertNil(error)
      XCTAssertEqual(actualUUID, expectedUUID)
    }
  }
}
//#if !os(iOS) && !os(watchOS) && !os(tvOS)
//  import Foundation
//
//  /// Interface for running `simctl`.
//  @available(macOS 10.15.4, iOS 13.0.0, *)
//  public struct SimCtl {
//    /// URL Path to `xcrun`
//    public let xcRunURL: URL
//
//    /// Create an interface to `simctl`
//    /// - Parameter xcRunURL: URL path to `xcrun`.
//    public init(xcRunURL: URL = URL(fileURLWithPath: "/usr/bin/xcrun")) {
//      self.xcRunURL = xcRunURL
//    }
//
//    /// Run a subcommand under `simctl`.
//    /// - Parameter subcommand: subcommand to run.
//    /// - Returns: Result of the subcommand.
//    public func run<SubcommandType: Subcommand>(
//      _ subcommand: SubcommandType
//    ) async throws -> SubcommandType.OutputType {
//      let process = Process()
//      process.executableURL = xcRunURL
//      process.arguments = ["simctl"] + subcommand.arguments
//      let data: Data?
//      do {
//        data = try await process.run(timeout: .distantFuture)
//      } catch let error as Process.UncaughtSignalError {
//        try subcommand.recover(error)
//        data = nil
//      }
//      return try subcommand.parse(data)
//    }
//  }
//#endif
