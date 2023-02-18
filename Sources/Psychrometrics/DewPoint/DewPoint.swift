import SharedModels
import Foundation

/// A namespace for a dew-point temperature type.
public struct DewPointType {}

/// Represents a dew-point temperature.
public typealias DewPoint = TemperatureEnvelope<DewPointType>

extension DewPoint {

  /// Creates a new ``DewPoint`` for the given dry bulb temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - relativeHumidity: The relative humidity.
  public init(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      dryBulb: temperature,
      vaporPressure: .init(dryBulb: temperature, humidity: relativeHumidity, units: units),
      units: units
    )
  }
}

extension Temperature {

  /// Calculate the ``DewPoint`` of our current value given the humidity.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity to use to calculate the dew-point.
  public func dewPoint(humidity: RelativeHumidity) -> DewPoint {
    .init(dryBulb: self, humidity: humidity)
  }
}
