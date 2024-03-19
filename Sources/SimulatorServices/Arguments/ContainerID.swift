/// Represents different types of directories within the app container.
public enum ContainerID: CustomStringConvertible, Equatable, Sendable {
  /// The directory for the app's bundle.
  case app

  /// The directory for the application's data.
  case data

  /// The directory for App Group containers.
  case groups

  /// A specific directory within an App Group container.
  case appGroup(String)

  /// A textual representation of the directory type.
  public var description: String {
    switch self {
    case .data:
      return "data"
    case .groups:
      return "groups"
    case .app:
      return "app"
    case let .appGroup(group):
      return group
    }
  }
}
