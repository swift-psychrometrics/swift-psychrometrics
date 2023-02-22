import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

// MARK: - Dry Air
extension SpecificVolume where T == DryAir {

  private struct Constants {
    let units: PsychrometricUnits
    let universalGasConstant: Double

    init(units: PsychrometricUnits) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: Temperature, pressure: Pressure) async -> Double {
      let T = units.isImperial ? dryBulb.rankine : dryBulb.kelvin
      let P = units.isImperial ? pressure.psi : pressure.pascals
      guard units.isImperial else {
        return universalGasConstant * T / P
      }
      return universalGasConstant * T / (144 * P)
    }
  }

  /// Calculate the ``SpecificVolume<DryAir>`` for the given temperature, pressure, and unit of measure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - pressure: The total pressure to calculate the specific volume for.
  ///   - units: The units to calculate the specific volume in.
  public init(
    dryBulb temperature: Temperature,
    pressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let value = await Constants(units: units).run(dryBulb: temperature, pressure: pressure)
    self.init(value, units: .defaultFor(units: units))
  }
}

// MARK: - Moist Air

extension SpecificVolume where T == MoistAir {

  internal struct MoistAirConstants {
    let universalGasConstant: Double
    let c1: Double = 1.607858
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: Temperature, ratio: HumidityRatio, pressure: Pressure) async -> Double {
      let T = units.isImperial ? dryBulb.rankine : dryBulb.kelvin
      let P = units.isImperial ? pressure.psi : pressure.pascals
      let intermediateValue = universalGasConstant * T * (1 + c1 * ratio.rawValue)
      return units.isImperial ? intermediateValue / (144 * P) : intermediateValue / P
    }

    // inverts the calculation to solve for dry-bulb
    func dryBulb(volume: SpecificVolumeOf<MoistAir>, ratio: HumidityRatio, pressure: Pressure)
      async -> Temperature
    {
      let P = units.isImperial ? pressure.psi : pressure.pascals
      let c2 = units.isImperial ? 144.0 : 1.0
      let value = volume.rawValue * (c2 * P) / (universalGasConstant * (1 + c2 * ratio.rawValue))
      return units.isImperial ? .rankine(value) : .kelvin(value)
    }
  }

  /// Calculate the ``SpecificVolume`` for ``Core.MoistAir`` the given temperature,humidity ratio, and total pressure.
  ///
  /// **References**: ASHRAE - Fundamentals (2017) ch. 1 eq. 26
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidityRatio: The humidity ratio to calculate the specific volume for.
  ///   - totalPressure: The total pressure to calculate the specific volume for.
  ///   - units: The unit of measure to solve for, if not supplied then ``Core.environment`` value will be used.
  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    guard humidityRatio.rawValue > 0 else {
      throw ValidationError(
        label: "Specific Volume",
        summary: "Humidity ratio should be greater than 0."
      )
    }
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let value = await MoistAirConstants(units: units)
      .run(dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure)
    self.init(value, units: .defaultFor(units: units))
  }

  /// Calculate the ``SpecificVolume`` for ``Core.MoistAir`` the given temperature,humidity ratio, and total pressure.
  ///
  /// **References**: ASHRAE - Fundamentals (2017) ch. 1 eq. 26
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidity: The relative humidity to calculate the specific volume for.
  ///   - altitude: The altitude to calculate the specific volume for.
  ///   - units: The unit of measure to solve for, if not supplied then ``Core.environment`` value will be used.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      dryBulb: temperature,
      ratio: .init(dryBulb: temperature, pressure: totalPressure),
      pressure: totalPressure,
      units: units
    )
  }

  /// Calculate the ``SpecificVolume`` for ``Core.MoistAir`` the given temperature,humidity ratio, and total pressure.
  ///
  /// **References**: ASHRAE - Fundamentals (2017) ch. 1 eq. 26
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidity: The relative humidity to calculate the specific volume for.
  ///   - altitude: The altitude to calculate the specific volume for.
  ///   - units: The unit of measure to solve for, if not supplied then ``Core.environment`` value will be used.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length,
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      dryBulb: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}
