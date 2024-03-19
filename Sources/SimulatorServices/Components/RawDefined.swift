public protocol RawDefined {
  associatedtype RawAvailableOptions: RawRepresentable

  init(rawOption: RawAvailableOptions)
  static func unknown(_ rawValue: RawAvailableOptions.RawValue) -> Self
  func unknownValue() -> RawAvailableOptions.RawValue?
}

extension RawDefined where Self: Decodable, Self.RawAvailableOptions.RawValue: Decodable {
  public init(rawValue: RawAvailableOptions.RawValue) {
    if let rawValueOption = RawAvailableOptions(rawValue: rawValue) {
      self.init(rawOption: rawValueOption)
    } else {
      self = .unknown(rawValue)
    }
  }

  public init(from decoder: any Decoder) throws {
    let rawValueString = try decoder.singleValueContainer().decode(RawAvailableOptions.RawValue.self)
    self.init(rawValue: rawValueString)
  }
}

extension RawDefined where Self: CaseIterable, Self.RawAvailableOptions: CaseIterable {
  public static var allCases: [Self] { Self.RawAvailableOptions.allCases.map(Self.init(rawOption:))
  }
}

public protocol RawReversable {
  associatedtype OptionType: RawDefined

  init?(option: OptionType)
}

extension RawDefined where Self.RawAvailableOptions: RawReversable, Self.RawAvailableOptions.OptionType == Self {
  public var underlyingValue: RawAvailableOptions.RawValue {
    switch (RawAvailableOptions(option: self), unknownValue()) {
    case let (.some(value), _):
      return value.rawValue

    case let (.none, .some(value)):
      return value

    case (.none, .none):
      fatalError("Invalid state should never happen.")
    }
  }
}

extension RawDefined where Self: CustomStringConvertible, Self.RawAvailableOptions: RawReversable, Self.RawAvailableOptions.OptionType == Self, Self.RawAvailableOptions.RawValue: CustomStringConvertible {
  public var description: String {
    underlyingValue.description
  }
}
