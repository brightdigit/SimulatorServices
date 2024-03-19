/// State for the device
public enum DeviceState: Equatable, Decodable, Sendable, RawDefined {
  case booted
  case shutdown
  case unknown(String)
  public enum RawAvailableOptions: String {
    case booted = "Booted"
    case shutdown = "Shutdown"
  }

  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .booted:
      self = .booted

    case .shutdown:
      self = .shutdown
    }
  }

  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
