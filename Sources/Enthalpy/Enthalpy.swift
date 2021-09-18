import Foundation
import Length
import Pressure
import RelativeHumidity
import Temperature

public struct Enthalpy: Equatable {

  public var humidity: RelativeHumidity
  public var pressure: Pressure
  public var temperature: Temperature

  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    pressure: Pressure
  ) {
    self.temperature = temperature
    self.humidity = humidity
    self.pressure = pressure
  }

  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.init(
      temperature: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude)
    )
  }

  // Calculate the partial vapor pressure
  // based on parameters set on the instance.
  public var partialPressure: Double {
    // The partial vapor pressure based on the temperature and humidity set on the instance.
    let rankineTemperature = temperature.rankine
    let naturalLog = log(rankineTemperature)
    let exponent =
      -10440.4 / rankineTemperature - 11.29465 - 0.02702235 * rankineTemperature + 1.289036e-5
      * pow(rankineTemperature, 2) - 2.478068e-9 * pow(rankineTemperature, 3) + 6.545967
      * naturalLog

    return humidity.fraction * exp(exponent)
  }

  // Calculate the humidity ratio
  // based on parameters set on the instance.
  public var humidityRatio: Double {
    0.62198 * partialPressure / (pressure.psi - partialPressure)
  }

  // Calculte the enthalpy
  // based on parameters set on the instance.
  public var rawValue: Double {
    let temperature = temperature.fahrenheit
    return 0.24 * temperature + humidityRatio * (1061 + 0.444 * temperature)
  }
}
