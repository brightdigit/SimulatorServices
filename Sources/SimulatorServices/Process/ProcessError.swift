import Foundation

// TODO: add documentation
public enum ProcessError: Error, LocalizedError, Equatable {
  // TODO: add documentation
  case timeout(DispatchTime)
  // TODO: add documentation
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
