import Foundation
import Temperature

public struct SpecificHeat: Equatable {

  var unit: Unit

  enum Unit: Equatable {
    case water(Temperature)
  }

  public var rawValue: Temperature {
    switch unit {
    case let .water(temperature):
      let specificHeat =
        1.012481 - 3.079704 * pow(10, -4) * temperature.fahrenheit
        + 1.752657 * pow(pow(10, -6) * temperature.fahrenheit, 2)
        - 2.078224 * pow(pow(10, -9) * temperature.fahrenheit, 3)

      return .fahrenheit(specificHeat)
    }
  }

  public static func water(at temperature: Temperature) -> SpecificHeat {
    .init(unit: .water(temperature))
  }
}
