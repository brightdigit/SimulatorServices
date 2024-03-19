

/// Device Model ID
@available(macOS 13.0, *)
public struct ModelID: Decodable, Equatable, Sendable, CustomStringConvertible {
  internal static func random() -> ModelID {
    .init(name: .allCases.randomElement()!, version: .random())
  }

  internal init(name: ModelID.Name, version: ModelID.Version) {
    self.name = name
    self.version = version
  }

  public var description: String {
    "\(name)\(version.major),\(version.minor)"
  }

  public enum Name: String, Sendable, CaseIterable {
    case iPod

    case iPhone

    case iPad

    case appleTV = "AppleTV"

    case appleWatch = "Watch"

    case appleVision = "RealityDevice"
  }

  public let name: Name
  public let version: Version

  public struct Version: Equatable, Sendable {
    internal init(major: Int, minor: Int) {
      self.major = major
      self.minor = minor
    }

    public let major: Int
    public let minor: Int

    internal static func random() -> Version {
      .init(major: .random(in: 2 ... 25), minor: .random(in: 1 ... 9))
    }
  }

  public init(from decoder: any Decoder) throws {
    let stringValue = try decoder.singleValueContainer().decode(String.self)
    let regex = /([a-zA-Z]+)(\d+),(\d+)/
    guard let match = stringValue.firstMatch(of: regex) else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "String doesn't match pattern: \(stringValue)"))
    }
    guard let name = Name(rawValue: String(match.1)) else {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown product \(match.1)"))
    }
    guard let major = Int(match.2) else {
      assertionFailure("Invalid major value: \(match.2)")
      throw DecodingError.valueNotFound(Int.self, .init(codingPath: [], debugDescription: "Invalid major value: \(match.2)"))
    }
    guard let minor = Int(match.3) else {
      assertionFailure("Invalid minor value: \(match.3)")
      throw DecodingError.valueNotFound(Int.self, .init(codingPath: [], debugDescription: "Invalid minor value: \(match.3)"))
    }
    self.init(name: name, version: .init(major: major, minor: minor))
  }
}
