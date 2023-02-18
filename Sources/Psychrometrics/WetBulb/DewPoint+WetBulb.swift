import Foundation

extension DewPoint {

  public init(
    dryBulb temperature: Temperature,
    wetBulb: WetBulb,
    pressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    precondition(temperature > wetBulb.temperature)
    let humidityRatio = HumidityRatio(
      dryBulb: temperature,
      wetBulb: wetBulb,
      pressure: pressure,
      units: units
    )
    self.init(dryBulb: temperature, ratio: humidityRatio, pressure: pressure, units: units)
  }
}
