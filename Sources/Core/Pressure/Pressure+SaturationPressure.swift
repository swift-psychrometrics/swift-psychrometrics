import Foundation

// Because of rounding errors and notes in ASHRAE Fundamentals 2017, these are sometimes
// off a little from the tables in the book.

extension Pressure {

  private struct SaturationConstantsBelowFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let c6: Double
    let c7: Double

    private let units: PsychrometricEnvironment.Units

    init(units: PsychrometricEnvironment.Units) {
      self.c1 = units.isImperial ? -1.0214165e4 : -5.674539e3
      self.c2 = units.isImperial ? -4.8932428 : 6.3925247
      self.c3 = units.isImperial ? -5.3765794e-3 : -9.677843E-03
      self.c4 = units.isImperial ? 1.9202377e-7 : 6.2215701E-07
      self.c5 = units.isImperial ? 3.5575832e-10 : 2.0747825E-09
      self.c6 = units.isImperial ? -9.0344688e-14 : -9.484024E-13
      self.c7 = units.isImperial ? 4.1635019 : 4.1635019
      self.units = units
    }

    fileprivate func exponent(dryBulb temperature: Temperature) -> Double {
      let T = environment.units.isImperial ? temperature.rankine : temperature.kelvin
      return c1 / T
        + c2
        + c3 * T
        + c4 * pow(T, 2)
        + c5 * pow(T, 3)
        + c6 * pow(T, 4)
        + c7 * log(T)
    }

    fileprivate func derivative(dryBulb temperature: Temperature) -> Double {
      let T = units.isImperial ? temperature.rankine : temperature.kelvin
      return (c1 * -1)
        / pow(T, 2)
        + c3
        + 2 * c4 * T
        + 3 * c5 * pow(T, 2)
        - 4 * (c6 * -1) * pow(T, 3)
        + c7 / T
    }
  }

  private struct SaturationConstantsAboveFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let c6: Double

    private let units: PsychrometricEnvironment.Units

    init(units: PsychrometricEnvironment.Units) {
      self.c1 = units.isImperial ? -1.0440397e4 : -5.8002206E+03
      self.c2 = units.isImperial ? -1.1294650e1 : 1.3914993
      self.c3 = units.isImperial ? -2.7022355e-2 : -4.8640239E-02
      self.c4 = units.isImperial ? 1.2890360e-5 : 4.1764768E-05
      self.c5 = units.isImperial ? -2.4780681e-9 : -1.4452093E-08
      self.c6 = units.isImperial ? 6.5459673 : 6.5459673
      self.units = units
    }

    fileprivate func exponent(dryBulb temperature: Temperature) -> Double {
      let T = units.isImperial ? temperature.rankine : temperature.kelvin
      return c1 / T
        + c2
        + c3 * T
        + c4 * pow(T, 2)
        + c5 * pow(T, 3)
        + c6 * log(T)
    }

    fileprivate func derivative(dryBulb temperature: Temperature) -> Double {
      let T = units.isImperial ? temperature.rankine : temperature.kelvin
      return (c1 * -1)
        / pow(T, 2)
        + c3
        + 2 * c4 * T
        - 3 * (c5 * -1) * pow(T, 2)
        + (c6)
        / T
    }
  }

  /// Calculate the saturation pressure of air at a given temperature.
  ///
  /// Often defined / denoted as pws, in the ASHRAE Fundamentels (2017)
  ///
  /// - Note:
  /// The ASHRAE formula are defined above and below the freezing point but have
  /// a discontinuity at the freezing point. This is a small inaccuracy on ASHRAE's part: the formula
  /// should be defined above and below the triple point of water (not the feezing point) in which case
  /// the discontinuity vanishes. It is essential to use the triple point of water otherwise function
  /// DewPoint from vapor pressure, which inverts the present function, does not converge properly around
  /// the freezing point.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the saturation pressure of.
  ///   - units: The unit of measure to solve the pressure for, if not supplied then will default to ``Core.environment`` units.
  public static func saturationPressure(
    at temperature: Temperature,
    units: PsychrometricEnvironment.Units? = nil
  ) -> Pressure {

    let units = units ?? environment.units
    let bounds = environment.pressureBounds(for: units)
    let triplePoint = environment.triplePointOfWater(for: units)

    precondition(
      temperature >= bounds.low && temperature <= bounds.high
    )

    let exponent =
      temperature < triplePoint
      ? SaturationConstantsBelowFreezing(units: units).exponent(dryBulb: temperature)
      : SaturationConstantsAboveFreezing(units: units).exponent(dryBulb: temperature)

    return .init(exp(exponent), units: .for(units))
    //    return units.isImperial
    //      ? .psi(exp(exponent))
    //      : .pascals(exp(exponent))
  }

  /// Helper to calculate the saturation pressure derivative of air at a given temperature.  This is the reverse of
  /// saturation pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the saturation pressure of.
  ///   - units: The unit of measure to solve the pressure for, if not supplied then will default to ``Core.environment`` units.
  public static func saturationPressureDerivative(
    at temperature: Temperature,
    units: PsychrometricEnvironment.Units? = nil
  ) -> Pressure {

    let units = units ?? environment.units
    let bounds = environment.pressureBounds(for: units)
    let triplePoint = environment.triplePointOfWater(for: units)

    precondition(
      temperature > bounds.low && temperature < bounds.high
    )

    let derivative =
      temperature < triplePoint
      ? SaturationConstantsBelowFreezing(units: units).derivative(dryBulb: temperature)
      : SaturationConstantsAboveFreezing(units: units).derivative(dryBulb: temperature)

    return .init(derivative, units: .for(units))
  }
}
