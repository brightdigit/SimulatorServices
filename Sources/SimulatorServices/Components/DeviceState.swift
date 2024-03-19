/// State for the device.
public enum DeviceState: Equatable, Decodable, Sendable, RawDefined {
  /// Represents a booted state for the device.
  case booted

  /// Represents a creating state for the device.
  case creating

  /// Represents a shutdown state for the device.
  case shutdown

  /// Represents an unknown state for the device with a custom string.
  case unknown(String)

  /// Available raw options for the device state.
  public enum RawAvailableOptions: String {
    case booted = "Booted"
    case creating = "Creating"
    case shutdown = "Shutdown"
  }

  /// Initializes the device state with a raw option.
  ///
  /// - Parameter rawOption: The raw option to initialize from.
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .booted:
      self = .booted
    case .creating:
      self = .creating
    case .shutdown:
      self = .shutdown
    }
  }

  /// Retrieves the custom string for an unknown device state.
  ///
  /// - Returns: The custom string representing the unknown state if applicable,
  /// otherwise nil.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
