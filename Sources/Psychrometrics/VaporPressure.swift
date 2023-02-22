import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

// MARK: - Relative Humidity
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
  ) async throws {
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let value =
      try await SaturationPressure(at: temperature, units: units).rawValue.rawValue
      * relativeHumidity.fraction
    self.init(.init(value, units: .defaultFor(units: units)))
  }
}

// MARK: - Humidity Ratio
extension VaporPressure {

  /// Create a new vapor ``Pressure`` for the given humidity ratio and total pressure.
  ///
  /// - Parameters:
  ///   - humidityRatio: The humidity ratio
  ///   - totalPressure: The total pressure.
  ///   - units: The units of measure, if not supplied this will default to ``Core.environment`` units.
  public init(
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) throws {
    guard humidityRatio > 0 else {
      throw ValidationError(
        label: "Vapor Pressure",
        summary: "Humidity ratio should be greater than 0."
      )
    }
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let totalPressure = units.isImperial ? totalPressure.psi : totalPressure.pascals
    let value =
      totalPressure * humidityRatio.rawValue
      / (HumidityRatio.moleWeightRatio + humidityRatio.rawValue)
    self.init(.init(value, units: .defaultFor(units: units)))
  }
}
