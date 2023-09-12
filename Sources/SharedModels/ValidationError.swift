import Foundation

public struct ValidationError: Error, LocalizedError {

  @usableFromInline
  let label: (any CustomStringConvertible)?

  @usableFromInline
  let summary: String

  @inlinable
  public init(label: (any CustomStringConvertible)? = nil, summary: String) {
    self.label = label
    self.summary = summary
  }

  @inlinable
  public var errorDescription: String? { debugDescription }
}

extension ValidationError: CustomDebugStringConvertible {
  @inlinable
  public var debugDescription: String {
    guard let label else { return summary }
    return "\(label.description): \(summary)"
  }

}

extension ValidationError: CustomStringConvertible {
  @inlinable
  public var description: String { debugDescription }
}
