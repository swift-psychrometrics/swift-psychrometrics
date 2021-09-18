import Foundation
@_exported import Length
@_exported import Pressure
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the enthalpy of moist air.
public struct Enthalpy: Equatable {

  /// The relative humidity of the air.
  public var humidity: RelativeHumidity

  /// The pressure of the air.
  public var pressure: Pressure

  /// The temperature of the air.
  public var temperature: Temperature

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - pressure: The pressure of the air.
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    pressure: Pressure
  ) {
    self.temperature = temperature
    self.humidity = humidity
    self.pressure = pressure
  }

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.init(
      temperature: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude)
    )
  }

  /// The partial vapor pressure of the air, based on the temperature and humidity.
  public var partialPressure: Double {
    // The partial vapor pressure based on the temperature and humidity set on the instance.
    let rankineTemperature = temperature.rankine
    let naturalLog = log(rankineTemperature)
    let exponent =
      -10440.4 / rankineTemperature - 11.29465 - 0.02702235 * rankineTemperature + 1.289036e-5
      * pow(rankineTemperature, 2) - 2.478068e-9 * pow(rankineTemperature, 3) + 6.545967
      * naturalLog

    return humidity.fraction * exp(exponent)
  }

  /// The humidity ratio of the air.
  public var humidityRatio: Double {
    // Calculate the humidity ratio
    // based on parameters set on the instance.
    0.62198 * partialPressure / (pressure.psi - partialPressure)
  }

  /// The calculated enthalpy of the air.
  public var rawValue: Double {
    let temperature = temperature.fahrenheit
    return 0.24 * temperature + humidityRatio * (1061 + 0.444 * temperature)
  }
}

extension Temperature {

  /// Calculates the enthalpy for the temperature at a given relative humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public func enthalpy(humidity: RelativeHumidity, altitude: Length) -> Enthalpy {
    .init(temperature: self, humidity: humidity, altitude: altitude)
  }

  /// Calculates the enthalpy for the temperature at a given relative humidity and pressure.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - pressure: The pressure of the air.
  public func enthalpy(humidity: RelativeHumidity, pressure: Pressure) -> Enthalpy {
    .init(temperature: self, humidity: humidity, pressure: pressure)
  }
}
