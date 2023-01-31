import Foundation

internal struct TerminationResult {
  internal typealias Reason = Process.TerminationReason

  internal let reason: Reason
  internal let status: Int
}

internal protocol _SimCtlProcess: AnyObject {
  var executableURL: URL? { get set }
  var arguments: [String]? { get set }
  func run(timeout: DispatchTime) async throws -> Data?
}

internal enum ProcessResult {
  case success(TerminationResult)
  case timedOut(DispatchTime)
}

extension DispatchSemaphore: ProcessCompletionPromise {
  internal func waitForCompletion(for timeout: DispatchTime, with result: @autoclosure @escaping () -> TerminationResult) -> ProcessResult {
    let processResult = wait(timeout: timeout)

    switch processResult {
    case .success:
      return .success(result())

    case .timedOut:
      return .timedOut(timeout)
    }
  }
}

internal protocol ProcessCompletionPromise {
  func waitForCompletion(for timeout: DispatchTime, with result: @autoclosure @escaping () -> TerminationResult) -> ProcessResult
}

internal struct ProcessOutputHandleSet {
  internal let output: FileHandle
  internal let error: FileHandle
}

@available(macOS 10.15.4, *)
internal protocol _AsyncableProcess: AnyObject {
  func run() throws
  func promise() -> ProcessCompletionPromise
  func fileHandles() -> ProcessOutputHandleSet
  func termintationResult() -> TerminationResult
}

@available(macOS 10.15.4, *)
extension _AsyncableProcess {
  internal func data(basedOn result: ProcessResult, from fileHandles: ProcessOutputHandleSet) throws -> Data? {
    switch result {
    case let .success(termination):
      let outputResult = Result { try fileHandles.output.readToEnd() }
      if let uncaught = UncaughtSignal(
        termination: termination,
        standardError: fileHandles.error,
        output: try? outputResult.get()
      ) {
        throw ProcessError.uncaughtSignal(uncaught)
      } else {
        return try outputResult.get()
      }

    case let .timedOut(timeout):
      throw ProcessError.timeout(timeout)
    }
  }

  /// Run the process asyncronously and returns the output as data.
  /// - Parameter timeout: Timeout for the process to be done.
  /// - Returns: Data if there anything output from the process.
  internal func run(timeout: DispatchTime) async throws -> Data? {
    let handles = fileHandles()
    let semaphore = promise()
    try run()
    return try await withCheckedThrowingContinuation { continuation in
      let semaphoreResult = semaphore.waitForCompletion(for: timeout, with: self.termintationResult())
      let result = Result {
        try self.data(basedOn: semaphoreResult, from: handles)
      }
      continuation.resume(with: result)
    }
  }
}
