import Foundation

internal protocol _SimCtlProcess: AnyObject {
  var executableURL: URL? { get set }
  var arguments: [String]? { get set }
  func run(timeout: DispatchTime) async throws -> Data?
}
