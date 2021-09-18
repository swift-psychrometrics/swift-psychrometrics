import Foundation
import RelativeHumidity
import Temperature

public struct DewPoint: Equatable {

  private var input: Input

  private init(_ input: Input) {
    self.input = input
  }

  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.init(.calculate(temperature, humidity))
  }

  public init(temperature: Temperature) {
    self.init(.temperature(temperature))
  }

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

  public func dewPoint(humidity: RelativeHumidity) -> DewPoint {
    .init(temperature: self, humidity: humidity)
  }
}
