import Foundation
import Percentage
@_exported import Temperature

/// Represents relative humidity as a percentage.
///
/// - Note:
///     You typically do not create an instance using the `init` method, but create one using the `postfix` operator.
/// ```
/// let humidity = 50%
/// ```
public struct RelativeHumidity: Equatable {

  private var percentage: Percentage

  /// The relative humidity value.
  public var rawValue: Double {
    get { percentage.rawValue }
    set { percentage = .init(newValue) }
  }

  /// The relative humidity as a decimal.
  public var fraction: Double {
    percentage.fraction
  }

  /// Create a new ``RelativeHumidity`` with the given value.
  ///
  /// - Parameters:
  ///   - rawValue: The percentage.
  public init(_ rawValue: Percentage) {
    self.percentage = rawValue
  }
}

postfix operator %

/// Create a new ``RelativeHumidity`` for the given value.
///
/// - Parameters:
///    - value: The relative humidity value
public postfix func % (value: Double) -> RelativeHumidity {
  RelativeHumidity(Percentage(value))
}

/// Create a new ``RelativeHumidity`` for the given value.
///
/// - Parameters:
///    - value: The relative humidity value
public postfix func % (value: Int) -> RelativeHumidity {
  RelativeHumidity(Percentage(Double(value)))
}

extension RelativeHumidity {

  /// Calculates the relative humidity based on the dry-bulb temperature and dew-point temperatures.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - dewPoint: The dew-point temperature.
  public init(temperature: Temperature, dewPoint: Temperature) {

    let humidity =
      100
      * (exp((17.625 * dewPoint.celsius) / (243.04 + dewPoint.celsius))
        / exp((17.625 * temperature.celsius) / (243.04 + temperature.celsius)))
    self.init(humidity%)
  }
}
