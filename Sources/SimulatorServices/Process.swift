#if !os(iOS) && !os(watchOS) && !os(tvOS)
  import Foundation


@available(macOS 10.15.4, *)
public enum ProcessError : Error, LocalizedError, Equatable
{
  @available(macOS 10.15.4, *)
  public struct UncaughtSignal: Error, LocalizedError, Equatable {
    private init(
      reason: Process.TerminationReason,
      status: Int,
      data: Data?,
      output: Data?
    ) {
      self.reason = reason
      self.status = status
      self.data = data
      self.output = output
    }

    internal init?(
      reason: Process.TerminationReason,
      status: Int,
      standardError: FileHandle,
      output: Data?
    ) {
      if reason == .exit, status == 0 {
        return nil
      }
      let reason = reason
      let status = status
      let data = try? standardError.readToEnd()

      self.init(reason: reason, status: Int(status), data: data, output: output)
    }
    
    internal init?(
      termination: TerminationResult,
      standardError: FileHandle,
      output: Data?
    ) {

      self.init(reason: termination.reason, status: termination.status, standardError: standardError, output: output)
    }

    public let reason: Process.TerminationReason
    public let status: Int
    public let data: Data?
    public let output: Data?

    public var errorDescription: String? {
      if let errorText = data.flatMap({ String(bytes: $0, encoding: .utf8) }) {
        return errorText
      } else {
        return "Termination Reason: \(reason) with status: \(status)"
      }
    }
  }
  
  case timeout(DispatchTime)
  case uncaughtSignal(UncaughtSignal)
}


  @available(macOS 10.15.4, *)
extension Process : _SimCtlProcess, _AsyncableProcess {
  func termintationResult() -> TerminationResult {
    return .init(reason: self.terminationReason, status: Int(self.terminationStatus))
  }
  

  

  
  
  @available(*, deprecated)
    public struct TimeoutError: Error {
      public let timedOut: DispatchTime
    }

  @available(*, deprecated)
    public struct UncaughtSignalError: Error, LocalizedError, Equatable {
      private init(
        reason: Process.TerminationReason,
        status: Int,
        data: Data?,
        output: Data?
      ) {
        self.reason = reason
        self.status = status
        self.data = data
        self.output = output
      }

      internal init?(
        reason: Process.TerminationReason,
        status: Int32,
        standardError: FileHandle,
        output: Data?
      ) {
        if reason == .exit, status == 0 {
          return nil
        }
        let reason = reason
        let status = status
        let data = try? standardError.readToEnd()

        self.init(reason: reason, status: Int(status), data: data, output: output)
      }

      public let reason: TerminationReason
      public let status: Int
      public let data: Data?
      public let output: Data?

      public var errorDescription: String? {
        if let errorText = data.flatMap({ String(bytes: $0, encoding: .utf8) }) {
          return errorText
        } else {
          return "Termination Reason: \(reason) with status: \(status)"
        }
      }
    }

  @available(*, deprecated)
    private static func process(
      _ process: Process,
      timedOut: DispatchTime,
      result: DispatchTimeoutResult,
      withOutput outputData: Result<Data?, Error>,
      andError standardError: FileHandle
    ) -> Result<Data?, Error> {
      switch result {
      case .success:
        if let error = UncaughtSignalError(
          reason: process.terminationReason,
          status: process.terminationStatus,
          standardError: standardError,
          output: try? outputData.get()
        ) {
          return .failure(error)
        } else {
          return outputData
        }

      case .timedOut:
        return .failure(TimeoutError(timedOut: timedOut))
      }
    }
  

  func fileHandles() -> ProcessOutputHandleSet {
    let standardError = Pipe()
    let standardOutput = Pipe()

    self.standardError = standardError
    self.standardOutput = standardOutput

    return .init(output: standardOutput.fileHandleForReading, error: standardError.fileHandleForReading)
  }
    private func setupPipes() -> (FileHandle, FileHandle) {
      let standardError = Pipe()
      let standardOutput = Pipe()

      self.standardError = standardError
      self.standardOutput = standardOutput

      return (standardOutput.fileHandleForReading, standardError.fileHandleForReading)
    }

    internal func promise() -> ProcessCompletionPromise {
      let semaphore = DispatchSemaphore(value: 0)

      terminationHandler = { _ in
        semaphore.signal()
      }
      return semaphore
    }

//    /// Run the process asyncronously and returns the output as data.
//    /// - Parameter timeout: Timeout for the process to be done.
//    /// - Returns: Data if there anything output from the process.
//    public func run(timeout: DispatchTime) async throws -> Data? {
//      let (standardOutput, standardError) = setupPipes()
//      let semaphore = setupSemaphore()
//      try run()
//      return try await withCheckedThrowingContinuation { continuation in
//        let output = Result { try standardOutput.readToEnd() }
//        let semaphoreResult = semaphore.wait(timeout: timeout)
//
//        let result = Self.process(
//          self,
//          timeout: timeout,
//          result: semaphoreResult,
//          withOutput: output,
//          andError: standardError
//        )
//        continuation.resume(with: result)
//      }
//    }
  }

#endif
