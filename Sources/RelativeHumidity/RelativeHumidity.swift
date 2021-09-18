import Foundation
@_exported import Temperature

/// Represents relative humidity as a percentage.
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

extension RelativeHumidity: AdditiveArithmetic {
  public static func - (lhs: RelativeHumidity, rhs: RelativeHumidity) -> RelativeHumidity {
    .init(lhs.rawValue - rhs.rawValue)
  }

  public static func + (lhs: RelativeHumidity, rhs: RelativeHumidity) -> RelativeHumidity {
    .init(lhs.rawValue + rhs.rawValue)
  }

  public static var zero: RelativeHumidity {
    .init(0)
  }
}

extension RelativeHumidity: Comparable {
  public static func < (lhs: RelativeHumidity, rhs: RelativeHumidity) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension RelativeHumidity: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: Int) {
    self.init(Double(value))
  }
}

extension RelativeHumidity: ExpressibleByFloatLiteral {

  public init(floatLiteral value: Double) {
    self.init(value)
  }
}

extension RelativeHumidity: Numeric {
  public init?<T>(exactly source: T) where T: BinaryInteger {
    self.init(Double(source))
  }

  public var magnitude: Double.Magnitude {
    rawValue.magnitude
  }

  public static func * (lhs: RelativeHumidity, rhs: RelativeHumidity) -> RelativeHumidity {
    .init(lhs.rawValue * rhs.rawValue)
  }

  public static func *= (lhs: inout RelativeHumidity, rhs: RelativeHumidity) {
    lhs.rawValue *= rhs.rawValue
  }

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
