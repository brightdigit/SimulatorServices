import Foundation
public enum SimulatorID: CustomStringConvertible, Equatable {
  case id(UUID)
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
