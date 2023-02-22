import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension RelativeHumidity {

  public init(
    dryBulb temperature: Temperature,
    vaporPressure: VaporPressure,
    units: PsychrometricUnits? = nil
  ) async {
    precondition(vaporPressure > 0)

    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let saturationPressure = await SaturationPressure(at: temperature, units: units)
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
  ) async {
    let vaporPressure = VaporPressure(ratio: humidityRatio, pressure: totalPressure, units: units)
    await self.init(dryBulb: temperature, vaporPressure: vaporPressure, units: units)
  }
}
