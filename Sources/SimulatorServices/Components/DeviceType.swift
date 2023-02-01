// TODO: add documentation
public struct DeviceType: Decodable, Equatable {
  // TODO: add documentation
  public let productFamily: ProductFamily // deviceType
  // TODO: add documentation
  public let bundlePath: Path // URL?
  // TODO: add documentation
  public let maxRuntimeVersion: Int
  // TODO: add documentation
  public let maxRuntimeVersionString: Version
  // TODO: add documentation
  public let identifier: DeviceTypeID // identifier
  // TODO: add documentation
  public let modelIdentifier: ModelID // model
  // TODO: add documentation
  public let minRuntimeVersionString: Version
  // TODO: add documentation
  public let minRuntimeVersion: Int
  // TODO: add documentation
  public let name: String
}
