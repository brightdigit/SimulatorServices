import Foundation

public struct GetAppContainer: Subcommand {
  public typealias OutputType = Path

  public enum Error: Swift.Error, Equatable {
    case missingData
    case invalidData(Data)
    case invalidPath(String)
  }

  public let appBundleIdentifier: String
  public let container: ContainerID
  public let simulator: SimulatorID

  public var arguments: [String] {
    [
      "get_app_container",
      simulator.description,
      appBundleIdentifier,
      container.description
    ]
  }

  public init(
    appBundleIdentifier: String,
    container: ContainerID,
    simulator: SimulatorID
  ) {
    self.appBundleIdentifier = appBundleIdentifier
    self.container = container
    self.simulator = simulator
  }

  public func parse(_ data: Data?) throws -> Path {
    guard let data = data else {
      throw Error.missingData
    }

    guard let text = String(bytes: data, encoding: .utf8) else {
      throw Error.invalidData(data)
    }

    return text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  public func recover(_ error: ProcessError) throws {
    guard case let .uncaughtSignal(signal) = error else {
      throw error
    }

    guard let text = signal.data.flatMap({ String(data: $0, encoding: .utf8) }) else {
      throw error
    }

    let lines = text.components(separatedBy: .newlines)
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }

    guard let errorString = lines.last?
      .trimmingCharacters(in: .whitespacesAndNewlines) else {
      throw error
    }

    guard errorString == "No such file or directory" else {
      throw error
    }
  }
}
