import Foundation
@testable import SimulatorServices

final class MockSubcommand<OutputType>: Subcommand {
  internal init(arguments: [String] = [String](), callback: @escaping @Sendable (Data?) throws -> OutputType) {
    self.callback = callback
    self.arguments = arguments
  }

  let callback: @Sendable (Data?) throws -> OutputType
  func parse(_ data: Data?) throws -> OutputType {
    try callback(data)
  }

  let arguments : [String]
}
