import Foundation

/// Represents relative humidity as a percentage.  These are stored and initialized in their whole number state and you can access
/// the decimal equivalent through the the ``RelativeHumidity.fraction `` property.
///
/// - Note:
///     You typically do not create an instance using the `init` method, but create one using the `postfix` operator.
/// ```
/// let humidity = 50%
/// ```
public struct RelativeHumidity: Equatable {

  /// The relative humidity value.
  public var rawValue: Double

  /// The relative humidity as a decimal.
  public var fraction: Double {
    rawValue / 100
  }

  /// Create a new ``RelativeHumidity`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The percentage.
  public init(_ value: Double) {
    self.rawValue = value
  }
}

postfix operator %

/// Create a new ``RelativeHumidity`` for the given value.
///
/// - Parameters:
///    - value: The relative humidity value
public postfix func % (value: Double) -> RelativeHumidity {
  RelativeHumidity(value)
}

/// Create a new ``RelativeHumidity`` for the given value.
///
/// - Parameters:
///    - value: The relative humidity value
public postfix func % (value: Int) -> RelativeHumidity {
  RelativeHumidity(Double(value))
}

extension RelativeHumidity: RawNumericType {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
}

// MARK: - Temperature + RelativeHumidity

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
    self.init(humidity)
  }
}
