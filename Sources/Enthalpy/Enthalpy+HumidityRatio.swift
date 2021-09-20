import Foundation
import Length
import Pressure
import RelativeHumidity
import Temperature

extension Enthalpy {

  /// The humidity ratio of air for the given mass of water and mass of dry air.
  ///
  /// - Parameters:
  ///   - waterMass: The mass of the water in the air.
  ///   - dryAirMass: The mass of the dry air.
  public static func humidityRatio(
    water waterMass: Double,
    dryAir dryAirMass: Double
  ) -> Double {
    0.621945 * (waterMass / dryAirMass)
  }

  /// The  humidity ratio of the air for the given total pressure and partial pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - partialPressure: The partial pressure of the air.
  public static func humidityRatio(
    for totalPressure: Pressure,
    with partialPressure: Pressure
  ) -> Double {
    0.621945 * partialPressure.psi / (totalPressure.psi - partialPressure.psi)
  }

  /// The humidity ratio of the air for the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - altitude: The altitude of the air.
  public static func humidityRatio(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at altitude: Length
  ) -> Double {
    humidityRatio(
      for: .init(altitude: altitude),
      with: .partialPressure(for: temperature, at: humidity)
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public static func humidityRatio(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at totalPressure: Pressure
  ) -> Double {
    humidityRatio(
      for: totalPressure,
      with: .partialPressure(for: temperature, at: humidity)
    )
  }
}
