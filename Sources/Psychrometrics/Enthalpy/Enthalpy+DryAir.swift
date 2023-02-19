import SharedModels
import Dependencies
import Foundation
import PsychrometricEnvironment

extension DryAirEnthalpy {

  private struct DryAirConstants {
    let specificHeat: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.specificHeat = units.isImperial ? 0.24 : 1006
    }

    func run(_ dryBulb: Temperature) -> Double {
      let T = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      return specificHeat * T
    }
  }

  /// Create a new ``Enthalpy`` of ``Core.DryAir`` for the given dry bulb temperature and unit of measure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1 eq 28
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature in °F [IP] or °C [SI].
  ///   - units: The unit of measure, if not supplied then we will resolve from the ``Core.environment`` setting.
  public init(
    dryBulb temperature: Temperature,
    units: PsychrometricUnits? = nil
  ) {
    @Dependency(\.psychrometricEnvironment) var environment
    
    let units = units ?? environment.units
    let value = DryAirConstants(units: units).run(temperature)
    self.init(Enthalpy(value, units: .defaultFor(units: units)))
  }
}
