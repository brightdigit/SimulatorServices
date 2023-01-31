@testable import SimulatorServices
import XCTest

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
