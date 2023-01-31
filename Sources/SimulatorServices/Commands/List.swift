#if !os(iOS) && !os(watchOS) && !os(tvOS)
  import Foundation

  protocol _ListDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
  }

  extension JSONDecoder: _ListDecoder {}

  public struct List: Subcommand {
    public typealias OutputType = SimulatorList

    public enum Error: Swift.Error {
      case missingData
      case deocdingError(DecodingError)
    }

    private static let decoder: _ListDecoder = {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
      return decoder
    }()

    private let decoder: _ListDecoder

    public var arguments: [String] {
      ["list", "-j"]
    }

    public init() {
      self.init(decoder: Self.decoder)
    }

    internal init(decoder: _ListDecoder) {
      self.decoder = decoder
    }

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

#endif
