import Foundation

internal protocol ProcessCompletionPromise {
  func waitForCompletion(for timeout: DispatchTime, with result: @autoclosure @escaping () -> TerminationResult) -> ProcessResult
}
