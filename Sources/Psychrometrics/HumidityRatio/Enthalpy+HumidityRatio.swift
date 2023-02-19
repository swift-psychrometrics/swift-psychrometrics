import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension HumidityRatio {

  private struct HumidityRatioConstants {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 0.24 : 1.006
      self.c2 = units.isImperial ? 1061 : 2501
      self.c3 = units.isImperial ? 0.444 : 1.86
    }

    func run(enthalpy: MoistAirEnthalpy, dryBulb: Temperature) -> Double {
      let T = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let intermediateValue =
        units.isImperial
        ? enthalpy.rawValue.rawValue - c1 * T
        : enthalpy.rawValue.rawValue / 1000 - c1 * T

      return intermediateValue / (c2 + c3 * T)
    }
  }

  /// Calculate the ``HumidityRatio`` for the given enthalpy and temperature.
  ///
  /// - Parameters:
  ///   - enthalpy: The enthalpy of the air.
  ///   - temperature: The dry bulb temperature of the air.
  public init(
    enthalpy: MoistAirEnthalpy,
    dryBulb temperature: Temperature,
    units: PsychrometricUnits? = nil
  ) {
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let value = HumidityRatioConstants(units: units).run(enthalpy: enthalpy, dryBulb: temperature)
    self.init(.init(value))
  }
}

extension MoistAirEnthalpy {

  /// Calculate the ``HumidityRatio`` for the given temperature.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature of the air.
  public func humidityRatio(at temperature: Temperature) -> HumidityRatio {
    .init(enthalpy: self, dryBulb: temperature)
  }
}
