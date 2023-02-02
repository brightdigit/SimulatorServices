import Foundation

/// An error which occured while running a process.
public enum ProcessError: Error, LocalizedError, Equatable {
  /// A timeout from running a process asnycronously
  case timeout(DispatchTime)

  /// The process existed with an error exit code.
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
