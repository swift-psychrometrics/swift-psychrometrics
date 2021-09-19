import Foundation
import Temperature

extension Pressure {

  /// Calculate the vapor pressure of air at a given temperature.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the vapor pressure of.
  public static func vaporPressure(at temperature: Temperature) -> Pressure {
    let celsius = temperature.celsius
    let exponent = (7.5 * celsius) / (237.3 + celsius)
    let millibar = 6.11 * pow(10, exponent)
    return .millibar(millibar)
  }
}
