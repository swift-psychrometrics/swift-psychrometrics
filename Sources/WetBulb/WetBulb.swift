import Foundation
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the wet-bulb temperature for the given temperature and relative humidity.
public struct WetBulb: Equatable {

  fileprivate var input: Input

  fileprivate init(_ input: Input) {
    self.input = input
  }

  /// Create a new ``WetBulb`` for the given temperature and relative humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate wet-bulb for.
  ///   - humidity: The relative humidity.
  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.init(.init(temperature: temperature, humidity: humidity))
  }

  /// Access the calculated wet-bulb temperature.
  public var temperature: Temperature {
    let celsius = input.temperature.celsius
    let humidity = input.humidity.rawValue

    let value =
      ((-5.806 + 0.672 * celsius - 0.006 * celsius * celsius
        + (0.061 + 0.004 * celsius + 0.000099 * celsius * celsius) * humidity
        + (-0.000033 - 0.000005 * celsius - 0.0000001 * celsius * celsius)
          * humidity * humidity))

    return .celsius(value)
  }

  fileprivate struct Input: Equatable {
    public var temperature: Temperature
    public var humidity: RelativeHumidity

    public init(temperature: Temperature, humidity: RelativeHumidity) {
      self.temperature = temperature
      self.humidity = humidity
    }
  }
}

extension Temperature {

  /// Calculate the wet-bulb temperature for the given relative humidity.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity.
  public func wetBulb(humidity: RelativeHumidity) -> WetBulb {
    .init(temperature: self, humidity: humidity)
  }
}
