import Core
import Foundation
import HumidityRatio

public struct Enthalpy2<T> {
  
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

public typealias EnthalpyOf<T> = Enthalpy2<T>

/// Represents / calculates the enthalpy of moist air.
public struct Enthalpy {

  /// The enthalpy of the air based on input state.
  public var rawValue: Double

  /// Create a new ``Enthalpy`` for the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw value for the enthalpy.
  public init(_ value: Double) {
    self.rawValue = value
  }

  /// Create a new ``Enthalpy`` for the given temperature and humidity ratio.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the enthalpy for.
  ///   - humidityRatio: The humidity ratio to calculate the enthalpy for.
  public init(
    for temperature: Temperature,
    ratio humidityRatio: HumidityRatio
  ) {
    self.init(
      0.24 * temperature.fahrenheit
        + humidityRatio.rawValue
        * (1061 + 0.444 * temperature.fahrenheit)
    )
  }

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    pressure totalPressure: Pressure
  ) {
    self.init(
      for: temperature,
      ratio: .init(for: temperature, at: humidity, pressure: totalPressure)
    )
  }

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.init(
      for: temperature,
      at: humidity,
      pressure: .init(altitude: altitude)
    )
  }
}

extension Enthalpy: RawNumericType {
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias IntegerLiteralType = Double.IntegerLiteralType

}
