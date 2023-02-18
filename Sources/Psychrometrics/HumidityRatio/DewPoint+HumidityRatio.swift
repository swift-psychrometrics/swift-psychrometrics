import CoreUnitTypes
import Foundation

extension HumidityRatio {

  /// Create a new ``HumidityRatio`` for the given dew point temperature and atmospheric pressure.
  ///
  ///  - Parameters:
  ///   - dewPoint: The dew point temperature.
  ///   - totalPressure: The total atmospheric pressure
  ///   - units: The units to solve for, if not supplied then ``Core.environment`` units will be used.
  public init(
    dewPoint: DewPoint,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      saturationPressure: SaturationPressure(at: dewPoint.temperature, units: units),
      units: units
    )
  }
}

extension DewPoint {

  /// Create a new ``DewPoint`` for the given dry bulb temperature, humidity ratio, and atmospheric pressure.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - humidityRatio: The humidity ratio.
  ///   - totalPressure: The atmospheric pressure.
  ///   - units: The units to solve for, if not supplied then ``Core.environment`` units will be used.
  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    precondition(humidityRatio > 0)
    self.init(
      dryBulb: temperature,
      vaporPressure: .init(ratio: humidityRatio, pressure: totalPressure),
      units: units
    )
  }
}
