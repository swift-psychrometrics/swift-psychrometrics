import Foundation

public struct SaturationPressureType { }

public typealias SaturationPressure = PressureEnvelope<SaturationPressureType>

// Because of rounding errors and notes in ASHRAE Fundamentals 2017, these are sometimes
// off a little from the tables in the book.

extension SaturationPressure {

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
      self.c1 = units.isImperial ? -1.0214165e4 : -5.6745359e3
      self.c2 = units.isImperial ? -4.8932428 : 6.3925247
      self.c3 = units.isImperial ? -5.3765794e-3 : -9.677843E-03
      self.c4 = units.isImperial ? 1.9202377e-7 : 6.2215701E-07
      self.c5 = units.isImperial ? 3.5575832e-10 : 2.0747825E-09
      self.c6 = units.isImperial ? -9.0344688e-14 : -9.484024E-13
      self.c7 = units.isImperial ? 4.1635019 : 4.1635019
      self.units = units
    }

    fileprivate func exponent(dryBulb temperature: Temperature) -> Double {
      let T = units.isImperial ? temperature.rankine : temperature.kelvin
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
      self.c1 = units.isImperial ? -1.0440397e4 : -5.8002206e03
      self.c2 = units.isImperial ? -1.1294650e1 : 1.3914993
      self.c3 = units.isImperial ? -2.7022355e-2 : -4.8640239e-2
      self.c4 = units.isImperial ? 1.2890360e-5 : 4.1764768e-5
      self.c5 = units.isImperial ? -2.4780681e-9 : -1.4452093e-8
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
  /// Often defined / denoted as `pws`, in the ASHRAE Fundamentels (2017).  These calculations often
  /// do not line up exactly to the tables published in ASHRAE Fundamentals, they are mostly within the
  /// 300 ppm tolerance set forth in the book, however they drift further at very high and very low temperature.
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
  public init(
    at temperature: Temperature,
    units: PsychrometricEnvironment.Units? = nil
  ) {

    let units = units ?? environment.units
    let bounds = environment.pressureBounds(for: units)
    let triplePoint = environment.triplePointOfWater(for: units)

    precondition(
      temperature >= bounds.low && temperature <= bounds.high
    )

    let exponent =
      temperature <= triplePoint
      ? SaturationConstantsBelowFreezing(units: units).exponent(dryBulb: temperature)
      : SaturationConstantsAboveFreezing(units: units).exponent(dryBulb: temperature)

    self.init(exp(exponent), units: .for(units))

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
      temperature >= bounds.low && temperature <= bounds.high
    )

    let derivative =
      temperature <= triplePoint
      ? SaturationConstantsBelowFreezing(units: units).derivative(dryBulb: temperature)
      : SaturationConstantsAboveFreezing(units: units).derivative(dryBulb: temperature)

    return .init(derivative, units: .for(units))
  }
}
//
//extension Pressure {
//  
//  public static func saturationPressure(
//    at temperature: Temperature,
//    units: PsychrometricEnvironment.Units? = nil
//  ) -> SaturationPressure {
//    .init(at: temperature, units: units)
//  }
//}


// MARK: Pressure + RelativeHumidity
extension RelativeHumidity {

  /// Calculates the relative humidity based on the dry-bulb temperature and dew-point temperatures.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - partialPressure: The partial pressure (vapor pressure).
  ///   - units: The units of measure, if not supplied then this defaults to ``Core.environment`` units.
  public init(
    dryBulb temperature: Temperature,
    pressure vaporPressure: VaporPressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    precondition(vaporPressure > 0)
    let units = units ?? environment.units
    let saturationPressure = SaturationPressure(at: temperature, units: units)
    let fraction = vaporPressure.rawValue / saturationPressure.rawValue
    self.init(fraction * 100)
  }
}
