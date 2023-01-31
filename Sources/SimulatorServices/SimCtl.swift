#if !os(iOS) && !os(watchOS) && !os(tvOS)
  import Foundation

  /// Interface for running `simctl`.
  @available(macOS 10.15.4, iOS 13.0.0, *)
  public struct SimCtl {
    /// URL Path to `xcrun`
    public let xcRunURL: URL

    private let processFactory: () -> _SimCtlProcess

    internal init(xcRunURL: URL, processFactory: @escaping @autoclosure () -> _SimCtlProcess) {
      self.xcRunURL = xcRunURL
      self.processFactory = processFactory
    }

    /// Create an interface to `simctl`
    /// - Parameter xcRunURL: URL path to `xcrun`.
    public init(xcRunURL: URL = URL(fileURLWithPath: "/usr/bin/xcrun")) {
      self.init(xcRunURL: xcRunURL, processFactory: Process())
    }

    /// Run a subcommand under `simctl`.
    /// - Parameter subcommand: subcommand to run.
    /// - Returns: Result of the subcommand.
    public func run<SubcommandType: Subcommand>(
      _ subcommand: SubcommandType
    ) async throws -> SubcommandType.OutputType {
      let process = processFactory()
      process.executableURL = xcRunURL
      process.arguments = ["simctl"] + subcommand.arguments
      let data: Data?
      do {
        data = try await process.run(timeout: .distantFuture)
      } catch let error as ProcessError {
        try subcommand.recover(error)
        data = nil
      }
      return try subcommand.parse(data)
    }
  }
#endif
