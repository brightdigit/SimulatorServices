import Foundation

// TODO: add documentation
public struct Device: Decodable, Equatable {
  // TODO: add documentation
  public let dataPath: Path // URL?
  // TODO: add documentation
  public let dataPathSize: Int
  // TODO: add documentation
  public let logPath: Path // URL?
  // TODO: add documentation
  public let udid: UUID
  // TODO: add documentation
  public let isAvailable: Bool
  // TODO: add documentation
  public let logPathSize: Int?
  // TODO: add documentation
  public let lastBootedAt: Date?
  // TODO: add documentation
  public let deviceTypeIdentifier: DeviceTypeID // Identifier (Device)
  // TODO: add documentation
  public let state: DeviceState // DeviceState
  // TODO: add documentation
  public let name: String
}
