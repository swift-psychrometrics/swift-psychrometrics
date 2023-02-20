import Foundation
import SharedModels

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
    units: PsychrometricUnits? = nil
  ) async {
    await self.init(
      dryBulb: temperature,
      ratio: .init(
        dryBulb: temperature, humidity: relativeHumidity, pressure: totalPressure, units: units),
      pressure: totalPressure,
      units: units
    )
  }
}
