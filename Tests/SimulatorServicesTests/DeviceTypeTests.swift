import Foundation
import SimulatorServices
import XCTest

final class DeviceStateTests: XCTestCase {
  func testDecode() throws {
    let decoder = JSONDecoder()
    let value = try decoder.decode(DeviceState.self, from: "\"Booted\"".data(using: .utf8)!)
    XCTAssertEqual(value, .booted)
  }
}
