import SharedModels
import Dependencies
import PsychrometricEnvironment

extension Temperature {

  /// Calculates the ``Enthalpy`` of ``MoistAir`` for the temperature at a given relative humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  ///   - units: The units to solve for, if not supplied then this will default to ``Core.environment`` units.
  public func enthalpy(
    at humidity: RelativeHumidity,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) -> MoistAirEnthalpy {
    .init(dryBulb: self, humidity: humidity, altitude: altitude, units: units)
  }

  /// Calculates the ``Enthalpy`` of ``MoistAir``  for the temperature at a given relative humidity and pressure.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - totalPressure: The pressure of the air.
  ///   - units: The units to solve for, if not supplied then this will default to ``Core.environment`` units.
  public func enthalpy(
    at humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) -> MoistAirEnthalpy {
    .init(dryBulb: self, humidity: humidity, pressure: totalPressure, units: units)
  }

  /// Calculates the ``Enthalpy`` of ``DryAir``  for the temperature.
  ///
  /// - Parameters:
  ///   - units: The units to solve for, if not supplied then this will default to ``Core.environment`` units.
  public func enthalpy(
    units: PsychrometricUnits? = nil
  ) -> DryAirEnthalpy {
    .init(dryBulb: self, units: units)
  }

  /// Calculate the dry bulb``Temperature`` for the given enthalpy and humidity ratio.
  ///
  /// - Parameters:
  ///   - enthalpy: The enthalpy to solve the temperature for.
  ///   - humidityRatio: The humidity ration to solve the temperature for.
  ///   - units: The units to solve for, if not supplied then this will default to ``Core.environment`` units.
  public init(
    enthalpy: MoistAirEnthalpy,
    ratio humidityRatio: HumidityRatio,
    units: PsychrometricUnits? = nil
  ) {
    precondition(humidityRatio.rawValue > 0)
    @Dependency(\.psychrometricEnvironment) var environment
    
    let units = units ?? environment.units
    self = MoistAirEnthalpy.Constants(units: units).dryBulb(
      enthalpy: enthalpy, ratio: humidityRatio)
  }
}
