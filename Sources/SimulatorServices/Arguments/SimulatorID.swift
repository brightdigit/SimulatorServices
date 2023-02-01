import Foundation
// TODO: add documentation
public enum SimulatorID: CustomStringConvertible, Equatable {
  // TODO: add documentation
  case id(UUID)
  // TODO: add documentation
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
