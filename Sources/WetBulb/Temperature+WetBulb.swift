import Core
import Foundation

extension Temperature {

  /// Calculate the wet-bulb temperature for the given relative humidity.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity.
  public func wetBulb(at humidity: RelativeHumidity) -> WetBulb {
    .init(temperature: self, humidity: humidity)
  }
}
