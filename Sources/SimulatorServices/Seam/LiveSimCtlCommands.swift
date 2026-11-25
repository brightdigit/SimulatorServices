//
//  LiveSimCtlCommands.swift
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

#if os(macOS)

  import Foundation

  /// ``SimCtlCommands`` over ``SimCtl`` (`xcrun simctl`).
  ///
  /// Every call names exactly one item. In particular each runtime is
  /// deleted with its own `simctl runtime delete <id>`: a dry run with two
  /// IDs reported only the first, and one call
  /// per ID keeps partial-success results exact.
  ///
  /// A failed `simctl` call throws ``SimCtlError``, with the
  /// exit status and standard error verbatim.
  ///
  /// The Xcode can change while the app runs (``useDeveloperDirectory(_:)``),
  /// so a call that's already running finishes with the Xcode it started
  /// with, and later calls use the new one.
  ///
  /// It's an actor only to hold the current ``SimCtl``. Each call copies it
  /// and runs outside the actor, so calls don't wait for each other.
  public actor LiveSimCtlCommands: SimCtlCommands {
    private var simCtl: SimCtl

    /// - Parameter developerDirectory: The Xcode whose `simctl` runs, passed
    ///   as `DEVELOPER_DIR`. `nil` uses the one `xcode-select` points to.
    public init(developerDirectory: URL? = nil) {
      simCtl = SimCtl(developerDirectory: developerDirectory)
    }

    private static func result<Value>(
      _ body: () async throws(SimCtlError) -> Value
    ) async -> Result<Value, SimCtlError> {
      do {
        return .success(try await body())
      } catch {
        return .failure(error)
      }
    }

    /// Runs every later call from this Xcode.
    ///
    /// A call that's already running finishes with the Xcode it started with.
    /// - Parameter developerDirectory: The value for `DEVELOPER_DIR`, or
    ///   `nil` to use the one `xcode-select` points to.
    public func useDeveloperDirectory(_ developerDirectory: URL?) {
      simCtl = SimCtl(developerDirectory: developerDirectory)
    }

    /// `simctl runtime list -j` and `simctl list -j`, run at the same time.
    /// - Returns: The runtime images and the device list.
    /// - Throws: ``SimCtlError`` if either call fails.
    public func snapshot() async throws(SimCtlError) -> SimctlSnapshot {
      let simCtl = simCtl
      // Both reads run at once. `async let` would lose the typed error, so
      // each one finishes as a `Result`.
      async let images = Self.result { () async throws(SimCtlError) in
        try await simCtl.run(RuntimeList())
      }
      async let list = Self.result { () async throws(SimCtlError) in
        try await simCtl.run(List())
      }
      return SimctlSnapshot(images: try await images.get(), list: try await list.get())
    }

    /// `simctl boot <udid>`.
    /// - Parameter udid: The simulator to boot.
    /// - Throws: ``SimCtlError`` if `simctl` fails.
    public func boot(_ udid: UUID) async throws(SimCtlError) {
      try await run(Boot(udid))
    }

    /// `simctl shutdown <udid>`.
    /// - Parameter udid: The simulator to shut down.
    /// - Throws: ``SimCtlError`` if `simctl` fails.
    public func shutDown(_ udid: UUID) async throws(SimCtlError) {
      try await run(Shutdown(udid))
    }

    /// `simctl erase <udid>`.
    /// - Parameter udid: The simulator to erase.
    /// - Throws: ``SimCtlError`` if `simctl` fails.
    public func erase(_ udid: UUID) async throws(SimCtlError) {
      try await run(Erase(udid))
    }

    /// `simctl delete <udid>`.
    /// - Parameter udid: The simulator to delete.
    /// - Throws: ``SimCtlError`` if `simctl` fails.
    public func deleteSimulator(
      _ udid: UUID
    ) async throws(SimCtlError) {
      try await run(DeviceDelete(udid))
    }

    /// `simctl runtime delete <id>`, for a ``RuntimeImage/identifier``.
    /// - Parameter id: The runtime image to delete.
    /// - Throws: ``SimCtlError`` if `simctl` fails.
    public func deleteRuntime(_ id: UUID) async throws(SimCtlError) {
      try await run(RuntimeDelete(id))
    }

    private func run<SubcommandType: Subcommand>(
      _ subcommand: SubcommandType
    ) async throws(SimCtlError) where SubcommandType.OutputType == Void {
      let simCtl = simCtl
      try await simCtl.run(subcommand)
    }
  }
#endif
