//
//  RuntimeImage.swift
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

import Foundation

/// A simulator runtime image from `simctl runtime list -j`.
///
/// Property names match the JSON keys recorded from Xcode 27.1.
public struct RuntimeImage: Decodable, Equatable, Sendable {
  /// The image identifier, which `simctl runtime delete` takes.
  public let identifier: UUID

  /// The runtime version, such as `27.2` or `26.3.1`.
  public let version: String

  /// The runtime build, such as `24B5089g`.
  public let build: String

  /// The runtime identifier, such as `com.apple.CoreSimulator.SimRuntime.iOS-27-2`.
  ///
  /// Patch versions aren't part of it: `26.3.1` has `iOS-26-3`.
  public let runtimeIdentifier: RuntimeID

  /// The platform identifier, such as `com.apple.platform.iphonesimulator`.
  public let platformIdentifier: String

  /// The size `simctl` reports, in bytes.
  ///
  /// For a cryptex image whose `path` is a directory, this is the size of the
  /// directory entry (128 bytes), not of the runtime.
  public let sizeBytes: Int

  /// The state of the image.
  public let state: RuntimeImageState

  /// Whether `simctl` reports the image as deletable.
  ///
  /// Runtimes bundled with Xcode are `false`.
  public let deletable: Bool

  /// The kind of image.
  public let kind: RuntimeImageKind

  /// The path to the image, or to the `.simruntime` bundle for a legacy runtime.
  public let path: Path

  /// The path to the runtime bundle.
  public let runtimeBundlePath: Path?

  /// The path the image is mounted at. Legacy runtimes have none.
  public let mountPath: Path?

  /// The identifier of the parent image, for a cryptex image.
  public let parentIdentifier: UUID?

  /// The path to the parent image, for a cryptex image.
  public let parentImagePath: Path?

  /// The path the parent image is mounted at.
  public let parentMountPath: Path?

  /// The signature state, such as `Verified` or `Unknown`.
  public let signatureState: String?

  /// The architectures the runtime supports, such as `arm64`.
  public let supportedArchitectures: [String]?

  /// When the runtime was last used.
  public let lastUsedAt: Date?

  /// The platform of the runtime.
  public var platform: Platform { runtimeIdentifier.platform }

  /// Whether the runtime is bundled with Xcode.
  public var isBundledWithXcode: Bool { !deletable || kind == .bundledWithXcode }

  /// Whether the runtime is a legacy runtime that isn't a disk image.
  public var isLegacy: Bool { kind == .legacyDownload }

  /// Whether a delete is in progress for this runtime.
  public var isPendingDelete: Bool { state.isPendingDelete }

  /// Whether the runtime can be deleted with `simctl runtime delete`
  /// without admin rights.
  ///
  /// `false` for runtimes bundled with Xcode, legacy runtimes,
  /// images that aren't a known disk image kind, and images already being deleted.
  public var canDelete: Bool {
    deletable && kind.isDiskImage && !isPendingDelete
  }

  /// Creates a runtime image.
  public init(
    identifier: UUID,
    version: String,
    build: String,
    runtimeIdentifier: RuntimeID,
    platformIdentifier: String,
    sizeBytes: Int,
    state: RuntimeImageState,
    deletable: Bool,
    kind: RuntimeImageKind,
    path: Path,
    runtimeBundlePath: Path? = nil,
    mountPath: Path? = nil,
    parentIdentifier: UUID? = nil,
    parentImagePath: Path? = nil,
    parentMountPath: Path? = nil,
    signatureState: String? = nil,
    supportedArchitectures: [String]? = nil,
    lastUsedAt: Date? = nil
  ) {
    self.identifier = identifier
    self.version = version
    self.build = build
    self.runtimeIdentifier = runtimeIdentifier
    self.platformIdentifier = platformIdentifier
    self.sizeBytes = sizeBytes
    self.state = state
    self.deletable = deletable
    self.kind = kind
    self.path = path
    self.runtimeBundlePath = runtimeBundlePath
    self.mountPath = mountPath
    self.parentIdentifier = parentIdentifier
    self.parentImagePath = parentImagePath
    self.parentMountPath = parentMountPath
    self.signatureState = signatureState
    self.supportedArchitectures = supportedArchitectures
    self.lastUsedAt = lastUsedAt
  }
}
