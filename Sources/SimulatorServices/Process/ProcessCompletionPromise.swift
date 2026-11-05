import Foundation

internal protocol ProcessCompletionPromise {
  /// Waits for the process to exit, then returns how it ended.
  func waitForCompletion(
    with result: @autoclosure @escaping () -> TerminationResult
  ) -> TerminationResult
}
