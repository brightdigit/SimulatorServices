import Foundation

// TODO: add documentation
public struct DevicePair: Decodable, Equatable {
  // TODO: add documentation
  public struct Device: Decodable, Equatable {
    // TODO: add documentation
    public let name: String
    // TODO: add documentation
    public let udid: UUID
    // TODO: add documentation
    public let state: DeviceState // Device.State
  }

  // TODO: add documentation
  public let watch: Device
  // TODO: add documentation
  public let phone: Device
  // TODO: add documentation
  public let state: PairState // Pair.State
}
