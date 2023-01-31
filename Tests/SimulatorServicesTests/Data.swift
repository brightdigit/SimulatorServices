@testable import SimulatorServices
import XCTest

extension Data {
  static func random() -> Data {
    let bytes: [UInt8] = (0 ... 255).map { _ in UInt8.random(in: 0 ... 255) }
    return Data(bytes)
  }
}
