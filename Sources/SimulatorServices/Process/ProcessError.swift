import Foundation

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
