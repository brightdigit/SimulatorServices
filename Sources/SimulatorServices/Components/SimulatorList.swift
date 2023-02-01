// TODO: add documentation
public struct SimulatorList: Decodable, Equatable {
  // TODO: add documentation
  public let devicetypes: [DeviceType]
  // TODO: add documentation
  public let runtimes: [Runtime]
  // TODO: add documentation
  public let devices: [String: [Device]]
  // TODO: add documentation
  public let pairs: [String: DevicePair]
}
