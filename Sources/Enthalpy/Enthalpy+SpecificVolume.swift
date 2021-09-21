import Foundation
import HumidityRatio
import Length
import Pressure
import RelativeHumidity
import Temperature

extension Enthalpy {

  /// Calculate the specific volume for the given temperature, humidity ratio, and total pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature.
  ///   - humidityRatio: The humidity ratio.
  ///   - totalPressure: The total pressure.
  public static func specificVolume(
    for temperature: Temperature,
    humidityRatio: HumidityRatio,
    totalPressure: Pressure
  ) -> Double {
    0.370486
      * temperature.rankine
      * (1 + 1.607858 * humidityRatio.rawValue)
      / totalPressure.psi
  }

  /// Calculate the specific volume for the given temperature, humidity ratio, and total pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature.
  ///   - humidityRatio: The humidity ratio.
  ///   - totalPressure: The total pressure.
  public static func specificVolume(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    altitude: Length
  ) -> Double {
    specificVolume(
      for: temperature,
      humidityRatio: HumidityRatio(for: temperature, with: humidity, at: altitude),
      totalPressure: .init(altitude: altitude)
    )
  }
}
