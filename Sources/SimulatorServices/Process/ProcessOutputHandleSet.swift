import Foundation

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
internal struct ProcessOutputHandleSet {
  private let output: FileHandle
  private let error: FileHandle

  private var _outputResult: Result<Data?, any Error>?
  private var _errorResult: Result<Data?, any Error>?

  internal var outputResult: Result<Data?, any Error> {
    guard let outputResult = _outputResult else {
      preconditionFailure("Must call readToEnd first.")
    }
    return outputResult
  }

  internal var errorData: Data? {
    guard let errorResult = _errorResult else {
      preconditionFailure("Must call readToEnd first.")
    }

    return try? errorResult.get()
  }

  internal init(output: FileHandle, error: FileHandle) {
    self.output = output
    self.error = error
    _outputResult = nil
    _errorResult = nil
  }

  internal mutating func readToEnd() {
    _outputResult = Result { try output.readToEnd() }
    _errorResult = Result { try error.readToEnd() }
  }
}
