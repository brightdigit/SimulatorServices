//
//  File.swift
//  
//
//  Created by Leo Dion on 3/18/24.
//

import Foundation
import XCTest
import SimulatorServices

final class DeviceStateTests: XCTestCase {
  func testDecode () throws {
    let decoder = JSONDecoder()
    let value = try decoder.decode(DeviceState.self, from: "\"Booted\"".data(using: .utf8)!)
    XCTAssertEqual(value, .booted)
  }
}
