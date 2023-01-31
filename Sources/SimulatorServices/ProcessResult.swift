import Foundation


internal enum ProcessResult {
  case success(TerminationResult)
  case timedOut(DispatchTime)
}
