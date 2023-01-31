import XCTest
@testable import SimulatorServices

public class UncaughtSignalErrorTests: XCTestCase {
  func testInit () {
    
  }
  func testDescription () {
    
  }
}
//#if !os(iOS) && !os(watchOS) && !os(tvOS)
//  import Foundation
//
//  @available(macOS 10.15.4, *)
//  extension Process {
//    public struct TimeoutError: Error {
//      public let timeout: DispatchTime
//    }
//
//    public struct UncaughtSignalError: Error, LocalizedError {
//      private init(
//        reason: Process.TerminationReason,
//        status: Int,
//        data: Data?,
//        output: Data?
//      ) {
//        self.reason = reason
//        self.status = status
//        self.data = data
//        self.output = output
//      }
//
//      internal init?(
//        reason: Process.TerminationReason,
//        status: Int32,
//        standardError: Pipe,
//        output: Data?
//      ) {
//        if reason == .exit, status == 0 {
//          return nil
//        }
//        let reason = reason
//        let status = status
//        let data = try? standardError.fileHandleForReading.readToEnd()
//
//        self.init(reason: reason, status: Int(status), data: data, output: output)
//      }
//
//      public let reason: TerminationReason
//      public let status: Int
//      public let data: Data?
//      public let output: Data?
//
//      public var errorDescription: String? {
//        if let errorText = data.flatMap({ String(bytes: $0, encoding: .utf8) }) {
//          return errorText
//        } else {
//          return "Termination Reason: \(reason) with status: \(status)"
//        }
//      }
//    }
//
//    private static func process(
//      _ process: Process,
//      timeout: DispatchTime,
//      result: DispatchTimeoutResult,
//      withOutput outputData: Result<Data?, Error>,
//      andError standardError: Pipe
//    ) -> Result<Data?, Error> {
//      switch result {
//      case .success:
//        if let error = UncaughtSignalError(
//          reason: process.terminationReason,
//          status: process.terminationStatus,
//          standardError: standardError,
//          output: try? outputData.get()
//        ) {
//          return .failure(error)
//        } else {
//          return outputData
//        }
//
//      case .timedOut:
//        return .failure(TimeoutError(timeout: timeout))
//      }
//    }
//
//    private func setupPipes() -> (Pipe, Pipe) {
//      let standardError = Pipe()
//      let standardOutput = Pipe()
//
//      self.standardError = standardError
//      self.standardOutput = standardOutput
//
//      return (standardOutput, standardError)
//    }
//
//    private func setupSemaphore() -> DispatchSemaphore {
//      let semaphore = DispatchSemaphore(value: 0)
//
//      terminationHandler = { _ in
//        semaphore.signal()
//      }
//      return semaphore
//    }
//
//    /// Run the process asyncronously and returns the output as data.
//    /// - Parameter timeout: Timeout for the process to be done.
//    /// - Returns: Data if there anything output from the process.
//    public func run(timeout: DispatchTime) async throws -> Data? {
//      let (standardOutput, standardError) = setupPipes()
//      let semaphore = setupSemaphore()
//      try run()
//      return try await withCheckedThrowingContinuation { continuation in
//        let output = Result { try standardOutput.fileHandleForReading.readToEnd() }
//        let semaphoreResult = semaphore.wait(timeout: timeout)
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
//  }
//
//#endif
