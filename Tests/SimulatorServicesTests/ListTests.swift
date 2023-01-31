@testable import SimulatorServices
import XCTest

struct MockDecoder<U>: _ListDecoder {
  struct MismatchError: Error {
    let typeName: String
    init<U>(_ type: U.Type) {
      typeName = String(describing: type)
    }
  }

  typealias CallbackType<U> = (Data) throws -> U
  let callback: CallbackType<U>
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    guard let result = try callback(data) as? T else {
      throw MismatchError(type)
    }
    return result
  }
}

// --
extension String {
  static func random() -> String {
    UUID().uuidString
  }
}

// --
public class ListTests: XCTestCase {
  func testArguments() {
    let listCommand = List()
    XCTAssertEqual(listCommand.arguments, ["list", "-j"])
  }

  func testParse() throws {
    let actualList = SimulatorList(devicetypes: [.init(productFamily: .random(), bundlePath: .random(), maxRuntimeVersion: 1, maxRuntimeVersionString: .random(), identifier: .random(), modelIdentifier: .random(), minRuntimeVersionString: .random(), minRuntimeVersion: 2, name: .random())], runtimes: [], devices: [:], pairs: [:])
    let expectation = expectation(description: "decoder called")
    let expectedData: Data = .random()
    let decoder = MockDecoder { actualData in
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
