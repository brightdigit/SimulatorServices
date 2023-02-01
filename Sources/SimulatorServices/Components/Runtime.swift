// TODO: add documentation
public struct Runtime: Decodable, Equatable {
  // TODO: add documentation
  public struct SupportedDeviceType: Decodable, Equatable {
    // TODO: add documentation
    public let bundlePath: Path // URL?
    // TODO: add documentation
    public let name: String
    // TODO: add documentation
    public let identifier: DeviceTypeID // identifier
    // TODO: add documentation
    public let productFamily: ProductFamily // deviceType
  }

  // TODO: add documentation
  public let supportedDeviceTypes: [SupportedDeviceType]
  // TODO: add documentation
  public let bundlePath: Path // URL?
  // TODO: add documentation
  public let buildversion: String
  // TODO: add documentation
  public let platform: Platform // platform
  // TODO: add documentation
  public let runtimeRoot: Path // URL?
  // TODO: add documentation
  public let identifier: RuntimeID
  // TODO: add documentation
  public let version: Version // version
  // TODO: add documentation
  public let isInternal: Bool
  // TODO: add documentation
  public let isAvailable: Bool
  // TODO: add documentation
  public let name: String
}
