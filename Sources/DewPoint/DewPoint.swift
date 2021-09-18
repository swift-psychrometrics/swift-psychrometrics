import Foundation
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the dew-point.
public struct DewPoint: Equatable {

  private var input: Input

  private init(_ input: Input) {
    self.input = input
  }

  /// Creates a new ``DewPoint`` for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature.
  ///   - humidity: The relative humidity.
  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.init(.calculate(temperature, humidity))
  }

  /// Creates a new ``DewPoint`` as the temperaure given.
  ///
  /// - Parameters:
  ///   - temperature: The dew-point temperature to set on the instance.
  public init(temperature: Temperature) {
    self.init(.temperature(temperature))
  }

  /// The dew-point temperature for this instance.
  public var temperature: Temperature {
    input.value
  }

  private enum Input: Equatable {
    case calculate(Temperature, RelativeHumidity)
    case temperature(Temperature)

    var value: Temperature {
      switch self {
      case let .calculate(temperature, humidity):
        let naturalLog = log(humidity.fraction)
        let celsius = temperature.celsius
        let value =
          243.04 * (naturalLog + ((17.625 * celsius) / (243.04 + celsius)))
          / (17.625 - naturalLog - ((17.625 * celsius) / (243.04 + celsius)))

        return .celsius(value)
      case let .temperature(temperature):
        return temperature
      }
    }
  }
}

extension Temperature {

  /// Calculate the ``DewPoint`` of our current value given the humidity.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity to use to calculate the dew-point.
  public func dewPoint(humidity: RelativeHumidity) -> DewPoint {
    .init(temperature: self, humidity: humidity)
  }
}
