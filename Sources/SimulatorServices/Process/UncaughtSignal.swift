import Foundation
/// Reason for the termination.
public typealias TerminationReason = Int

// TODO: add documentation
public struct UncaughtSignal: Equatable, CustomStringConvertible {
  private static let exitReason = 1
  // TODO: add documentation
  public let reason: TerminationReason
  // TODO: add documentation
  public let status: Int
  // TODO: add documentation
  public let data: Data?
  // TODO: add documentation
  public let output: Data?

  public var description: String {
    if let errorText = data.flatMap({ String(bytes: $0, encoding: .utf8) }) {
      return errorText
    } else {
      return "Termination Reason: \(reason) with status: \(status)"
    }
  }

  private init(
    uncheckedReason: TerminationReason,
    uncheckedStatus: Int,
    data: Data?,
    output: Data?
  ) {
    reason = uncheckedReason
    status = uncheckedStatus
    self.data = data
    self.output = output
  }

  internal init?(
    reason: TerminationReason,
    status: Int,
    data: Data?,
    output: Data?
  ) {
    if reason == UncaughtSignal.exitReason, status == 0 {
      return nil
    }
    self.init(
      uncheckedReason: reason,
      uncheckedStatus: status,
      data: data,
      output: output
    )
  }

  @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
  internal init?(
    reason: TerminationReason,
    status: Int,
    standardError: FileHandle,
    output: Data?
  ) {
    if reason == UncaughtSignal.exitReason, status == 0 {
      return nil
    }
    let reason = reason
    let status = status
    let data = try? standardError.readToEnd()

    self.init(
      uncheckedReason: reason,
      uncheckedStatus: Int(status),
      data: data,
      output: output
    )
  }

  @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
  internal init?(
    termination: TerminationResult,
    standardError: FileHandle,
    output: Data?
  ) {
    self.init(
      reason: termination.reason,
      status: termination.status,
      standardError: standardError,
      output: output
    )
  }
}
