import Core
import Foundation

extension SpecificVolume2 where T == DryAir {

  private struct Constants {
    let units: PsychrometricEnvironment.Units
    let universalGasConstant: Double

    init(units: PsychrometricEnvironment.Units) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: Temperature, pressure: Pressure) -> Double {
      let T = units == .imperial ? dryBulb.rankine : dryBulb.kelvin
      let P = units == .imperial ? pressure.psi : pressure.pascals
      guard units == .imperial else {
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
    units: PsychrometricEnvironment.Units? = nil
  ) {
    let units = units ?? environment.units
    let value = Constants(units: units).run(dryBulb: temperature, pressure: pressure)
    self.init(value, units: .for(units))
  }
}
