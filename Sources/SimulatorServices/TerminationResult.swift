import Foundation

internal struct TerminationResult {
  internal typealias Reason = Process.TerminationReason

  internal let reason: Reason
  internal let status: Int
}
