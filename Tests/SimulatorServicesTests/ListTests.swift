import XCTest
import SimulatorServices

public class ListTests: XCTestCase {
  func testArguments () {
    
  }
  
  func testParse () {
    
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
