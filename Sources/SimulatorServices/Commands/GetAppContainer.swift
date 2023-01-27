#if !os(iOS) && !os(watchOS) && !os(tvOS)

  import Foundation

  @available(macOS 10.15.4, *)
  public struct GetAppContainer: Subcommand {
    public enum Error: Swift.Error {
      case missingData
      case invalidData(Data)
      case invalidPath(String)
    }

    public let appBundleIdentifier: String
    public let container: ContainerID
    public let simulator: SimulatorID

    public init(
      appBundleIdentifier: String,
      container: ContainerID,
      simulator: SimulatorID
    ) {
      self.appBundleIdentifier = appBundleIdentifier
      self.container = container
      self.simulator = simulator
    }

    public typealias OutputType = Path

    public var arguments: [String] {
      [
        "get_app_container",
        simulator.description,
        appBundleIdentifier,
        container.description
      ]
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

    public func recover(_ error: Process.UncaughtSignalError) throws {
      guard let text = error.data.flatMap({ String(data: $0, encoding: .utf8) }) else {
        throw error
      }

      let lines = text.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }

      guard let errorString = lines.last?.trimmingCharacters(in: .whitespacesAndNewlines) else {
        throw error
      }

      guard errorString == "No such file or directory" else {
        throw error
      }
    }
  }

#endif
