//
//  VersionedBuild.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

/// A version and build together, ordered newest last.
///
/// The version is compared first, numerically and component by component,
/// then the build. The same ordering is used for installed runtimes and for
/// release-data builds, and it needs no release record, so it works offline.
///
/// "Newer" only means something between betas of the same platform and
/// `X.Y` version. Check ``isSameVersion(as:)`` (and the platform, which this
/// type doesn't carry) before using ``isNewer(than:)`` for supersession.
/// Finals are never ordered this way.
public struct VersionedBuild: Sendable, Hashable, Comparable, CustomStringConvertible {
  /// The OS version, for example `27.2`.
  public let version: VersionNumber
  /// The build, for example `24B5089g`.
  public let build: BuildNumber

  /// `version (build)`, for example `27.2 (24B5089g)`.
  public var description: String {
    "\(version) (\(build))"
  }

  /// Creates a value from an already-parsed version and build.
  public init(version: VersionNumber, build: BuildNumber) {
    self.version = version
    self.build = build
  }

  /// Parses a version string and a build string, as `simctl` reports them.
  ///
  /// Returns `nil` if either doesn't parse.
  public init?(version: some StringProtocol, build: some StringProtocol) {
    guard
      let version = VersionNumber(version),
      let build = BuildNumber(build)
    else {
      return nil
    }
    self.init(version: version, build: build)
  }

  /// Whether `lhs` is older than `rhs`: an earlier version, or the same
  /// version with an earlier build.
  public static func < (lhs: Self, rhs: Self) -> Bool {
    if lhs.version != rhs.version {
      return lhs.version < rhs.version
    }
    return lhs.build < rhs.build
  }

  /// Whether both share the same `X.Y` version key.
  public func isSameVersion(as other: Self) -> Bool {
    version.majorMinor == other.version.majorMinor
  }

  /// Whether this is newer than `other`: a later version, or the same
  /// version with a later build.
  public func isNewer(than other: Self) -> Bool {
    other < self
  }
}
