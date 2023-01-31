//
//  File.swift
//  
//
//  Created by Leo Dion on 1/30/23.
//

import Foundation


internal protocol ProcessProtocol : AnyObject {
  var executableURL: URL? { set get }
  var arguments: [String]? { set get }
  func run(timeout: DispatchTime) async throws -> Data?
}

internal protocol ProcessSync : AnyObject {
  
}
