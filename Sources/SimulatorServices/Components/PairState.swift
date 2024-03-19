/// State for an Apple Watch and iPhone pair
public enum PairState: Equatable, Decodable, Sendable, RawDefined {
  case activeConnected
  case activeDisconnected
  case unknown(String)
  public enum RawAvailableOptions: String {
    case activeConnected = "(active, disconnected)"
    case activeDisconnected = "(active, connected)"
  }

  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .activeConnected:
      self = .activeConnected

    case .activeDisconnected:
      self = .activeDisconnected
    }
  }

  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
