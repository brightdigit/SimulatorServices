
public struct SimulatorList : Decodable {
  public let devicetypes : [DeviceType]
  public let runtimes: [Runtime]
  public let devices : [String : [Device]]
  public let pairs : [String : DevicePair]
}


