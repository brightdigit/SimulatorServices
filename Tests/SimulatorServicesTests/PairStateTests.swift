//
//  PairState.swift
//  
//
//  Created by Leo Dion on 3/19/24.
//

import XCTest
@testable import SimulatorServices

final class PairStateTests: XCTestCase {

 

    func testExample() throws {
      let pairStates : [PairState] = Array.random(withCountIn: (20...50)) {
        Bool.random() ? PairState.random() : .unknown(UUID().uuidString)
      }
      
      for pairState in pairStates {
        if case let .unknown(string) = pairState {
          XCTAssertEqual(string, pairState.unknownValue())
        } else {
          XCTAssertNil(pairState.unknownValue())
        }
      }
    }

}
