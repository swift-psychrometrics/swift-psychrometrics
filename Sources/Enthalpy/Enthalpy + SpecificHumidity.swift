import Foundation
import Length
import Pressure
import Temperature

extension Enthalpy {

  /// Calculate the specific humidity for the given mass of water and mass of dry air.
  ///
  /// - Parameters:
  ///   - waterMass: The mass of the water content.
  ///   - dryAirMass: The mass of the dry air content.
  public static func specificHumidity(
    water waterMass: Double,
    dryAir dryAirMass: Double
  ) -> Double {
    waterMass / (waterMass + dryAirMass)
  }

  /// Calculate the specific humidity for the given humidity ratio.
  ///
  /// - Parameters:
  ///   - ratio: The humidity ratio.
  public static func specificHumidity(
    ratio: Double
  ) -> Double {
    ratio / (1 + ratio)
  }

  /// Calculate the specific humidity for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public static func specificHumidity(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at totalPressure: Pressure
  ) -> Double {
    specificHumidity(
      ratio: humidityRatio(for: temperature, with: humidity, at: totalPressure)
    )
  }

  /// Calculate the specific humidity for the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public static func specificHumidity(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at altitude: Length
  ) -> Double {
    specificHumidity(
      ratio: humidityRatio(for: temperature, with: humidity, at: altitude)
    )
  }
}
