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
