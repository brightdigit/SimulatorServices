@testable import SimulatorServices
import XCTest

public class ProcessTests: XCTestCase {
  func testRunProcess() async throws {
    let timeout: DispatchTime = .now() + 1.0
    let output: Data = .random()
    let error: Data = .random()
    let termination: TerminationResult = .init(reason: 1, status: 0)

    let process = MockAsyncableProcess(outputData: output, errorData: error, terminationResult: termination, willTimeout: false)
    let actualOutput = try await process.run(timeout: timeout)
    XCTAssertEqual(output, actualOutput)
  }
}
