@testable import SimulatorServices
import XCTest

extension FileHandle {
  convenience init(temporaryFromData data: Data) throws {
    let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try data.write(to: url)
    try self.init(forReadingFrom: url)
  }
}
