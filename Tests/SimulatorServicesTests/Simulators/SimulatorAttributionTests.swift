//
//  SimulatorAttributionTests.swift
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

import Testing

@testable import SimulatorServices

@Suite("Simulator attribution")
internal struct SimulatorAttributionTests {
  private struct Runtime: RuntimeIdentifiable, Identifiable, Sendable, Equatable {
    let id: String
    let runtimeIdentifier: RuntimeID
  }

  private struct Simulator: RuntimeIdentifiable, Sendable, Equatable {
    let name: String
    let runtimeIdentifier: RuntimeID
  }

  private static let final = Runtime(
    id: "final", runtimeIdentifier: identifier("iOS-27-0")
  )
  private static let beta = Runtime(
    id: "beta", runtimeIdentifier: identifier("iOS-27-0")
  )
  private static let watch = Runtime(
    id: "watch", runtimeIdentifier: identifier("watchOS-12-0")
  )

  private static let phone = Simulator(
    name: "iPhone 17", runtimeIdentifier: identifier("iOS-27-0")
  )
  private static let pad = Simulator(
    name: "iPad Pro", runtimeIdentifier: identifier("iOS-27-0")
  )
  private static let watchSimulator = Simulator(
    name: "Apple Watch", runtimeIdentifier: identifier("watchOS-12-0")
  )
  private static let orphan = Simulator(
    name: "iPhone 15", runtimeIdentifier: identifier("iOS-17-0")
  )

  private static let attribution = SimulatorAttribution(
    runtimes: [final, beta, watch],
    simulators: [phone, pad, watchSimulator, orphan]
  )

  private static func identifier(_ suffix: String) -> RuntimeID {
    // Fixed suffixes that always parse.
    // swiftlint:disable:next force_try
    try! RuntimeID(suffix: suffix)
  }

  @Test("A beta and its final both list the simulators with their identifier")
  internal func aBetaAndItsFinalBothListTheirSimulators() {
    #expect(Self.attribution.simulators(using: Self.beta) == [Self.phone, Self.pad])
    #expect(Self.attribution.simulators(using: Self.final) == [Self.phone, Self.pad])
    #expect(Self.attribution.simulators(using: Self.watch) == [Self.watchSimulator])
  }

  @Test("Reports the other runtimes that share an identifier")
  internal func reportsTheOtherRuntimesThatShareAnIdentifier() {
    #expect(Self.attribution.runtimesSharingSimulators(with: Self.beta) == [Self.final])
    #expect(Self.attribution.runtimesSharingSimulators(with: Self.final) == [Self.beta])
    #expect(Self.attribution.runtimesSharingSimulators(with: Self.watch).isEmpty)
  }

  @Test("Counts a shared simulator once for each runtime; orphans aren't counted")
  internal func countsASharedSimulatorForEachRuntime() {
    #expect(Self.attribution.simulatorCounts == ["final": 2, "beta": 2, "watch": 1])
  }
}
