#if !os(iOS) && !os(watchOS) && !os(tvOS)
  import Foundation

  @available(macOS 10.15.4, iOS 13.0.0, *)
  public struct SimCtl {
    public init(xcRunURL: URL = URL(fileURLWithPath: "/usr/bin/xcrun")) {
      self.xcRunURL = xcRunURL
    }

    let xcRunURL: URL

    public func run<SubcommandType: Subcommand>(_ subcommand: SubcommandType) async throws -> SubcommandType.OutputType {
      let process = Process()
      process.executableURL = xcRunURL
      process.arguments = ["simctl"] + subcommand.arguments
      let data: Data?
      do {
        data = try await process.run(timeout: .distantFuture)
      } catch let error as Process.UncaughtSignalError {
        try subcommand.recover(error)
        data = nil
      }
      return try subcommand.parse(data)
    }
  }
#endif
