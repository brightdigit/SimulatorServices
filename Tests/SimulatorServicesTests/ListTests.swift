@testable import SimulatorServices
import XCTest

public class ListTests: XCTestCase {
  func testArguments() {
    let listCommand = List()
    XCTAssertEqual(listCommand.arguments, ["list", "-j"])
  }

  func testParse() throws {
    let actualList = SimulatorList(devicetypes: [.init(productFamily: .random(), bundlePath: .random(), maxRuntimeVersion: 1, maxRuntimeVersionString: .random(), identifier: .random(), modelIdentifier: .random(), minRuntimeVersionString: .random(), minRuntimeVersion: 2, name: .random())], runtimes: [], devices: [:], pairs: [:])
    let expectation = expectation(description: "decoder called")
    let expectedData: Data = .random()
    let decoder = MockDecoder { actualData -> SimulatorList in
      XCTAssertEqual(expectedData, actualData)
      defer {
        expectation.fulfill()
      }
      return actualList
    }
    let listCommand = List(decoder: decoder)
    let expectedList = try listCommand.parse(expectedData)
    waitForExpectations(timeout: 1.0) { error in
      XCTAssertNil(error)
      XCTAssertEqual(expectedList, actualList)
    }
  }
}
