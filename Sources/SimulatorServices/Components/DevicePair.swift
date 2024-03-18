import Foundation

public struct DevicePair: Decodable, Equatable, Sendable {
  public struct Device: Decodable, Equatable, Sendable {
    public let name: String
    public let udid: UUID
    public let state: DeviceState // Device.State
  }

  public let watch: Device
  public let phone: Device
  public let state: PairState // Pair.State
}
