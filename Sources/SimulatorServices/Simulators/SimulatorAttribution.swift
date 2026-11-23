//
//  SimulatorAttribution.swift
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

/// Which simulators use which installed runtime.
///
/// `simctl list -j` groups simulators by runtime identifier
/// (`com.apple.CoreSimulator.SimRuntime.iOS-27-0`), not by disk image. A
/// beta and the final of the same version share that identifier, so
/// `simctl` can't say which of the two images a simulator runs on.
///
/// **Rule:** a simulator uses *every* installed runtime with its
/// identifier. A beta and its final both list it, and ``simulatorCounts``
/// counts it once for each, so the counts can add up to more than the
/// number of simulators. Don't delete a simulator while a runtime with
/// its identifier stays installed.
///
/// `Runtime` is usually ``RuntimeImage`` (or a row type wrapping one);
/// `Simulator` is any type that knows its runtime identifier, such as a
/// ``Device`` paired with the key it's listed under in ``SimulatorList``.
public struct SimulatorAttribution<Runtime, Simulator>: Sendable
where
  Runtime: RuntimeIdentifiable & Identifiable & Sendable,
  Runtime.ID: Sendable,
  Simulator: RuntimeIdentifiable & Sendable
{
  private let runtimes: [Runtime]
  private let simulatorsByIdentifier: [RuntimeID: [Simulator]]

  /// The number of simulators using each installed runtime.
  ///
  /// Simulators whose runtime isn't installed aren't counted.
  public var simulatorCounts: [Runtime.ID: Int] {
    Dictionary(
      runtimes.map { ($0.id, simulators(using: $0).count) },
      uniquingKeysWith: { first, _ in first }
    )
  }

  /// - Parameters:
  ///   - runtimes: The installed runtimes.
  ///   - simulators: Every simulator.
  public init(runtimes: [Runtime], simulators: [Simulator]) {
    self.runtimes = runtimes
    self.simulatorsByIdentifier = Dictionary(
      grouping: simulators,
      by: \.runtimeIdentifier
    )
  }

  /// The simulators that use `runtime`: every simulator with its runtime
  /// identifier.
  public func simulators(using runtime: Runtime) -> [Simulator] {
    simulatorsByIdentifier[runtime.runtimeIdentifier] ?? []
  }

  /// The other installed runtimes with `runtime`'s identifier, whose
  /// simulators it shares.
  public func runtimesSharingSimulators(with runtime: Runtime) -> [Runtime] {
    runtimes.filter {
      $0.id != runtime.id && $0.runtimeIdentifier == runtime.runtimeIdentifier
    }
  }
}
