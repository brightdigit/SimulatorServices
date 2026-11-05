import Foundation

extension DispatchSemaphore: ProcessCompletionPromise {
  internal func waitForCompletion(
    with result: @autoclosure @escaping () -> TerminationResult
  ) -> TerminationResult {
    wait()
    return result()
  }
}
