//
//  List.swift
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

internal protocol InternalListDecoder: Sendable {
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

/// Lists  devices, device types, runtimes, and device pairs from `simctl`.
public struct List: Subcommand {
  /// Structure for the list of  devices, device types, runtimes, and device pairs.
  public typealias OutputType = SimulatorList

  /// Errors thrown
  public enum Error: Swift.Error {
    /// No standard output data.
    case missingData
    /// Unable to decode the JSON returned by `simctl`
    case deocdingError(DecodingError)
  }

  @available(macOS 13.0, *)
  private static let decoder: any InternalListDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
    return decoder
  }()

  private let decoder: any InternalListDecoder

  /// Arguments to pass to `simctl`
  public var arguments: [String] { ["list", "-j"] }

  /// Creates the List subcommand.
  @available(macOS 13.0, *)
  public init() { self.init(decoder: Self.decoder) }

  internal init(decoder: any InternalListDecoder) { self.decoder = decoder }

  /// Parses the JSON returned from `simctl`.
  /// - Parameter data: Stanard output from the `simctl` call.
  /// - Returns: A ``SimulatorList`` object containing all the information.
  /// - Throws: ``Error`` if the standard output data is nil
  ///           or the JSON could not be decoded.
  public func parse(_ data: Data?) throws -> SimulatorList {
    guard let data else { throw Error.missingData }

    do {
      return try decoder.decode(SimulatorList.self, from: data)
    } catch let error as DecodingError {
      throw Error.deocdingError(error)
    } catch {
      throw error
    }
  }
}

@available(macOS 13.0, *)
extension JSONDecoder: InternalListDecoder {}
