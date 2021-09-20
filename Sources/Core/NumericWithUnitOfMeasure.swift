import Foundation

public protocol NumericWithUnitOfMeasure: NumericType {
  associatedtype Units: UnitOfMeasure

  var units: Units { get }

  init(_ value: Double, units: Units)
}

extension NumericWithUnitOfMeasure {

  // Helper to ensure units are set.
  func clone(_ newValue: Double) -> Self {
    .init(newValue, units: units)
  }
}

extension NumericWithUnitOfMeasure where Units: DefaultUnitRepresentable {

  public init(_ value: Double) {
    self.init(value, units: Units.default)
  }

  public static var zero: Self {
    .init(0)
  }
}

extension NumericWithUnitOfMeasure
where Units: DefaultUnitRepresentable, Self: RawRepresentable, RawValue == Double {

  public init?(rawValue: Double) {
    self.init(rawValue)
  }
}

extension NumericWithUnitOfMeasure
where Units: DefaultUnitRepresentable, IntegerLiteralType == Int {

  public init(integerLiteral value: Int) {
    self.init(Double(value))
  }
}

extension NumericWithUnitOfMeasure
where Units: DefaultUnitRepresentable, FloatLiteralType == Double {

  public init(floatLiteral value: Double) {
    self.init(value)
  }
}

extension NumericWithUnitOfMeasure
where Self: RawRepresentable, RawValue == Double, Magnitude == Self {

  public var magnitude: Self {
    clone(rawValue.magnitude)
  }
}

extension NumericWithUnitOfMeasure where Units.Container == Self {

  public subscript(units: Units) -> Double {
    get { self[keyPath: units.keyPath] }
    set { self[keyPath: units.keyPath] = newValue }
  }
}

extension NumericWithUnitOfMeasure
where Units.Container == Self, Self: RawRepresentable, RawValue == Double {

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
