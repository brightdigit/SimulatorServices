import Foundation
public enum SimulatorID : CustomStringConvertible {
  public var description: String {
    switch self {
    case .booted :
      return "booted"
    case .id(let uuid):
      return uuid.uuidString
    }
  }
  
  case id(UUID)
  case booted
}

