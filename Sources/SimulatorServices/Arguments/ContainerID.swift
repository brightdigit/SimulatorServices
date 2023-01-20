public enum ContainerID : CustomStringConvertible {
  case app     //            The .app bundle
  case data  //              The application's data container
  case groups    //          The App Group containers
  case appGroup(String) // A specific App Group container
  
  public var description: String {
    switch self {
    case .data:
      return "data"
    case .groups:
      return "groups"
    case .app:
      return "app"
    case .appGroup(let group):
      return group
    }
  }
}

