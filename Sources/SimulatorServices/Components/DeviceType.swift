public struct DeviceType: Decodable, Equatable {
  public let productFamily: ProductFamily // deviceType

  public let bundlePath: Path // URL?

  public let maxRuntimeVersion: Int

  public let maxRuntimeVersionString: Version

  public let identifier: DeviceTypeID // identifier

  public let modelIdentifier: ModelID // model

  public let minRuntimeVersionString: Version

  public let minRuntimeVersion: Int

  public let name: String
}
