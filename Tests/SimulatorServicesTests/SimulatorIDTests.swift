import SimulatorServices
import XCTest

final class SimulatorIDTests: XCTestCase {
  func testDescription() {
    let id = UUID()
    XCTAssertEqual(SimulatorID.booted.description, "booted")
    XCTAssertEqual(SimulatorID.id(id).description, id.uuidString)
  }
}
