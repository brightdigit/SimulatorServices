public struct DeviceType: Decodable, Equatable, Sendable {
  public let productFamily: ProductFamily
  public let bundlePath: Path
  public let maxRuntimeVersion: Int
  public let maxRuntimeVersionString: Version
  public let identifier: DeviceTypeID
  public let modelIdentifier: ModelID
  public let minRuntimeVersionString: Version
  public let minRuntimeVersion: Int
  public let name: String
}
