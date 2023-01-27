import Foundation

public struct DevicePair: Decodable {
  public struct Device: Decodable {
    let name: String
    let udid: UUID
    let state: DeviceState // Device.State
  }

  let watch: Device
  let phone: Device
  let state: PairState // Pair.State
}
