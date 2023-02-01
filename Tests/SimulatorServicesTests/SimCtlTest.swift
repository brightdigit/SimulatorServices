@testable import SimulatorServices
import XCTest

public class SimCtlTests: XCTestCase {  
  private struct SubcommandTest {
    fileprivate init(from testCase: XCTestCase) {
      let expectedUUID = UUID()
      let expectedData = Data.random()

      let commandExpectation = testCase.expectation(description: "subcommand")
      let command = MockSubcommand { actualData -> UUID in
        XCTAssertEqual(actualData, expectedData)
        commandExpectation.fulfill()
        return expectedUUID
      }

      let expectedXcRunURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
      let simctl = SimCtl(xcRunURL: expectedXcRunURL, processFactory: MockSimCtlProcess(result: .success(expectedData)))

      self.init(command: command, expectedUUID: expectedUUID, expectedData: expectedData, simctl: simctl)
    }

    private init(command: MockSubcommand<UUID>, expectedUUID: UUID, expectedData: Data, simctl: SimCtl) {
      self.command = command
      self.expectedUUID = expectedUUID
      self.expectedData = expectedData
      self.simctl = simctl
    }

    fileprivate let command: MockSubcommand<UUID>
    fileprivate let expectedUUID: UUID
    fileprivate let expectedData: Data
    fileprivate let simctl: SimCtl
  }
  
  func testInit() {
    let expectedXcRunURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let simctl = SimCtl(xcRunURL: expectedXcRunURL, processFactory: MockSimCtlProcess(result: .success(nil)))
    XCTAssertEqual(expectedXcRunURL, simctl.xcRunURL)
  }

  #if os(Linux)
    func testRunSubcommandParse() throws {
      let details = SubcommandTest(from: self)
      let runExpectation = expectation(description: "run")
      Task {
        let actualUUID = try await details.simctl.run(details.command)
        XCTAssertEqual(actualUUID, details.expectedUUID)
        runExpectation.fulfill()
      }
      waitForExpectations(timeout: 1.0) { error in
        XCTAssertNil(error)
      }
    }
  #else
    func testRunSubcommandParse() async throws {
      let details = SubcommandTest(from: self)
      let actualUUID = try await details.simctl.run(details.command)
      await waitForExpectations(timeout: 1.0) { error in
        XCTAssertNil(error)
        XCTAssertEqual(actualUUID, details.expectedUUID)
      }
    }
  #endif
}
