import Foundation
import Tagged

/// Represents the numeric operations by most of the types the library exposes.  Because a lot of the types also have unit of measure
/// conversions some of the operations are safe given the units are the same.  If the units are not the same, we try to do the right thing
/// and convert them to a unified type based on the units for the left side of the operation.  If you are programatically creating values then
/// it is recommended to work on the underlying raw value of the type.
public protocol NumericType: Codable, Comparable, Divisible, ExpressibleByFloatLiteral, Hashable,
  Numeric, Sendable
{}

/// Adds ``NumericType`` conformance to ``Double``.
extension Double: NumericType {}

public extension NumericType where Self: RawInitializable, RawValue: NumericType {
  init?<T>(exactly source: T) where T: BinaryInteger {
    guard let rawValue = RawValue(exactly: source) else {
      return nil
    }
    self.init(rawValue)
  }

  /// See ``AdditiveArithmetic``.
  static func + (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue + rhs.rawValue)
  }

  /// See ``AdditiveArithmetic``.
  static func - (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue - rhs.rawValue)
  }

  /// See ``Numeric``.
  static func * (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue * rhs.rawValue)
  }

  /// See ``Numeric``.
  static func *= (lhs: inout Self, rhs: Self) {
    lhs = .init(lhs.rawValue * rhs.rawValue)
  }

  /// See ``Divisible``.
  static func / (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue / rhs.rawValue)
  }

  /// See ``Divisible``.
  static func /= (lhs: inout Self, rhs: Self) {
    lhs = .init(lhs.rawValue / rhs.rawValue)
  }

  /// - SeeAlso: ``Comparable``.
  static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }

  /// - SeeAlso: ``Equatable``.
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

public extension NumericType
  where
  Self: RawInitializable,
  RawValue: NumericType,
  Magnitude == RawValue.Magnitude
{
  var magnitude: Magnitude {
    rawValue.magnitude
  }
}

public extension NumericType
  where
  Self: RawInitializable,
  RawValue: NumericType,
  FloatLiteralType == RawValue.FloatLiteralType
{
  init(floatLiteral value: FloatLiteralType) {
    self.init(.init(floatLiteral: value))
  }
}

public extension NumericType
  where
  Self: RawInitializable,
  RawValue: NumericType,
  IntegerLiteralType == RawValue.IntegerLiteralType
{
  init(integerLiteral value: IntegerLiteralType) {
    self.init(.init(integerLiteral: value))
  }
}

/// Represents a type that is both a ``NumericType`` and ``RawInitializable``.
public protocol RawNumericType: NumericType, RawInitializable {}

extension Tagged: NumericType where RawValue: NumericType {}
