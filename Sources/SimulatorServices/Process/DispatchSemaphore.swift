import Foundation

extension DispatchSemaphore: ProcessCompletionPromise {
  internal func waitForCompletion(
    for timeout: DispatchTime,
    with result: @autoclosure @escaping () -> TerminationResult
  ) -> ProcessResult {
    let processResult = wait(timeout: timeout)

    switch processResult {
    case .success:
      return .success(result())

    case .timedOut:
      return .timedOut(timeout)
    }
  }
}
