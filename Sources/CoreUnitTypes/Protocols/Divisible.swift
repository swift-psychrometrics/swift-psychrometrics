import Foundation

/// A type that supports division.
public protocol Divisible {

  /// Divide the values, returning the result.
  static func / (lhs: Self, rhs: Self) -> Self

  /// Divide the value by the rhs value.
  static func /= (lhs: inout Self, rhs: Self)
}
