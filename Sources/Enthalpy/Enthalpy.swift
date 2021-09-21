import Core
import Foundation
import HumidityRatio

/// Represents / calculates the enthalpy of moist air.
public struct Enthalpy {

  /// The enthalpy of the air based on input state.
  public var rawValue: Double

  public init(_ value: Double) {
    self.rawValue = value
  }

  public init(for temperature: Temperature, humidityRatio: HumidityRatio) {
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
  ///   - pressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    pressure: Pressure
  ) {
    self.init(
      for: temperature,
      humidityRatio: HumidityRatio(for: temperature, with: humidity, at: pressure)
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
