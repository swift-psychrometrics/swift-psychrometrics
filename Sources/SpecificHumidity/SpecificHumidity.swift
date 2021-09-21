import Core
import Foundation
import HumidityRatio
import Length
import Pressure
import RelativeHumidity

/// Represents the specific humidity of moist air.
public struct SpecificHumidity {

  /// The raw value for the given conditions.
  public var rawValue: Double

  /// Create a new ``SpecificHumidity`` with the given raw value.
  ///
  /// - Parameters:
  ///   - value: The specific humidity value.
  public init(_ value: Double) {
    self.rawValue = value
  }

  /// Calculate the specific humidity for the given mass of water and mass of dry air.
  ///
  /// - Parameters:
  ///   - waterMass: The mass of the water content.
  ///   - dryAirMass: The mass of the dry air content.
  public init(
    water waterMass: Double,
    dryAir dryAirMass: Double
  ) {
    self.init(waterMass / (waterMass + dryAirMass))
  }

  /// Calculate the specific humidity for the given humidity ratio.
  ///
  /// - Parameters:
  ///   - ratio: The humidity ratio.
  public init(
    ratio: HumidityRatio
  ) {
    self.init(ratio.rawValue / (1 + ratio.rawValue))
  }

  /// Calculate the specific humidity for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at totalPressure: Pressure
  ) {
    self.init(
      ratio: HumidityRatio(for: temperature, with: humidity, at: totalPressure)
    )
  }

  /// Calculate the specific humidity for the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at altitude: Length
  ) {
    self.init(
      ratio: HumidityRatio(for: temperature, with: humidity, at: altitude)
    )
  }
}
