import Foundation
@testable import SimulatorServices

class MockSimCtlProcess: _SimCtlProcess {
  internal init(result: Result<Data?, Error>, executableURL: URL? = nil, arguments: [String]? = nil) {
    self.result = result
    self.executableURL = executableURL
    self.arguments = arguments
  }

  let result: Result<Data?, Error>
  var executableURL: URL?

  var arguments: [String]?

  func run(timeout _: DispatchTime) async throws -> Data? {
    try result.get()
  }
}
