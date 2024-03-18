import Foundation

/// Identifier for specifying a simulator device.
public enum SimulatorID: CustomStringConvertible, Equatable, Sendable {
  /// Specify particular device by its ``Device/udid``.
  case id(UUID)
  /// Specify any booted device.
  case booted
  public var description: String {
    switch self {
    case .booted:
      return "booted"
    case let .id(uuid):
      return uuid.uuidString
    }
  }
}
