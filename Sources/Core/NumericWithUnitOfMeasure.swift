import Foundation

public protocol NumericWithUnitOfMeasure: NumericType {

  associatedtype Units: UnitOfMeasure
  associatedtype Number: NumericType

  var rawValue: Number { get }
  var units: Units { get }

  init(_ value: Number, units: Units)
}

extension NumericWithUnitOfMeasure {

  // Internal helper to ensure units are set.
  func clone(_ newValue: Number) -> Self {
    .init(newValue, units: units)
  }
}

extension NumericWithUnitOfMeasure where Units: DefaultUnitRepresentable, Units.Number == Number {

  public init(_ value: Number) {
    self.init(value, units: .default)
  }

  public static var zero: Self {
    .init(Number.zero)
  }
}

extension NumericWithUnitOfMeasure
where
  Units: DefaultUnitRepresentable,
  IntegerLiteralType == Number.IntegerLiteralType,
  Units.Number == Number
{

  public init(integerLiteral value: IntegerLiteralType) {
    self.init(.init(integerLiteral: value))
  }
}

extension NumericWithUnitOfMeasure
where
  Units: DefaultUnitRepresentable,
  FloatLiteralType == Number.FloatLiteralType,
  Units.Number == Number
{

  public init(floatLiteral value: Number.FloatLiteralType) {
    self.init(.init(floatLiteral: value))
  }
}

extension NumericWithUnitOfMeasure where Units.Container == Self, Units.Number == Number {

  public subscript(units: Units) -> Number {
    get { self[keyPath: units.keyPath] }
    set { self[keyPath: units.keyPath] = newValue }
  }
}

extension NumericWithUnitOfMeasure
where Units.Container == Self, Self: RawRepresentable, RawValue == Number, Units.Number == Number {

  public static func + (lhs: Self, rhs: Self) -> Self {
    lhs.clone(lhs.rawValue + rhs[lhs.units])
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    lhs.clone(lhs.rawValue - rhs[lhs.units])
  }

  public static func * (lhs: Self, rhs: Self) -> Self {
    lhs.clone(lhs.rawValue * rhs[lhs.units])
  }
  public static func *= (lhs: inout Self, rhs: Self) {
    lhs = lhs.clone(lhs.rawValue * rhs[lhs.units])
  }

  public static func / (lhs: Self, rhs: Self) -> Self {
    lhs.clone(lhs.rawValue / rhs[lhs.units])
  }

  public static func /= (lhs: inout Self, rhs: Self) {
    lhs = lhs.clone(lhs.rawValue / rhs[lhs.units])
  }

  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs[lhs.units]
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs[lhs.units]
  }
}
