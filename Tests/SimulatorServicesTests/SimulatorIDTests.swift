//
//  SimulatorIDTests.swift
//  
//
//  Created by Leo Dion on 1/31/23.
//

import XCTest
import SimulatorServices

final class SimulatorIDTests: XCTestCase {

  func testDescription () {
    let id = UUID()
    XCTAssertEqual(SimulatorID.booted.description, "booted")
    XCTAssertEqual(SimulatorID.id(id).description, id.uuidString)
  }

}
