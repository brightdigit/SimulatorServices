import Foundation
@testable import SimulatorServices

class MockSubcommand<OutputType>: Subcommand {
  internal init(arguments: [String] = [String](), callback: @escaping (Data?) throws -> OutputType) {
    self.callback = callback
    self.arguments = arguments
  }

  let callback: (Data?) throws -> OutputType
  func parse(_ data: Data?) throws -> OutputType {
    try callback(data)
  }

  var arguments = [String]()
}
