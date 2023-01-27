import Foundation

public struct DevicePair: Decodable {
  public struct Device: Decodable {
    public let name: String
    public let udid: UUID
    public let state: DeviceState // Device.State
  }

  public let watch: Device
  public let phone: Device
  public let state: PairState // Pair.State
}
