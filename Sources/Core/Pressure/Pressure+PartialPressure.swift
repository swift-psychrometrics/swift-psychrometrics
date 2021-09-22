import Foundation

extension Pressure {

  /// Calculates the partial pressure of air for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - units: The unit of measure to solve the pressure for, if not supplied then will default to ``Core.environment`` units.
  public static func partialPressure(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    units: PsychrometricEnvironment.Units? = nil
  ) -> Pressure {
    let units = units ?? environment.units
    let value = Pressure.saturationPressure(at: temperature, units: units)
      .rawValue * humidity.fraction
    return .init(value, units: .for(units))
  }
}
