@testable import SimulatorServices
import XCTest

public class SubcommandTests: XCTestCase {
  func testRecover() {
    let expectedError = ProcessError.uncaughtSignal(
      .init(reason: Process.TerminationReason.uncaughtSignal, status: 2, standardError: FileHandle.nullDevice, output: nil)!
    )
    let subcommand = MockSubcommand { _ in

      throw expectedError
    }

    XCTAssertThrowsError(try subcommand.recover(expectedError)) { actualError in
      XCTAssertEqual(actualError as? ProcessError, expectedError)
    }

    XCTAssertEqual(expectedError.localizedDescription, "Termination Reason: \(Process.TerminationReason.uncaughtSignal) with status: 2")
    XCTAssertEqual(expectedError.errorDescription, "Termination Reason: \(Process.TerminationReason.uncaughtSignal) with status: 2")
  }
}
