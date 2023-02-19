import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension VaporPressure {

  /// Calculates the partial pressure of air for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - relativeHumidity: The relative humidity of the air.
  ///   - units: The unit of measure to solve the pressure for, if not supplied then will default to ``Core.environment`` units.
  public init(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    units: PsychrometricUnits? = nil
  ) {
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let value =
      SaturationPressure(at: temperature, units: units).rawValue.rawValue
      * relativeHumidity.fraction
    self.init(.init(value, units: .defaultFor(units: units)))
  }
}
