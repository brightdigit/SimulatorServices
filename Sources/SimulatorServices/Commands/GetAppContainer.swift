import Foundation

// TODO: add documentation
public struct GetAppContainer: Subcommand {
  // TODO: add documentation
  public typealias OutputType = Path

  // TODO: add documentation
  public enum Error: Swift.Error, Equatable {
    case missingData
    case invalidData(Data)
    case invalidPath(String)
  }

  // TODO: add documentation
  public let appBundleIdentifier: String
  // TODO: add documentation
  public let container: ContainerID
  // TODO: add documentation
  public let simulator: SimulatorID

  // TODO: add documentation
  public var arguments: [String] {
    [
      "get_app_container",
      simulator.description,
      appBundleIdentifier,
      container.description
    ]
  }

  // TODO: add documentation
  public init(
    appBundleIdentifier: String,
    container: ContainerID = .app,
    simulator: SimulatorID = .booted
  ) {
    self.appBundleIdentifier = appBundleIdentifier
    self.container = container
    self.simulator = simulator
  }

  // TODO: add documentation
  public func parse(_ data: Data?) throws -> Path {
    guard let data = data else {
      throw Error.missingData
    }

    guard let text = String(bytes: data, encoding: .utf8) else {
      throw Error.invalidData(data)
    }

    return text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  // TODO: add documentation
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
