import Foundation

/// Represents errors thrown for validation reasons.
public struct ValidationError: Error, LocalizedError {

  /// An optional label for the error.
  @usableFromInline
  let label: (any CustomStringConvertible)?

  /// The summary of the error.
  @usableFromInline
  let summary: String

  /// Create a new validation error.
  ///
  /// - Parameters:
  ///   - label: An optional label for the error.
  ///   - summary: The summary of the error.
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
    guard let label = label else { return summary }
    return "\(label.description): \(summary)"
  }

}

extension ValidationError: CustomStringConvertible {
  @inlinable
  public var description: String { debugDescription }
}
