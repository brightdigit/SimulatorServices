import Foundation

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
internal protocol _AsyncableProcess: AnyObject {
  func run() throws
  func promise() -> ProcessCompletionPromise
  func fileHandles() -> ProcessOutputHandleSet
  func termintationResult() -> TerminationResult
}

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
extension _AsyncableProcess {
  internal func data(
    basedOn result: ProcessResult,
    from fileHandles: ProcessOutputHandleSet
  ) throws -> Data? {
    switch result {
    case let .success(termination):
      if let uncaught = UncaughtSignal(
        termination: termination,
        data: fileHandles.errorData,
        output: try? fileHandles.outputResult.get()
      ) {
        throw ProcessError.uncaughtSignal(uncaught)
      } else {
        return try fileHandles.outputResult.get()
      }

    case let .timedOut(timeout):
      throw ProcessError.timeout(timeout)
    }
  }

  /// Run the process asyncronously and returns the output as data.
  /// - Parameter timeout: Timeout for the process to be done.
  /// - Returns: Data if there anything output from the process.
  internal func run(timeout: DispatchTime) async throws -> Data? {
    var handles = fileHandles()
    let semaphore = promise()
    try run()
    handles.readToEnd()
    return try await withCheckedThrowingContinuation { continuation in
      let semaphoreResult = semaphore.waitForCompletion(
        for: timeout,
        with: self.termintationResult()
      )
      let result = Result {
        try self.data(basedOn: semaphoreResult, from: handles)
      }
      continuation.resume(with: result)
    }
  }
}
