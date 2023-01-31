import XCTest
@testable import SimulatorServices


public class SubcommandTests: XCTestCase {
  func testRecover () {
    
    let expectedError = Process.UncaughtSignalError(reason: Process.TerminationReason.uncaughtSignal, status: 2, standardError: FileHandle.nullDevice, output: nil)!
    let subcommand = MockSubcommand { _ in
      
      throw expectedError
    }
    
    XCTAssertThrowsError(try subcommand.recover(expectedError)) { actualError in
      XCTAssertEqual(actualError as? Process.UncaughtSignalError, expectedError)
    }

    XCTAssertEqual(expectedError.localizedDescription, "Termination Reason: \(Process.TerminationReason.uncaughtSignal) with status: 2")
    XCTAssertEqual(expectedError.errorDescription, "Termination Reason: \(Process.TerminationReason.uncaughtSignal) with status: 2")
  }
}
//import Foundation
//
//#if !os(iOS) && !os(watchOS) && !os(tvOS)
//  /// Subcommand to be run from `simctl`
//  @available(macOS 10.15.4, *)
//  public protocol Subcommand {
//    /// The output type of the subcommand
//    associatedtype OutputType
//
//    /// Arguments to be passed to `simctl`
//    var arguments: [String] { get }
//
//    /// Optional function for recovering from a process error.
//    /// - Parameter error: ``Process/UncaughtSignalError`` received.
//    /// - SeeAlso: ``GetAppContainer/recover(_:)``
//    func recover(_ error: Process.UncaughtSignalError) throws
//
//    /// Convert the data into the desiginated ``OutputType``.
//    /// - Parameter data: Data received from the `simctl`
//    func parse(_ data: Data?) throws -> OutputType
//  }
//
//  @available(macOS 10.15.4, *)
//  extension Subcommand {
//    /// Optional function for recovering from a process error.
//    /// - Parameter error: ``Process/UncaughtSignalError`` received.
//    /// - SeeAlso: ``GetAppContainer/recover(_:)``
//    public func recover(_ error: Process.UncaughtSignalError) throws {
//      throw error
//    }
//  }
//#endifa
