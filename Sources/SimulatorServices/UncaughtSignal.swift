import Foundation
/// Reason for the termination.
public typealias TerminationReason = Int

@available(macOS 10.15.4, *)
public struct UncaughtSignal: Equatable, CustomStringConvertible {
  private static let exitReason = 1
  public let reason: TerminationReason
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

  private init(
    reason: TerminationReason,
    status: Int,
    data: Data?,
    output: Data?
  ) {
    self.reason = reason
    self.status = status
    self.data = data
    self.output = output
  }

  @available(iOS 13.4, *)
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

    self.init(reason: reason, status: Int(status), data: data, output: output)
  }

  internal init?(
    termination: TerminationResult,
    standardError: FileHandle,
    output: Data?
  ) {
    self.init(reason: termination.reason, status: termination.status, standardError: standardError, output: output)
  }
}
