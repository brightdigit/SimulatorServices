//
//  RuntimeList.swift
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

/// Lists simulator runtime images with `simctl runtime list -j`.
public struct RuntimeList: Subcommand {
  /// The runtime images, sorted by identifier.
  public typealias OutputType = [RuntimeImage]

  /// Errors thrown
  public enum Error: Swift.Error {
    /// No standard output data.
    case missingData
    /// Unable to decode the JSON returned by `simctl`
    case decodingError(DecodingError)
  }

  @available(macOS 13.0, *)
  private static let decoder: any InternalListDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
    return decoder
  }()

  private let decoder: any InternalListDecoder

  /// Arguments to pass to `simctl`
  public var arguments: [String] { ["runtime", "list", "-j"] }

  /// Creates the RuntimeList subcommand.
  @available(macOS 13.0, *)
  public init() { self.init(decoder: Self.decoder) }

  internal init(decoder: any InternalListDecoder) { self.decoder = decoder }

  /// Parses the JSON returned from `simctl`.
  ///
  /// `simctl` returns a dictionary keyed by image identifier.
  /// - Parameter data: Standard output from the `simctl` call.
  /// - Returns: The runtime images, sorted by identifier.
  /// - Throws: ``Error`` if the standard output data is nil
  ///           or the JSON could not be decoded.
  public func parse(_ data: Data?) throws -> [RuntimeImage] {
    guard let data else { throw Error.missingData }

    let images: [String: RuntimeImage]
    do {
      images = try decoder.decode([String: RuntimeImage].self, from: data)
    } catch let error as DecodingError {
      throw Error.decodingError(error)
    }
    return images.values.sorted { $0.identifier.uuidString < $1.identifier.uuidString }
  }
}
