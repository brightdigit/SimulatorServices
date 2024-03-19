/// Represents the state of an Apple Watch and iPhone pair.
public enum PairState: Equatable, Decodable, Sendable, RawDefined, RandomEnum {
  /// The devices are actively connected.
  case activeConnected

  /// The devices are actively disconnected.
  case activeDisconnected

  /// The devices are unavailable for pairing.
  case unavailable

  /// Represents an unknown state with additional information.
  case unknown(String)

  /// Available raw options for `PairState`.
  public enum RawAvailableOptions: String, CaseIterable {
    case activeConnected = "(active, disconnected)"
    case activeDisconnected = "(active, connected)"
    case unavailable = "(unavailable)"
  }

  /// Initializes a `PairState` from a raw option.
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

  /// Retrieves the associated string for an unknown state.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
