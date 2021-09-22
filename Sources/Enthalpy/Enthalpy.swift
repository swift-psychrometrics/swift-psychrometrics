import Core
import Foundation
import HumidityRatio

public struct Enthalpy<T> {
  
  /// The enthalpy of the air based on input state.
  public private(set) var rawValue: Double
  
  /// The units of measure for the raw value.
  public private(set) var units: EnthalpyUnits

  /// Create a new ``Enthalpy`` for the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw value for the enthalpy.
  ///   - units: The unit of measure for the raw value.
  public init(_ value: Double, units: EnthalpyUnits = .default) {
    self.rawValue = value
    self.units = units
  }
}

public enum EnthalpyUnits: UnitOfMeasure {
  
  public static var `default`: Self = .btuPerPound
  
  case btuPerPound
  case joulePerKilogram
  
  internal static func `for`(_ units: PsychrometricEnvironment.Units) -> Self {
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
  
  public static func keyPath(for units: EnthalpyUnits) -> WritableKeyPath<Enthalpy<T>, Double> {
    \.rawValue
  }
}

public typealias EnthalpyOf<T> = Enthalpy<T>
