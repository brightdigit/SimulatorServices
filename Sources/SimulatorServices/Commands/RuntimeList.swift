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
  /// - Throws: ``SimCtlError/unreadableOutput(arguments:_:)`` if `simctl`
  ///   printed nothing or JSON that couldn't be decoded.
  public func parse(_ data: Data?) throws(SimCtlError) -> [RuntimeImage] {
    guard let data else {
      throw .unreadableOutput(arguments: arguments, nil)
    }

    let images: [String: RuntimeImage]
    do {
      images = try decoder.decode([String: RuntimeImage].self, from: data)
    } catch let error as DecodingError {
      throw .unreadableOutput(arguments: arguments, error)
    } catch {
      // A component's own decoding error, such as an unexpected identifier.
      throw .unreadableOutput(arguments: arguments, nil)
    }
    return images.values.sorted { $0.identifier.uuidString < $1.identifier.uuidString }
  }
}
