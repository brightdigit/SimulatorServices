import SimulatorServices
import XCTest

final class ContainerIDTests: XCTestCase {
  func testDescriptions() {
    let appGroup = UUID().uuidString

    XCTAssertEqual(ContainerID.data.description, "data")
    XCTAssertEqual(ContainerID.app.description, "app")
    XCTAssertEqual(ContainerID.groups.description, "groups")
    XCTAssertEqual(ContainerID.appGroup(appGroup).description, appGroup)
  }
}
