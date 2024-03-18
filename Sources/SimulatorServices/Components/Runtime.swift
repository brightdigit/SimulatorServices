public struct Runtime: Decodable, Equatable, Sendable {
  public struct SupportedDeviceType: Decodable, Equatable, Sendable {
    public let bundlePath: Path // URL?
    public let name: String
    public let identifier: DeviceTypeID // identifier
    public let productFamily: ProductFamily // deviceType
  }

  public let supportedDeviceTypes: [SupportedDeviceType]
  public let bundlePath: Path // URL?
  public let buildversion: String
  public let platform: Platform // platform
  public let runtimeRoot: Path // URL?
  public let identifier: RuntimeID
  public let version: Version // version
  public let isInternal: Bool
  public let isAvailable: Bool
  public let name: String
}
