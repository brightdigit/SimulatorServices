/// Device platform
public enum Platform:
  RawDefined,
  Equatable,
  Decodable,
  Sendable,
  RandomEnum,
  CustomStringConvertible {
  case iOS
  case tvOS
  case watchOS
  case xrOS
  case unknown(String)

  public enum RawAvailableOptions: String, Sendable, RawReversable, CaseIterable {
    case iOS
    case tvOS
    case watchOS
    case xrOS

    public init?(option: Platform) {
      switch option {
      case .iOS: self = .iOS
      case .tvOS: self = .tvOS
      case .watchOS: self = .watchOS
      case .xrOS: self = .xrOS
      default: return nil
      }
    }
  }

  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .iOS: self = .iOS
    case .tvOS: self = .tvOS
    case .watchOS: self = .watchOS
    case .xrOS: self = .xrOS
    }
  }

  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
