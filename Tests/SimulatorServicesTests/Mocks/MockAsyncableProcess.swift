import Foundation
@testable import SimulatorServices

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
