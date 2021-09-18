import Foundation
import Length
import Pressure
import Temperature

public struct Density: Equatable {

  var unit: Unit

  init(_ unit: Unit) {
    self.unit = unit
  }

  enum Unit: Equatable {
    case dryAir(Temperature, Pressure)
    case water(Temperature)
  }

  public var rawValue: Double {
    switch unit {

    case let .dryAir(temperature, pressure):
      return ((29.0 * (pressure.psi + 14.7)) / (345.23 * temperature.rankine)) * 32.174

    case let .water(temperature):
      return 62.56 + 3.413 * (pow(10, -4) * temperature.fahrenheit) - 6.255
        * pow((pow(10, -5) * temperature.fahrenheit), 2)
    }
  }

  public static func dryAir(
    at temperature: Temperature, pressure: Pressure = .init(altitude: .seaLevel)
  ) -> Density {
    .init(.dryAir(temperature, pressure))
  }

  public static func dryAir(at temperature: Temperature, altitude: Length) -> Density {
    .init(.dryAir(temperature, .init(altitude: altitude)))
  }

  public static func water(at temperature: Temperature) -> Density {
    .init(.water(temperature))
  }
}

public enum DensityUnit: String, Equatable, Hashable, CaseIterable {
  case dryAir
  case water

  public var label: String {
    switch self {
    case .dryAir:
      return "Dry Air"
    case .water:
      return "Water"
    }
  }
}
