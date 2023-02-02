/// Specification for the directory type from the app container.
public enum ContainerID: CustomStringConvertible, Equatable {
  /// The .app bundle
  case app
  /// The application's data container
  case data
  /// The App Group containers
  case groups
  /// A specific App Group container
  case appGroup(String)

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
