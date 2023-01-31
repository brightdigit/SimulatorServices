#if !os(iOS) && !os(watchOS) && !os(tvOS)
  import Foundation

  @available(macOS 10.15.4, *)
  public struct UncaughtSignal: Equatable, CustomStringConvertible {
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

    public var description: String {
      if let errorText = data.flatMap({ String(bytes: $0, encoding: .utf8) }) {
        return errorText
      } else {
        return "Termination Reason: \(reason) with status: \(status)"
      }
    }
  }

  @available(macOS 10.15.4, *)
  public enum ProcessError: Error, LocalizedError, Equatable {
    case timeout(DispatchTime)
    case uncaughtSignal(UncaughtSignal)

    public var errorDescription: String? {
      switch self {
      case let .timeout(timeout):
        return "Process did not completed with timeout: \(timeout)"
      case let .uncaughtSignal(signal):
        return signal.description
      }
    }
  }

  @available(macOS 10.15.4, *)
  extension Process: _SimCtlProcess, _AsyncableProcess {
    internal func termintationResult() -> TerminationResult {
      .init(reason: terminationReason, status: Int(terminationStatus))
    }

    internal func fileHandles() -> ProcessOutputHandleSet {
      let standardError = Pipe()
      let standardOutput = Pipe()

      self.standardError = standardError
      self.standardOutput = standardOutput

      return .init(output: standardOutput.fileHandleForReading, error: standardError.fileHandleForReading)
    }

    internal func promise() -> ProcessCompletionPromise {
      let semaphore = DispatchSemaphore(value: 0)

      terminationHandler = { _ in
        semaphore.signal()
      }
      return semaphore
    }
  }

#endif
