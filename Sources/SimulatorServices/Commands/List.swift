import Foundation

internal protocol _ListDecoder {
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

// TODO: add documentation
/// <#Description#>
public struct List: Subcommand {
  // TODO: add documentation
  public typealias OutputType = SimulatorList

  // TODO: add documentation
  public enum Error: Swift.Error {
    // TODO: add documentation
    case missingData
    // TODO: add documentation
    case deocdingError(DecodingError)
  }

  private static let decoder: _ListDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
    return decoder
  }()

  private let decoder: _ListDecoder

  // TODO: add documentation
  public var arguments: [String] {
    ["list", "-j"]
  }

  // TODO: add documentation
  public init() {
    self.init(decoder: Self.decoder)
  }

  internal init(decoder: _ListDecoder) {
    self.decoder = decoder
  }

  // TODO: add documentation
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

extension JSONDecoder: _ListDecoder {}
