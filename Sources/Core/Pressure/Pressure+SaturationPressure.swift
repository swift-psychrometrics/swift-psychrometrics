import Foundation

// Because of rounding errors and notes in ASHRAE Fundamentals 2017, these are sometimes
// off a little from the tables in the book.

extension Pressure {
  
  public struct SaturationConstantsBelowFreezing {
    public let c1: Double
    public let c2: Double
    public let c3: Double
    public let c4: Double
    public let c5: Double
    public let c6: Double
    public let c7: Double
    
    public init(units: PsychrometricEnvironment.Units) {
      self.c1 = units == .imperial ? -1.0214165e4 : -5.674539e3
      self.c2 = units == .imperial ? -4.8932428 : 6.3925247
      self.c3 = units == .imperial ? -5.3765794e-3 : -9.677843E-03
      self.c4 = units == .imperial ? 1.9202377e-7 : 6.2215701E-07
      self.c5 = units == .imperial ? 3.5575832e-10 : 2.0747825E-09
      self.c6 = units == .imperial ? -9.0344688e-14 : -9.484024E-13
      self.c7 = units == .imperial ? 4.1635019 : 4.1635019
    }
  }
  
  public struct SaturationConstantsAboveFreezing {
    public let c1: Double
    public let c2: Double
    public let c3: Double
    public let c4: Double
    public let c5: Double
    public let c6: Double
    
    public init(units: PsychrometricEnvironment.Units) {
      self.c1 = units == .imperial ? -1.0440397e4 : -5.8002206E+03
      self.c2 = units == .imperial ? -1.1294650e1 : 1.3914993
      self.c3 = units == .imperial ? -2.7022355e-2 : -4.8640239E-02
      self.c4 = units == .imperial ? 1.2890360e-5 : 4.1764768E-05
      self.c5 = units == .imperial ? -2.4780681e-9 : -1.4452093E-08
      self.c6 = units == .imperial ? 6.5459673 : 6.5459673
    }
  }

  private static func saturationPressureBelowFreezing(
    _ temperature: Temperature,
    _ units: PsychrometricEnvironment.Units
  ) -> Double {
    let constants = SaturationConstantsBelowFreezing(units: units)
    let T = units == .imperial ? temperature.rankine : temperature.kelvin
    
    return exp(
      constants.c1 / T
      + constants.c2
      + constants.c3 * T
      + constants.c4 * pow(T, 2)
      + constants.c5 * pow(T, 3)
      + constants.c6 * pow(T, 4)
      + constants.c7 * log(T)
    )
  }

  private static func saturationPressureAboveFreezing(
    _ temperature: Temperature,
    _ units: PsychrometricEnvironment.Units
  ) -> Double {
    let constants = SaturationConstantsAboveFreezing(units: units)
    let T = units == .imperial ? temperature.rankine : temperature.kelvin

    return exp(
      constants.c1 / T
      + constants.c2
      + constants.c3 * T
      + constants.c4 * pow(T, 2)
      + constants.c5 * pow(T, 3)
      + constants.c6 * log(T)
    )
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
  public static func saturationPressure(at temperature: Temperature) -> Pressure {
    
    let units = environment.units
    let T = environment.units == .imperial ? temperature.fahrenheit : temperature.celsius
    
    precondition(
      units == .imperial
      ? T >= -148 && T <= 392
      : T > -100 && T < 200
    )

    let value = T < environment.triplePointOfWater.rawValue
      ? saturationPressureBelowFreezing(temperature, units)
      : saturationPressureAboveFreezing(temperature, units)

    return units == .imperial ? .psi(value) : .pascals(value)
  }
}
