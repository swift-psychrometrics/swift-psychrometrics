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

// TODO: This needs moved somewhere else where it can use environment dependency.
public extension NumericWithUnitOfMeasureRepresentable {

  init(_ value: Number) {
    self.init(value, units: .defaultFor(units: .imperial)) // fix.
  }

}

public extension NumericWithUnitOfMeasureRepresentable {

  subscript(units: Units) -> Number {
    get { self[keyPath: Self.keyPath(for: units)] }
    set { self[keyPath: Self.keyPath(for: units)] = newValue }
  }
}

public extension NumericWithUnitOfMeasureRepresentable
  where
  //  Units.Container == Self,
  Self: RawRepresentable,
  RawValue == Number
{

  /// Add the values with the lhs units.
  ///
  /// - SeeAlso: ``AdditiveArithmetic``
  static func + (lhs: Self, rhs: Self) -> Self {
    lhs.cloneUnits(lhs.rawValue + rhs[lhs.units])
  }

  /// Subtract the values with the lhs units.
  ///
  /// - SeeAlso: ``AdditiveArithmetic``
  static func - (lhs: Self, rhs: Self) -> Self {
    lhs.cloneUnits(lhs.rawValue - rhs[lhs.units])
  }

  /// Multiply the values with the lhs units.
  ///
  /// - SeeAlso: ``Numeric``
  static func * (lhs: Self, rhs: Self) -> Self {
    lhs.cloneUnits(lhs.rawValue * rhs[lhs.units])
  }

  /// Multiply the values with the lhs units.
  ///
  /// - SeeAlso: ``Numeric``
  static func *= (lhs: inout Self, rhs: Self) {
    lhs = lhs.cloneUnits(lhs.rawValue * rhs[lhs.units])
  }

  /// Divide the values with the lhs units.
  ///
  /// - SeeAlso: ``Divisible``
  static func / (lhs: Self, rhs: Self) -> Self {
    lhs.cloneUnits(lhs.rawValue / rhs[lhs.units])
  }

  /// Divide the values with the lhs units.
  ///
  /// - SeeAlso: ``Divisible``
  static func /= (lhs: inout Self, rhs: Self) {
    lhs = lhs.cloneUnits(lhs.rawValue / rhs[lhs.units])
  }

  /// Compare the values with the lhs units.
  ///
  /// - SeeAlso: ``Comparable``
  static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs[lhs.units]
  }

  /// Compare the values with the lhs units.
  ///
  /// - SeeAlso: ``Equatable``
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs[lhs.units]
  }
}

/// Represents a type that is ``NumericWithUnitOfMeasureRepresentable`` and ``RawInitializable``.
public protocol NumberWithUnitOfMeasure: NumericWithUnitOfMeasureRepresentable, RawInitializable {}
