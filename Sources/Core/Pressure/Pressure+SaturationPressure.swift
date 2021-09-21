import Foundation

// Because of rounding errors and notes in ASHRAE Fundamentals 2017, these are sometimes
// off a little from the tables in the book.

extension Pressure {

  private static func saturationPressureBelowFreezing(_ temperature: Temperature) -> Double {
    let c1 = -1.0214165e4
    let c2 = -4.8932428
    let c3 = -5.3765794e-3
    let c4 = 1.9202377e-7
    let c5 = 3.5575832e-10
    let c6 = -9.0344688e-14
    let c7 = 4.1635019
    let T = temperature.rankine

    return exp(
      c1 / T + c2 + c3 * T + c4 * pow(T, 2) + c5 * pow(T, 3) + c6 * pow(T, 4) + c7 * log(T)
    )
  }

  private static func saturationPressureAboveFreezing(_ temperature: Temperature) -> Double {
    let c1 = -1.0440397e4
    let c2 = -1.1294650e1
    let c3 = -2.7022355e-2
    let c4 = 1.2890360e-5
    let c5 = -2.4780681e-9
    let c6 = 6.5459673
    let T = temperature.rankine

    return exp(
      c1 / T + c2 + c3 * T + c4 * pow(T, 2) + c5 * pow(T, 3) + c6 * log(T)
    )
  }

  /// Calculate the saturation pressure of air at a given temperature.
  ///
  /// Often defined / denoted as pws, in the ASHRAE Fundamentels (2017)
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the saturation pressure of.
  public static func saturationPressure(at temperature: Temperature) -> Pressure {
    let fahrenheit = temperature.fahrenheit

    precondition(
      fahrenheit >= -148 && fahrenheit <= 392
    )

    let value =
      fahrenheit < 32
      ? saturationPressureBelowFreezing(temperature)
      : saturationPressureAboveFreezing(temperature)

    return .psi(value)
  }
}
