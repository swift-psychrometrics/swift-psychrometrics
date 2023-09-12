import Foundation
import Tagged

/// A type that supports division.
public protocol Divisible {

  /// Divide the values, returning the result.
  static func / (lhs: Self, rhs: Self) -> Self

  /// Divide the value by the rhs value.
  static func /= (lhs: inout Self, rhs: Self)
}

extension Tagged: Divisible where RawValue: Divisible {
  public static func /= (lhs: inout Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) {
    lhs.rawValue /= rhs.rawValue
  }

  public static func / (lhs: Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) -> Tagged<
    Tag, RawValue
  > {
    .init(lhs.rawValue / rhs.rawValue)
  }
}
