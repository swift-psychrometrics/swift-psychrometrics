import Foundation

/// Represents a number that also has a unit of measure associated with it.  It should have the ability
/// to convert the raw value to a different unit of measure for the type.
public protocol NumericWithUnitOfMeasureRepresentable: NumericType {

  associatedtype Units: UnitOfMeasure
  associatedtype Number: NumericType

  var rawValue: Number { get }
  var units: Units { get }

  init(_ value: Number, units: Units)

  static func keyPath(for units: Units) -> WritableKeyPath<Self, Number>
}

extension NumericWithUnitOfMeasureRepresentable {

  // Internal helper to ensure units are set.
  func cloneUnits(_ newValue: Number) -> Self {
    .init(newValue, units: units)
  }
}

extension NumericWithUnitOfMeasureRepresentable {

  public init(_ value: Number) {
    self.init(value, units: .defaultFor(units: environment.units))
  }

}

extension NumericWithUnitOfMeasureRepresentable {

  public subscript(units: Units) -> Number {
    get { self[keyPath: Self.keyPath(for: units)] }
    set { self[keyPath: Self.keyPath(for: units)] = newValue }
  }
}

extension NumericWithUnitOfMeasureRepresentable
where
  //  Units.Container == Self,
  Self: RawRepresentable,
  RawValue == Number
{

  /// Add the values with the lhs units.
  ///
  /// - SeeAlso: ``AdditiveArithmetic``
  public static func + (lhs: Self, rhs: Self) -> Self {
    lhs.cloneUnits(lhs.rawValue + rhs[lhs.units])
  }

  /// Subtract the values with the lhs units.
  ///
  /// - SeeAlso: ``AdditiveArithmetic``
  public static func - (lhs: Self, rhs: Self) -> Self {
    lhs.cloneUnits(lhs.rawValue - rhs[lhs.units])
  }

  /// Multiply the values with the lhs units.
  ///
  /// - SeeAlso: ``Numeric``
  public static func * (lhs: Self, rhs: Self) -> Self {
    lhs.cloneUnits(lhs.rawValue * rhs[lhs.units])
  }

  /// Multiply the values with the lhs units.
  ///
  /// - SeeAlso: ``Numeric``
  public static func *= (lhs: inout Self, rhs: Self) {
    lhs = lhs.cloneUnits(lhs.rawValue * rhs[lhs.units])
  }

  /// Divide the values with the lhs units.
  ///
  /// - SeeAlso: ``Divisible``
  public static func / (lhs: Self, rhs: Self) -> Self {
    lhs.cloneUnits(lhs.rawValue / rhs[lhs.units])
  }

  /// Divide the values with the lhs units.
  ///
  /// - SeeAlso: ``Divisible``
  public static func /= (lhs: inout Self, rhs: Self) {
    lhs = lhs.cloneUnits(lhs.rawValue / rhs[lhs.units])
  }

  /// Compare the values with the lhs units.
  ///
  /// - SeeAlso: ``Comparable``
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs[lhs.units]
  }

  /// Compare the values with the lhs units.
  ///
  /// - SeeAlso: ``Equatable``
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs[lhs.units]
  }
}

/// Represents a type that is ``NumericWithUnitOfMeasureRepresentable`` and ``RawInitializable``.
public protocol NumberWithUnitOfMeasure: NumericWithUnitOfMeasureRepresentable, RawInitializable {}
