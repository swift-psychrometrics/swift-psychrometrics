import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension RelativeHumidity {

  public init(
    dryBulb temperature: Temperature,
    vaporPressure: VaporPressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    guard vaporPressure > 0 else {
      throw ValidationError(
        label: "Relative Humidity",
        summary: "Vapor pressure should be greater than 0."
      )
    }

    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let saturationPressure = try await SaturationPressure(at: temperature, units: units)
    let vaporPressure = units.isImperial ? vaporPressure.psi : vaporPressure.pascals
    let saturationPressureValue =
      units.isImperial ? saturationPressure.psi : saturationPressure.pascals
    let fraction = vaporPressure / saturationPressureValue
    self.init(.init(fraction * 100))
  }

  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    let vaporPressure = try VaporPressure(ratio: humidityRatio, pressure: totalPressure, units: units)
    try await self.init(dryBulb: temperature, vaporPressure: vaporPressure, units: units)
  }
}

extension RelativeHumidity {

  /// Calculates the relative humidity based on the dry-bulb temperature and dew-point temperatures.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - dewPoint: The dew-point temperature.
  public init(temperature: Temperature, dewPoint: Temperature) async {

    let humidity =
      100
      * (exp((17.625 * dewPoint.celsius) / (243.04 + dewPoint.celsius))
        / exp((17.625 * temperature.celsius) / (243.04 + temperature.celsius)))
    self.init(.init(humidity))
  }
}
