import OperatingSystemVersion

/// Runtime ID
public struct RuntimeID: Decodable, Equatable, Sendable {
  public let platform: Platform
  public let version: Version

  public var description: String {
    let values: [any CustomStringConvertible] = [
      platform,
      version.majorVersion,
      version.minorVersion
    ]
    return values.map(\.description).joined(separator: "-")
  }

  public init(platform: Platform, version: Version) {
    self.platform = platform
    self.version = version
  }

  // swiftlint:disable:next function_body_length
  public init(from decoder: any Decoder) throws {
    let coreSimulatorPrefix = "com.apple.CoreSimulator.SimRuntime."
    let stringValue = try decoder.singleValueContainer().decode(String.self)
    guard stringValue.starts(with: coreSimulatorPrefix) else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: [], debugDescription: "Invalid value: \"\(stringValue)\"")
      )
    }
    let suffixValue = stringValue.suffix(
      from: stringValue.index(
        stringValue.startIndex,
        offsetBy: coreSimulatorPrefix.count
      )
    )
    let values = suffixValue.components(separatedBy: "-")
    guard values.count == 3 else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: [], debugDescription: "Invalid value: \"\(stringValue)\"")
      )
    }
    let platform = Platform(rawValue: values[0])
    let versionValues = values[1...].compactMap(Int.init)
    let version = try Version(components: versionValues)
    self.init(platform: platform, version: version)
  }
}
