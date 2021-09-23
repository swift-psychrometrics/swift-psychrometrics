import Core
import Foundation

extension RelativeHumidity {

  public init(
    dryBulb temperature: Temperature,
    vaporPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    precondition(vaporPressure > 0)
    let units = units ?? environment.units
    let saturationPressure = Pressure.saturationPressure(at: temperature, units: units)
    let vaporPressure = units.isImperial ? vaporPressure.psi : vaporPressure.pascals
    let saturationPressureValue =
      units.isImperial ? saturationPressure.psi : saturationPressure.pascals
    let fraction = vaporPressure / saturationPressureValue
    self.init(fraction * 100)
  }

  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    let vaporPressure = Pressure.init(ratio: humidityRatio, pressure: totalPressure, units: units)
    self.init(dryBulb: temperature, vaporPressure: vaporPressure, units: units)
  }
}
