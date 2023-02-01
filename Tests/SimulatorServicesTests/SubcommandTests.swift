@testable import SimulatorServices
import XCTest

public class SubcommandTests: XCTestCase {
  func testRecover() {
    let expectedError : ProcessError
    if #available(iOS 13.4, *) {
      
      expectedError = ProcessError.uncaughtSignal(
        .init(reason: 2, status: 2, standardError: FileHandle.nullDevice, output: nil)!
      )
    }
      else {
        
          expectedError = ProcessError.uncaughtSignal(
            
            .init(reason: 2, status: 2, data: nil, output: nil)!
          )
      }
      
    let subcommand = MockSubcommand { _ in

      throw expectedError
    }

    XCTAssertThrowsError(try subcommand.recover(expectedError)) { actualError in
      XCTAssertEqual(actualError as? ProcessError, expectedError)
    }

    XCTAssertEqual(expectedError.localizedDescription, "Termination Reason: \(2) with status: 2")
    XCTAssertEqual(expectedError.errorDescription, "Termination Reason: \(2) with status: 2")
  }
}
