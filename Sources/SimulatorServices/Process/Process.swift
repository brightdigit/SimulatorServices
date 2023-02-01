#if !os(iOS) && !os(watchOS) && !os(tvOS)
  import Foundation

  @available(macOS 10.15.4, *)
  extension Process: _SimCtlProcess, _AsyncableProcess {
    internal func termintationResult() -> TerminationResult {
      .init(reason: terminationReason.rawValue, status: Int(terminationStatus))
    }

    internal func fileHandles() -> ProcessOutputHandleSet {
      let standardError = Pipe()
      let standardOutput = Pipe()

      self.standardError = standardError
      self.standardOutput = standardOutput

      return .init(
        output: standardOutput.fileHandleForReading,
        error: standardError.fileHandleForReading
      )
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
