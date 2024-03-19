internal protocol RandomEnum: CaseIterable {
  static func random() -> Self
}

extension RandomEnum {
  internal static func random() -> Self {
    // swiftlint:disable:next force_unwrapping
    allCases.randomElement()!
  }
}
