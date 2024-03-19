//
//  RuntimeIDTests.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

@testable import SimulatorServices
import Foundation
import XCTest

extension Array {
  static func random(withCountIn countRange: ClosedRange<Int>, using closure: @escaping @Sendable () -> Element) -> Self {
    
    let count : Int = .random(in: countRange)
    return (0..<count).map{_ in closure()}
  }
}

final class RuntimeIDTests: XCTestCase {
  
  func random (_ : Int) -> RuntimeID {
    return .init(platform: .random(), version: .random())
  }

  func testInitDescription() throws {
    
    let count : Int = .random(in: (20...50))
    let runtimes = (0..<count).map(self.random)
    
    for runtime in runtimes {
      let suffix = runtime.suffix
      let actualWSuffix = try RuntimeID(suffix: suffix)
      XCTAssertEqual(runtime, actualWSuffix)
      
        let description = runtime.description
        let actualWDesc = RuntimeID(description)
        XCTAssertEqual(runtime, actualWDesc)
    }
  }

}
