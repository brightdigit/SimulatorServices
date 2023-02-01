import Foundation

extension String {
  static func random() -> String {
    UUID().uuidString
  }
}
