import Core

extension Temperature {

  /// Calculates the enthalpy for the temperature at a given relative humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public func enthalpy(at humidity: RelativeHumidity, altitude: Length) -> Enthalpy {
    .init(for: self, at: humidity, altitude: altitude)
  }

  /// Calculates the enthalpy for the temperature at a given relative humidity and pressure.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public func enthalpy(at humidity: RelativeHumidity, pressure totalPressure: Pressure) -> Enthalpy
  {
    .init(for: self, at: humidity, pressure: totalPressure)
  }
}
