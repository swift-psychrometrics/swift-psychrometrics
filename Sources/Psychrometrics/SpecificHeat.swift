import Foundation
import SharedModels
import Tagged

extension SpecificHeat {

  public static func water(temperature: DryBulb) async -> Self {
    let specificHeat =
      1.012481 - 3.079704 * pow(10, -4) * temperature.fahrenheit
      + 1.752657 * pow(pow(10, -6) * temperature.fahrenheit, 2)
      - 2.078224 * pow(pow(10, -9) * temperature.fahrenheit, 3)

    return .fahrenheit(specificHeat)

  }
}
