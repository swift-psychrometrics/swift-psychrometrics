import Foundation
@_exported import Length
@_exported import Pressure
@_exported import RelativeHumidity
@_exported import Temperature

// TODO: Add units of measure.

/// Represents / calculates the grains of moisture for air.
public struct GrainsOfMoisture: Equatable {

  /// The altitude of the air.
  public var altitude: Length

  /// The temperature of the air.
  public var temperature: Temperature

  /// The relative humidity of the air.
  public var humidity: RelativeHumidity

  /// Constant for the mole weight of water.
  public let moleWeightWater = 18.02

  /// Constant for the mole weight of air.
  public let moleWeightAir = 28.85

  /// The vapor pressure of the air.
  public var vaporPressure: Pressure {
    .vaporPressure(at: temperature)
  }

  /// The ambient pressure of the air.
  public var ambientPressure: Pressure {
    .init(altitude: altitude)
  }

  /// The saturation humidity of the air.
  public var saturationHumidity: Double {
    7000 * (moleWeightWater / moleWeightAir) * vaporPressure.psi
      / (ambientPressure.psi - vaporPressure.psi)
  }

  /// The calculated grains per pound of air.
  public var rawValue: Double {
    saturationHumidity * humidity.fraction
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
  ) {
    self.temperature = temperature
    self.humidity = humidity
    self.altitude = altitude
  }

}

extension Temperature {

  /// Calculates the ``GrainsOfMoisture`` for the temperature at the given humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public func grains(humidity: RelativeHumidity, altitude: Length = .seaLevel) -> GrainsOfMoisture {
    .init(temperature: self, humidity: humidity, altitude: altitude)
  }
}
