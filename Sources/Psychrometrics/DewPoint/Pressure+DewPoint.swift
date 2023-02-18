import SharedModels
import Dependencies
import Foundation
import PsychrometricEnvironment

extension DewPoint {

  fileprivate struct DewPointConstantsAboveFreezing {

    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let c6 = 0.1984
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 100.45 : 6.54
      self.c2 = units.isImperial ? 33.193 : 14.526
      self.c3 = units.isImperial ? 2.319 : 0.7389
      self.c4 = units.isImperial ? 0.17074 : 0.09486
      self.c5 = units.isImperial ? 1.2063 : 0.4569
    }

    func run(vaporPressure: VaporPressure) -> Double {
      let P = units.isImperial ? vaporPressure.psi : vaporPressure.pascals / 1000
      let logNatural = log(P)
      return c1
        + c2 * logNatural
        + c3 * pow(logNatural, 2)
        + c4 * pow(logNatural, 3)
        + c5 * pow(P, 0.1984)
    }
  }

  fileprivate struct DewPointConstantsBelowFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 90.12 : 6.09
      self.c2 = units.isImperial ? 26.142 : 12.608
      self.c3 = units.isImperial ? 0.8927 : 0.4959
    }

    func run(vaporPressure: VaporPressure) -> Double {
      let P = units.isImperial ? vaporPressure.psi : vaporPressure.pascals / 1000
      let logNatural = log(P)
      return c1
        + c2 * logNatural
        + c3 * pow(logNatural, 2)
    }
  }

  /// Create a new ``DewPoint`` from the given dry bulb temperature and vapor pressure.
  ///
  /// **Reference**: ASHRAE Handbook - Fundamentals (2017) ch. 1 eqn. 37 and 38
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - pressure: The partial pressure of water vapor in moist air.
  public init(
    dryBulb temperature: Temperature,
    vaporPressure pressure: VaporPressure,
    units: PsychrometricUnits? = nil
  ) {
    @Dependency(\.psychrometricEnvironment) var environment
    
    let units = units ?? environment.units
    let triplePoint = PsychrometricEnvironment.triplePointOfWater(for: units)
    let value =
      temperature <= triplePoint
      ? DewPointConstantsBelowFreezing(units: units).run(vaporPressure: pressure)
      : DewPointConstantsAboveFreezing(units: units).run(vaporPressure: pressure)
    self.init(value, units: .defaultFor(units: units))
  }
}
