import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension SpecificVolume where T == DryAir {

  private struct Constants {
    let units: PsychrometricUnits
    let universalGasConstant: Double

    init(units: PsychrometricUnits) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: Temperature, pressure: Pressure) -> Double {
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
  ) {
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let value = Constants(units: units).run(dryBulb: temperature, pressure: pressure)
    self.init(value, units: .defaultFor(units: units))
  }
}
