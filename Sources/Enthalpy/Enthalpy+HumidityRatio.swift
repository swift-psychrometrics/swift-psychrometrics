import Foundation
import HumidityRatio
import Temperature

extension HumidityRatio {

  /// Calculate the ``HumidityRatio`` for the given enthalpy and temperature.
  ///
  /// - Parameters:
  ///   - enthalpy: The enthalpy of the air.
  ///   - temperature: The dry bulb temperature of the air.
  public init(enthalpy: Enthalpy, temperature: Temperature) {
    self.init(
      (enthalpy.rawValue - (0.24 * temperature.fahrenheit))
        / (1061 + 0.444 * temperature.fahrenheit)
    )
  }
}

extension Enthalpy {

  /// Calculate the ``HumidityRatio`` for the given temperature.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature of the air.
  public func humidityRatio(at temperature: Temperature) -> HumidityRatio {
    .init(enthalpy: self, temperature: temperature)
  }
}
