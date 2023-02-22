import Foundation
import SharedModels
//

/// Represents / calculates the grains of moisture for air.
extension GrainsOfMoisture {

  // TODO: Fix for units.
  public static func saturationHumidity(
    saturationPressure: SaturationPressure,
    totalPressure: Pressure
  ) async -> Double {
    7000 * moleWeightRatio
      * saturationPressure.psi
      / (totalPressure.psi - saturationPressure.psi)
  }

  /// Create a new ``GrainsOfMoisture`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - pressure: The pressure of the air.
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    pressure: Pressure
  ) async throws {
    let saturationHumidity = try await Self.saturationHumidity(
      saturationPressure: SaturationPressure(at: temperature),
      totalPressure: pressure
    )
    self.init(saturationHumidity * humidity.fraction)
  }

  /// Create a new ``GrainsOfMoisture`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) async throws {
    try await self.init(
      temperature: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude)
    )
  }
}

