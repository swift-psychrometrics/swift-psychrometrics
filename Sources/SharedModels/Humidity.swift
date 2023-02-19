import Foundation

/// Represents relative humidity as a percentage.  These are stored and initialized in their whole number state and you can access
/// the decimal equivalent through the the ``RelativeHumidity.fraction `` property.
///
/// - Note:
///     You typically do not create an instance using the `init` method, but create one using the `postfix` operator.
/// ```
/// let humidity = 50%
/// ```
public struct Humidity: Equatable, Codable, Sendable, RawInitializable {

  /// The relative humidity value.
  public var rawValue: Double

  /// Create a new ``RelativeHumidity`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The percentage.
  public init(_ value: Double) {
    self.rawValue = value
  }
}

postfix operator %

extension RelativeHumidity {
  /// The relative humidity as a decimal.
  public var fraction: Double {
    rawValue.rawValue / 100
  }
}

/// Create a new ``RelativeHumidity`` for the given value.
///
/// - Parameters:
///    - value: The relative humidity value
public postfix func % (value: Double) -> RelativeHumidity {
  RelativeHumidity(.init(value))
}

/// Create a new ``RelativeHumidity`` for the given value.
///
/// - Parameters:
///    - value: The relative humidity value
public postfix func % (value: Int) -> RelativeHumidity {
  RelativeHumidity(.init(Double(value)))
}

extension Humidity: RawNumericType {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
}

// MARK: - Temperature + RelativeHumidity

// TODO: Move conversions somewhere else.

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
    self.init(.init(humidity))
  }
}
