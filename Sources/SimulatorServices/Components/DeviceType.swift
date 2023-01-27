public struct DeviceType: Decodable {
  let productFamily: ProductFamily // deviceType
  let bundlePath: Path // URL?
  let maxRuntimeVersion: Int
  let maxRuntimeVersionString: Version
  let identifier: DeviceTypeID // identifier
  let modelIdentifier: ModelID // model
  let minRuntimeVersionString: Version
  let minRuntimeVersion: Int
  let name: String
}
