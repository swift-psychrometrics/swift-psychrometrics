import Foundation

extension Pressure {

  /// Calculates the partial pressure of air for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  public static func partialPressure(
    for temperature: Temperature,
    at humidity: RelativeHumidity
  ) -> Pressure {
    .psi(Pressure.saturationPressure(at: temperature).psi * humidity.fraction)
  }
}
