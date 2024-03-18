import Foundation
import OperatingSystemVersion

/// Identifier for a device or runtime.
public typealias Identifier = String

public protocol UnknownRawAvailable {
  associatedtype RawAvailableOptions : RawRepresentable
  
  init(rawOption : RawAvailableOptions)
  static func unknown(_ rawValue: RawAvailableOptions.RawValue) -> Self
}

extension UnknownRawAvailable where Self:Decodable, Self.RawAvailableOptions.RawValue : Decodable {
  public init(from decoder: any Decoder) throws {
    let rawValueString = try decoder.singleValueContainer().decode(RawAvailableOptions.RawValue.self)
    if let rawValue = RawAvailableOptions(rawValue: rawValueString) {
      self.init(rawOption: rawValue)
    } else {
      self = .unknown(rawValueString)
    }
  }
}
/// State for the device
public enum DeviceState: Equatable, Decodable, Sendable, UnknownRawAvailable {
  public init(rawOption: RawAvailableOptions) {
        switch rawOption {
        case .booted:
          self = .booted
        case .shutdown:
          self = .shutdown
        }
  }
  
  public enum RawAvailableOptions: String {
    case booted = "Booted"
    case shutdown = "Shutdown"
  }

  case booted
  case shutdown
  case unknown(String)
  
}

/// State for an Apple Watch and iPhone pair
public enum PairState : Equatable, Decodable, Sendable, UnknownRawAvailable {
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .activeConnected:
      self = .activeConnected
    case .activeDisconnected:
      self = .activeDisconnected
    }
  }
  
  case activeConnected
  case activeDisconnected
  case unknown(String)
  
  public enum RawAvailableOptions : String {
    case activeConnected = "(active, disconnected)"
    case activeDisconnected = "(active, connected)"
  }
  
}

/// Device's product family.
public enum ProductFamily : UnknownRawAvailable, Equatable, Decodable, Sendable {
  
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .iPhone: self = .iPhone
    case .iPad: self = .iPad
    case .appleTV: self = .appleTV
    case .appleWatch: self = .appleWatch
    case .appleVision: self = .appleVision
    }
  }
  
  public enum RawAvailableOptions : String {
    case iPhone = "iPhone"
    
    
    case iPad = "iPad"
    
    
    case appleTV = "Apple TV"
    
    
    case appleWatch = "Apple Watch"
    
    
    case appleVision = "Apple Vision"
  }
  
  case iPhone
case iPad
case appleTV
case appleWatch
case appleVision
  case unknown(String)
}

/// Device platform
public enum Platform : UnknownRawAvailable, Equatable, Decodable, Sendable {
  public init(rawOption: RawAvailableOptions) {
    switch rawOption {
    case .iOS : self = .iOS
    case .tvOS : self = .tvOS
    case .watchOS : self = .watchOS
    case .xrOS : self = .xrOS
    }
  }
  
  case iOS
  case tvOS
  case watchOS
  case xrOS
  case unknown(String)
  
  public enum RawAvailableOptions : String, Sendable {
    case iOS
    case tvOS
    case watchOS
    case xrOS
  }
}


/// Operating System Version
public typealias Version = OperatingSystemVersion

/// Device Model ID
@available(macOS 13.0, *)
public struct ModelID : Decodable, Equatable, Sendable, CustomStringConvertible  {
  internal init(name: ModelID.Name, version: ModelID.Version) {
    self.name = name
    self.version = version
  }
  
  public var description: String {
    return "\(name)\(version.major):\(version.minor)"
  }
  
  public enum Name : String, Sendable {
      case iPhone = "iPhone"
      
      
      case iPad = "iPad"
      
      
      case appleTV = "AppleTV"
      
      
      case appleWatch = "Watch"
      
      
      case appleVision = "RealityDevice"
    
  }
  
  public let name : Name
  public let version : Version
  
  public struct Version : Equatable, Sendable {
    public let major : Int
    public let minor : Int
  }
  
  public init(from decoder: any Decoder) throws {
    let stringValue = try decoder.singleValueContainer().decode(String.self)
    let regex = /(\w+)(\d+),(\d+)/
    guard let match = stringValue.firstMatch(of: regex) else {
      throw DecodingError.dataCorrupted(DecodingError.Context.init(codingPath: [], debugDescription: "String doesn't match pattern"))
    }
    guard let name = Name(rawValue: String(match.1)) else {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown product \(match.1)"))
    }
    guard let major = Int(match.2) else {
      assertionFailure("Invalid major value: \(match.2)")
      throw DecodingError.valueNotFound(Int.self, .init(codingPath: [], debugDescription: "Invalid major value: \(match.2)"))
    }
    guard let minor = Int(match.3) else {
      assertionFailure("Invalid minor value: \(match.3)")
      throw DecodingError.valueNotFound(Int.self, .init(codingPath: [], debugDescription: "Invalid minor value: \(match.3)"))
    }
    self.init(name: name, version: .init(major: major, minor: minor))
  }
  
  
}

/// Device Type Identifier
//public typealias DeviceTypeID = Identifier

/// Runtime ID
public typealias RuntimeID = Identifier

/// Path to the file
public typealias Path = String
