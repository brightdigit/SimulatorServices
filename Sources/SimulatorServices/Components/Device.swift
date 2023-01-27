import Foundation

public struct Device: Decodable {
  public let dataPath: Path // URL?
  public let dataPathSize: Int
  public let logPath: Path // URL?
  public let udid: UUID
  public let isAvailable: Bool
  public let logPathSize: Int?
  public let lastBootedAt: Date?
  public let deviceTypeIdentifier: DeviceTypeID // Identifier (Device)
  public let state: DeviceState // DeviceState
  public let name: String
}
