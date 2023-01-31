@testable import SimulatorServices
import XCTest

extension FileHandle {
  convenience init(temporaryFromData data: Data) throws {
    let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try data.write(to: url)
    try self.init(forReadingFrom: url)
  }
}

// --
class MockAsyncableProcess: _AsyncableProcess, ProcessCompletionPromise {
  internal init(outputData: Data, errorData: Data, terminationResult: TerminationResult, runError: Error? = nil, willTimeout: Bool) {
    self.outputData = outputData
    self.errorData = errorData
    self.terminationResult = terminationResult
    self.runError = runError
    self.willTimeout = willTimeout
  }

  func waitForCompletion(for timeout: DispatchTime, with result: @autoclosure @escaping () -> SimulatorServices.TerminationResult) -> SimulatorServices.ProcessResult {
    sleep(1)
    if willTimeout {
      return .timedOut(timeout)
    } else {
      return .success(result())
    }
  }

  func run() throws {
    guard let runError = runError else {
      return
    }

    throw runError
  }

  func promise() -> SimulatorServices.ProcessCompletionPromise {
    self
  }

  func fileHandles() -> SimulatorServices.ProcessOutputHandleSet {
    try! .init(
      output: .init(temporaryFromData: outputData),
      error: .init(temporaryFromData: errorData)
    )
  }

  func termintationResult() -> SimulatorServices.TerminationResult {
    terminationResult
  }

  let outputData: Data
  let errorData: Data
  let terminationResult: TerminationResult
  let runError: Error?
  let willTimeout: Bool
}

// --
public class ProcessTests: XCTestCase {
  func testRunProcess() async throws {
    let timeout: DispatchTime = .now() + 1.0
    let output: Data = .random()
    let error: Data = .random()
    let termination: TerminationResult = .init(reason: .exit, status: 0)

    let process = MockAsyncableProcess(outputData: output, errorData: error, terminationResult: termination, willTimeout: false)
    let actualOutput = try await process.run(timeout: timeout)
    XCTAssertEqual(output, actualOutput)
  }
}
