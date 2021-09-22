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
