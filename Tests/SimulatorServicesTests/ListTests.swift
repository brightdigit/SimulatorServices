import XCTest
@testable import SimulatorServices

struct MockDecoder<U>: _ListDecoder {
  struct MismatchError<U> : Error {
    init<U>(_ type: U.Type) {}
  }
  typealias CallbackType<U> = (Data) throws -> U
  let callback : CallbackType<U>
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
    guard let result = try self.callback(data) as? T else {
      throw MismatchError<T>(type)
    }
    return result
  }
  
  
}

extension String {
  static func random () -> String {
    UUID().uuidString
  }
}

public class ListTests: XCTestCase {
  func testArguments () {
    let listCommand = List()
    XCTAssertEqual(listCommand.arguments, ["list", "-j"])
  }
  
  func testParse () throws {
    let actualList = SimulatorList(devicetypes: [.init(productFamily: .random(), bundlePath: .random(), maxRuntimeVersion: 1, maxRuntimeVersionString: .random(), identifier: .random(), modelIdentifier: .random(), minRuntimeVersionString: .random(), minRuntimeVersion: 2, name: .random())], runtimes: [], devices: [:], pairs: [:])
    let expectation = expectation(description: "decoder called")
    let expectedData : Data = .random()
    let decoder = MockDecoder { actualData in
      XCTAssertEqual(expectedData, actualData)
      defer{
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

//#if !os(iOS) && !os(watchOS) && !os(tvOS)
//  import Foundation
//
//  public struct List: Subcommand {
//    public typealias OutputType = SimulatorList
//
//    public enum Error: Swift.Error {
//      case missingData
//      case deocdingError(DecodingError)
//    }
//
//    private static let decoder: JSONDecoder = {
//      let decoder = JSONDecoder()
//      decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
//      return decoder
//    }()
//
//    public var arguments: [String] {
//      ["list", "-j"]
//    }
//
//    public init() {}
//
//    public func parse(_ data: Data?) throws -> SimulatorList {
//      guard let data = data else {
//        throw Error.missingData
//      }
//
//      do {
//        return try Self.decoder.decode(SimulatorList.self, from: data)
//      } catch let error as DecodingError {
//        throw Error.deocdingError(error)
//      } catch {
//        throw error
//      }
//    }
//  }
//
//#endif
