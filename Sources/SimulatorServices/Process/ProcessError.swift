import Foundation

/// Why running a process failed.
public enum ProcessError: Error, Equatable, Sendable, LocalizedError {
  /// The process couldn't be started.
  case launchFailed(String)
  /// The process exited with a non-zero status or was killed by a signal.
  case uncaughtSignal(UncaughtSignal)
  /// The process's output couldn't be read.
  case unreadableOutput(String)

  /// A description of the error.
  public var errorDescription: String? {
    switch self {
    case let .launchFailed(description): "The process couldn't be started: \(description)"
    case let .uncaughtSignal(signal): signal.description
    case let .unreadableOutput(description): "The output couldn't be read: \(description)"
    }
  }
}
