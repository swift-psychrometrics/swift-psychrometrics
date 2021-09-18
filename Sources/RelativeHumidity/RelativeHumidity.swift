import Foundation
import Percentage
import Temperature

//public typealias RelativeHumidity = Percentage

public struct RelativeHumidity: Equatable {

  private var percentage: Percentage

  public var rawValue: Double {
    get { percentage.rawValue }
    set { percentage = .init(newValue) }
  }

  public var fraction: Double {
    percentage.fraction
  }

  public init(_ rawValue: Percentage) {
    self.percentage = rawValue
  }
}

postfix operator %

public postfix func % (value: Double) -> RelativeHumidity {
  RelativeHumidity(Percentage(value))
}

public postfix func % (value: Int) -> RelativeHumidity {
  RelativeHumidity(Percentage(Double(value)))
}

extension RelativeHumidity {

  /// Calculates the relative humidity based on the dry-bulb temperature and dew-point temperatures.
  public init(temperature: Temperature, dewPoint: Temperature) {

    let humidity =
      100
      * (exp((17.625 * dewPoint.celsius) / (243.04 + dewPoint.celsius))
        / exp((17.625 * temperature.celsius) / (243.04 + temperature.celsius)))
    self.init(humidity%)
  }
}
