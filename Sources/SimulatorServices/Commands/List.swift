import Foundation

internal protocol _ListDecoder : Sendable {
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
  private static let decoder: any _ListDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
    return decoder
  }()

  private let decoder: any _ListDecoder

  /// Arguments to pass to `simctl`
  public var arguments: [String] {
    ["list", "-j"]
  }

  /// Creates the List subcommand.
  @available(macOS 13.0, *)
  public init() {
    self.init(decoder: Self.decoder)
  }

  internal init(decoder: any _ListDecoder) {
    self.decoder = decoder
  }

  /// Parses the JSON returned from `simctl`.
  /// - Parameter data: Stanard output from the `simctl` call.
  /// - Returns: A ``SimulatorList`` object containing all the information.
  /// - Throws: ``Error`` if the standard output data is nil
  ///           or the JSON could not be decoded.
  public func parse(_ data: Data?) throws -> SimulatorList {
    guard let data = data else {
      throw Error.missingData
    }

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
extension JSONDecoder: _ListDecoder {}
