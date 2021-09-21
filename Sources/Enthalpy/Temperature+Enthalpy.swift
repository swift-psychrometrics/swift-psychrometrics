import Core
import HumidityRatio

extension Temperature {

  /// Calculates the ``Enthalpy`` for the temperature at a given relative humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public func enthalpy(
    at humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) -> Enthalpy {
    .init(for: self, at: humidity, altitude: altitude)
  }

  /// Calculates the ``Enthalpy`` for the temperature at a given relative humidity and pressure.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public func enthalpy(
    at humidity: RelativeHumidity,
    pressure totalPressure: Pressure
  ) -> Enthalpy {
    .init(for: self, at: humidity, pressure: totalPressure)
  }

  /// Calculate the ``Temperature`` for the given enthalpy and humidity ratio.
  ///
  /// - Parameters:
  ///   - enthalpy: The enthalpy to solve the temperature for.
  ///   - humidityRatio: The humidity ration to solve the temperature for.
  public init(
    enthalpy: Enthalpy,
    ratio humidityRatio: HumidityRatio
  ) {
    self = .fahrenheit(
      (enthalpy - (1061 * humidityRatio))
        / (0.444 * humidityRatio + 0.24)
    )
  }
}
