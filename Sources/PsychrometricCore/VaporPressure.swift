import Foundation

public struct VaporPressureType {}

public typealias VaporPressure = PressureEnvelope<VaporPressureType>

extension VaporPressure {

  /// Calculates the partial pressure of air for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - units: The unit of measure to solve the pressure for, if not supplied then will default to ``Core.environment`` units.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    let units = units ?? PsychrometricEnvironment.shared.units
    let value =
      SaturationPressure(at: temperature, units: units).pressure.rawValue * humidity.fraction
    self.init(value, units: .defaultFor(units: units))
  }
}
