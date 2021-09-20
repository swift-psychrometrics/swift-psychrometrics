import Core
import Foundation
import Length
import Pressure
import RelativeHumidity
import Temperature

/// Represents / calculates the enthalpy of moist air.
public struct Enthalpy {

  /// The enthalpy of the air based on input state.
  public var rawValue: Double

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - pressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    pressure: Pressure
  ) {
    self.init(
      0.24 * temperature.fahrenheit
        + Enthalpy.humidityRatio(for: temperature, with: humidity, at: pressure)
        * (1061 + 0.444 * temperature.fahrenheit)
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

  public init(_ value: Double) {
    self.rawValue = value
  }
}

extension Enthalpy: RawValueInitializable, NumericType {

  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias IntegerLiteralType = Double.IntegerLiteralType

}

extension Enthalpy: Equatable {
  public static func == (lhs: Enthalpy, rhs: Enthalpy) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}
