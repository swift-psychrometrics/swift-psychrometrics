import Foundation

public struct MaxIterationError: Error {
  let message: String

  public init(_ message: String) {
    self.message = message
  }
}
