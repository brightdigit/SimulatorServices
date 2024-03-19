/// State for an Apple Watch and iPhone pair
public enum PairState: Equatable, Decodable, Sendable, RawDefined, RandomEnum {
  case activeConnected
  case activeDisconnected
  case unavailable
  case unknown(String)
  public enum RawAvailableOptions: String, CaseIterable {
    case activeConnected = "(active, disconnected)"
    case activeDisconnected = "(active, connected)"
    case unavailable = "(unavailable)"
  }

  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .activeConnected:
      self = .activeConnected

    case .unavailable:
      self = .unavailable

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
