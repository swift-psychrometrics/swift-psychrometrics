import Foundation
import RelativeHumidity
import Temperature

public struct WetBulb: Equatable {

  public var input: Input

  public init(_ input: Input) {
    self.input = input
  }

  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.input = .init(temperature: temperature, humidity: humidity)
  }

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

  public struct Input: Equatable {
    public var temperature: Temperature
    public var humidity: RelativeHumidity

    public init(temperature: Temperature, humidity: RelativeHumidity) {
      self.temperature = temperature
      self.humidity = humidity
    }
  }
}

extension Temperature {

  public func wetBulb(humidity: RelativeHumidity) -> WetBulb {
    .init(temperature: self, humidity: humidity)
  }
}
