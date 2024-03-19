/**
 The product family of a device.

 - Note: This enum conforms to several protocols for functionality.

 - SeeAlso: `RawAvailableOptions` for the available raw options.

 - SeeAlso: `unknownValue()` for retrieving the unknown value.

 - Important: The `unknown` case allows for custom product family names.

 - Warning: Ensure all cases are handled when working with this enum.
 */
public enum ProductFamily: RawDefined, Equatable, Decodable, Sendable, CaseIterable, RandomEnum {
  case iPhone
  case iPad
  case appleTV
  case appleWatch
  case appleVision
  case unknown(String)

  /// Available raw options for the product family.
  public enum RawAvailableOptions: String, CaseIterable {
    case iPhone
    case iPad
    case appleTV = "Apple TV"
    case appleWatch = "Apple Watch"
    case appleVision = "Apple Vision"
  }

  /// Initialize with a raw option.
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .iPhone: self = .iPhone
    case .iPad: self = .iPad
    case .appleTV: self = .appleTV
    case .appleWatch: self = .appleWatch
    case .appleVision: self = .appleVision
    }
  }

  /// Retrieve the unknown value if it exists.
  public func unknownValue() -> String? {
    guard case let .unknown(string) = self else {
      return nil
    }
    return string
  }
}
