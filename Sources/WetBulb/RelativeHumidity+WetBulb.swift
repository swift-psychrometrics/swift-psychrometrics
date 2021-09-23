import Core
import Foundation
import HumidityRatio

extension WetBulb {

  /// Create a new ``WetBulb`` for the given temperature and relative humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate wet-bulb for.
  ///   - relativeHumidity: The relative humidity.
  ///   - totalPressure: The atmospheric pressure.
  ///   -
  public init?(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    try? self.init(
      dryBulb: temperature,
      ratio: .init(for: temperature, at: relativeHumidity, pressure: totalPressure, units: units),
      pressure: totalPressure,
      units: units
    )
  }
}
