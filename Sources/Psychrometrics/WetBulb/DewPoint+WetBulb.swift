import Foundation

extension DewPoint {

  public init(
    dryBulb temperature: Temperature,
    wetBulb: WetBulb,
    pressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    precondition(temperature > wetBulb.rawValue)
    let humidityRatio = await HumidityRatio(
      dryBulb: temperature,
      wetBulb: wetBulb,
      pressure: pressure,
      units: units
    )
    await self.init(
      dryBulb: temperature,
      ratio: humidityRatio,
      pressure: pressure,
      units: units
    )
  }
}
