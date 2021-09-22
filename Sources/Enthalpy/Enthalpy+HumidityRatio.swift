import Core
import Foundation
import HumidityRatio

extension HumidityRatio {

  private struct Constants {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricEnvironment.Units

    init(units: PsychrometricEnvironment.Units) {
      self.units = units
      self.c1 = units == .imperial ? 0.24 : 1.006
      self.c2 = units == .imperial ? 1061 : 2501
      self.c3 = units == .imperial ? 0.444 : 1.86
    }

    func run(enthalpy: EnthalpyOf<MoistAir>, dryBulb: Temperature) -> Double {
      let T = units == .imperial ? dryBulb.fahrenheit : dryBulb.celsius
      let intermediateValue =
        units == .imperial
        ? enthalpy.rawValue - c1 * T
        : enthalpy.rawValue / 1000 - c1 * T

      return intermediateValue / (c2 + c3 * T)
    }
  }

  /// Calculate the ``HumidityRatio`` for the given enthalpy and temperature.
  ///
  /// - Parameters:
  ///   - enthalpy: The enthalpy of the air.
  ///   - temperature: The dry bulb temperature of the air.
  public init(
    enthalpy: EnthalpyOf<MoistAir>,
    dryBulb temperature: Temperature,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    let units = units ?? environment.units
    let value = Constants(units: units).run(enthalpy: enthalpy, dryBulb: temperature)
    self.init(value)
  }
}

extension Enthalpy where T == MoistAir {

  /// Calculate the ``HumidityRatio`` for the given temperature.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature of the air.
  public func humidityRatio(at temperature: Temperature) -> HumidityRatio {
    .init(enthalpy: self, dryBulb: temperature)
  }
}
