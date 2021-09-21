import Foundation
import Core

/// Represents / calculates the density of dry-air or water.
public struct Density: Equatable {

  var unit: Unit

  init(_ unit: Unit) {
    self.unit = unit
  }

  enum Unit: Equatable {
    case dryAir(Temperature, Pressure)
    case water(Temperature)
  }

  /// The calcuated value based on the input.
  public var rawValue: Double {
    switch unit {

    case let .dryAir(temperature, pressure):
      return ((29.0 * (pressure.psi)) / (345.23 * temperature.rankine)) * 32.174

    case let .water(temperature):
      return 62.56 + 3.413 * (pow(10, -4) * temperature.fahrenheit) - 6.255
        * pow((pow(10, -5) * temperature.fahrenheit), 2)
    }
  }

  /// Create a new ``Density`` for dry-air given a temperature and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - pressure: The pressure of the air.
  public static func dryAir(
    at temperature: Temperature, pressure: Pressure = .init(altitude: .seaLevel)
  ) -> Density {
    .init(.dryAir(temperature, pressure))
  }

  /// Create a new ``Density`` for dry-air given a temperature and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - altitude: The altitude of the air.
  public static func dryAir(at temperature: Temperature, altitude: Length) -> Density {
    .dryAir(at: temperature, pressure: .init(altitude: altitude))
  }

  /// Create a new ``Density`` for water given a temperature.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the water.
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
