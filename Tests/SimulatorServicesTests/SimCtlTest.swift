@testable import SimulatorServices
import XCTest

extension Data {
  static func random() -> Data {
    let bytes: [UInt8] = (0 ... 255).map { _ in UInt8.random(in: 0 ... 255) }
    return Data(bytes)
  }
}

// --
class MockSimCtlProcess: _SimCtlProcess {
  internal init(result: Result<Data?, Error>, executableURL: URL? = nil, arguments: [String]? = nil) {
    self.result = result
    self.executableURL = executableURL
    self.arguments = arguments
  }

  let result: Result<Data?, Error>
  var executableURL: URL?

  var arguments: [String]?

  func run(timeout _: DispatchTime) async throws -> Data? {
    try result.get()
  }
}

// --
class MockSubcommand<OutputType>: Subcommand {
  internal init(arguments: [String] = [String](), callback: @escaping (Data?) throws -> OutputType) {
    self.callback = callback
    self.arguments = arguments
  }

  let callback: (Data?) throws -> OutputType
  func parse(_ data: Data?) throws -> OutputType {
    try callback(data)
  }

  var arguments = [String]()
}

// --
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
