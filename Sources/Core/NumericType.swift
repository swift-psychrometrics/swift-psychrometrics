import Foundation

public protocol NumericType: Divisible, Comparable, ExpressibleByFloatLiteral, Numeric {}

extension Double: NumericType {}

public protocol RawValueInitializable: RawRepresentable {

  init(_ value: RawValue)
}

extension RawValueInitializable {

  public init?(rawValue: RawValue) {
    self.init(rawValue)
  }
}

extension NumericType where Self: RawValueInitializable, Self.RawValue: NumericType {

  public init?<T>(exactly source: T) where T: BinaryInteger {
    guard let rawValue = RawValue.init(exactly: source) else {
      return nil
    }
    self.init(rawValue)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue + rhs.rawValue)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue - rhs.rawValue)
  }

  public static func * (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue * rhs.rawValue)
  }
  public static func *= (lhs: inout Self, rhs: Self) {
    lhs = .init(lhs.rawValue * rhs.rawValue)
  }

  public static func / (lhs: Self, rhs: Self) -> Self {
    .init(lhs.rawValue / rhs.rawValue)
  }

  public static func /= (lhs: inout Self, rhs: Self) {
    lhs = .init(lhs.rawValue / rhs.rawValue)
  }

  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension NumericType
where
  Self: RawValueInitializable,
  RawValue: NumericType,
  Magnitude == RawValue.Magnitude
{

  public var magnitude: Magnitude {
    rawValue.magnitude
  }
}

extension NumericType
where
  Self: RawValueInitializable,
  RawValue: NumericType,
  FloatLiteralType == RawValue.FloatLiteralType
{

  public init(floatLiteral value: FloatLiteralType) {
    self.init(.init(floatLiteral: value))
  }
}

extension NumericType
where
  Self: RawValueInitializable,
  RawValue: NumericType,
  IntegerLiteralType == RawValue.IntegerLiteralType
{

  public init(integerLiteral value: IntegerLiteralType) {
    self.init(.init(integerLiteral: value))
  }
}
