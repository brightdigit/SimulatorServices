import Foundation

#if !os(iOS) && !os(watchOS) && !os(tvOS)
@available(macOS 10.15.4, *)
public protocol Subcommand {
  associatedtype OutputType
  
  var arguments : [String] { get }
  func recover(_ error: Process.UncaughtSignalError) throws
  func parse(_ data: Data?) throws -> OutputType
}

@available(macOS 10.15.4, *)
public extension Subcommand {
  func recover(_ error: Process.UncaughtSignalError) throws {
    throw error
  }
}
#endif
