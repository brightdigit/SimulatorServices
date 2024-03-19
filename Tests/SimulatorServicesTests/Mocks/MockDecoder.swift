@testable import SimulatorServices
import XCTest

struct MockDecoder<U: Sendable>: _ListDecoder {
  struct MismatchError: Error {
    let typeName: String
    init(_ type: (some Any).Type) {
      typeName = String(describing: type)
    }
  }

  typealias CallbackType<V> = @Sendable (Data) throws -> V
  let callback: CallbackType<U>
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    guard let result = try callback(data) as? T else {
      throw MismatchError(type)
    }
    return result
  }
}
