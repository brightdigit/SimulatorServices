@testable import SimulatorServices
import XCTest

public class ProcessTests: XCTestCase {
  func testRunProcess() async throws {
    guard #available(iOS 13.4, *) else {
      throw XCTSkip("Required API is not available for this test.")
    }
    
    let timeout: DispatchTime = .now() + 1.0
    let output: Data = .random()
    let error: Data = .random()
    let termination: TerminationResult = .init(reason: 1, status: 0)

    let process = MockAsyncableProcess(outputData: output, errorData: error, terminationResult: termination, willTimeout: false)
      let actualOutput = try await process.run(timeout: timeout)
      XCTAssertEqual(output, actualOutput)

  }
}
