//
//  File.swift
//  
//
//  Created by Leo Dion on 1/30/23.
//

import Foundation

struct TerminationResult {
  typealias Reason = Process.TerminationReason
  
  let reason : Reason
  let status : Int
  
  
}

internal protocol _SimCtlProcess : AnyObject {
  var executableURL: URL? { set get }
  var arguments: [String]? { set get }
  func run(timeout: DispatchTime) async throws -> Data?
}

enum ProcessResult {
  case success(TerminationResult)
  case timedOut(DispatchTime)
}

extension DispatchSemaphore : ProcessCompletionPromise {
  func waitForCompletion(for timeout: DispatchTime, with result: @autoclosure @escaping () -> TerminationResult)  -> ProcessResult {
    let processResult = self.wait(timeout: timeout)
    
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


struct ProcessOutputHandleSet {
  let output : FileHandle
  let error : FileHandle
}

@available(macOS 10.15.4, *)
internal protocol _AsyncableProcess : AnyObject {
  func run () throws
  func promise () -> ProcessCompletionPromise
  func fileHandles () -> ProcessOutputHandleSet
  func termintationResult () -> TerminationResult
}


@available(macOS 10.15.4, *)
extension _AsyncableProcess {
  func data(basedOn result: ProcessResult, from fileHandles: ProcessOutputHandleSet) throws -> Data? {
    switch result {
    case .success(let termination):
      let outputResult = Result{try fileHandles.output.readToEnd()}
      if let uncaught = ProcessError.UncaughtSignal(
        termination: termination,
        standardError: fileHandles.error,
        output: try? outputResult.get()
      ) {
        throw ProcessError.uncaughtSignal(uncaught)
      } else {
        return try outputResult.get()
      }

    case .timedOut(let timeout):
      throw ProcessError.timeout(timeout)
    }
  }
  /// Run the process asyncronously and returns the output as data.
  /// - Parameter timeout: Timeout for the process to be done.
  /// - Returns: Data if there anything output from the process.
  public func run(timeout: DispatchTime) async throws -> Data? {
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

