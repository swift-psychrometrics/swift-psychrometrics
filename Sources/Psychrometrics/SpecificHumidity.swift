import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

// TODO: Add Units

extension SpecificHumidity {

  /// Calculate the specific humidity for the given mass of water and mass of dry air.
  ///
  /// - Parameters:
  ///   - waterMass: The mass of the water content.
  ///   - dryAirMass: The mass of the dry air content.
  public init(
    water waterMass: Double,
    dryAir dryAirMass: Double,
    units: PsychrometricUnits? = nil
  ) {
    @Dependency(\.psychrometricEnvironment) var environment

    self.init(
      waterMass / (waterMass + dryAirMass),
      units: .defaultFor(units: units ?? environment.units)
    )
  }

  /// Calculate the specific humidity for the given humidity ratio.
  ///
  /// - Parameters:
  ///   - ratio: The humidity ratio.
  public init(
    ratio: HumidityRatio,
    units: PsychrometricUnits? = nil
  ) {
    @Dependency(\.psychrometricEnvironment) var environment

    self.init(
      ratio.rawValue / (1 + ratio.rawValue),
      units: .defaultFor(units: units ?? environment.units)
    )
  }

  /// Calculate the specific humidity for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      ratio: HumidityRatio(dryBulb: temperature, humidity: humidity, pressure: totalPressure),
      units: units
    )
  }

  /// Calculate the specific humidity for the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at altitude: Length,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      ratio: HumidityRatio(dryBulb: temperature, humidity: humidity, altitude: altitude),
      units: units
    )
  }
}
