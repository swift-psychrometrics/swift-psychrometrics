import Foundation
import Tagged

/// A container for holding enthalpy values and their unit of measure.
///
public struct Enthalpy: Equatable, Codable, Sendable {

  /// The enthalpy of the air based on input state.
  public private(set) var rawValue: Double

  /// The units of measure for the raw value.
  public private(set) var units: EnthalpyUnits

  /// Create a new ``Enthalpy`` for the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw value for the enthalpy.
  ///   - units: The unit of measure for the raw value.
  public init(_ value: Double, units: EnthalpyUnits) {
    self.rawValue = value
    self.units = units
  }
}

public typealias EnthalpyOf<T> = Tagged<T, Enthalpy>

public enum EnthalpyUnits: String, UnitOfMeasure, Codable, Sendable {

  case btuPerPound = "Btu/lb"
  case joulePerKilogram = "J/kg"

  public static func defaultFor(units: PsychrometricUnits) -> Self {
    switch units {
    case .metric: return .joulePerKilogram
    case .imperial: return .btuPerPound
    }
  }
}

extension Enthalpy: NumberWithUnitOfMeasure {
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias Units = EnthalpyUnits

  public static func keyPath(for units: EnthalpyUnits) -> WritableKeyPath<Enthalpy, Double> {
    \.rawValue
  }
}
