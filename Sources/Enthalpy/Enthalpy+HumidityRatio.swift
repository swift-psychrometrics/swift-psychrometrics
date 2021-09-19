import Foundation
import Length
import Pressure
import RelativeHumidity
import Temperature

extension Enthalpy {

  /// The humidity ratio of the air.
  public static func humidityRatio(
    for totalPressure: Pressure,
    with partialPressure: Pressure
  ) -> Double {
    0.62198 * partialPressure.psi / (totalPressure.psi - partialPressure.psi)
  }

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
