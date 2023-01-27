#if !os(iOS) && !os(watchOS) && !os(tvOS)
  import Foundation

  public struct List: Subcommand {
    public init() {}

    public var arguments: [String] {
      ["list", "-j"]
    }

    enum Error: Swift.Error {
      case missingData
      case deocdingError(DecodingError)
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

    public typealias OutputType = SimulatorList
    let decoder: JSONDecoder = {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
      return decoder
    }()
  }

#endif
