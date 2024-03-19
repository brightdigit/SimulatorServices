import Foundation
import OperatingSystemVersion

/// Operating System Version
public typealias Version = OperatingSystemVersion

extension Version {
  internal static func random() -> Version {
    self.init(
      majorVersion: .random(in: 7 ... 20),
      minorVersion: .random(in: 0 ... 5),
      patchVersion: 0
    )
  }
}
