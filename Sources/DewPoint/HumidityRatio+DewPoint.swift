import Core
import Foundation
import HumidityRatio

extension HumidityRatio {

  public init(
    dewPoint: DewPoint,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      partialPressure: .saturationPressure(at: dewPoint.temperature, units: units)
    )
  }
}

extension DewPoint {

  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    precondition(humidityRatio > 0)
    self.init(
      dryBulb: temperature,
      vaporPressure: .init(ratio: humidityRatio, pressure: totalPressure)
    )
  }
}
