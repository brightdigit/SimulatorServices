/// Device's product family.
public enum ProductFamily:
  RawDefined, Equatable, Decodable, Sendable, CaseIterable, RandomEnum {
  case iPhone
  case iPad
  case appleTV
  case appleWatch
  case appleVision
  case unknown(String)
  public enum RawAvailableOptions: String, CaseIterable {
    case iPhone

    case iPad

    case appleTV = "Apple TV"

    case appleWatch = "Apple Watch"

    case appleVision = "Apple Vision"
  }

  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .iPhone: self = .iPhone
    case .iPad: self = .iPad
    case .appleTV: self = .appleTV
    case .appleWatch: self = .appleWatch
    case .appleVision: self = .appleVision
    }
  }

  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
