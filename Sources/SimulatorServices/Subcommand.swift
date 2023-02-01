import Foundation


  /// Subcommand to be run from `simctl`
  public protocol Subcommand {
    /// The output type of the subcommand
    associatedtype OutputType

    /// Arguments to be passed to `simctl`
    var arguments: [String] { get }

    /// Optional function for recovering from a process error.
    /// - Parameter error: ``ProcessError/UncaughtSignal`` received.
    /// - SeeAlso: ``GetAppContainer/recover(_:)``
    func recover(_ error: ProcessError) throws

    /// Convert the data into the desiginated ``OutputType``.
    /// - Parameter data: Data received from the `simctl`
    func parse(_ data: Data?) throws -> OutputType
  }

  extension Subcommand {
    /// Optional function for recovering from a process error.
    /// - Parameter error: ``ProcessError/UncaughtSignalError`` received.
    /// - SeeAlso: ``GetAppContainer/recover(_:)``
    public func recover(_ error: ProcessError) throws {
      throw error
    }
  }
