import Foundation
import Tagged

/// Represents relative humidity as a percentage.  These are stored and initialized in their whole number state and you can access
/// the decimal equivalent through the the ``fraction`` property.
///
/// - Note:
///     You typically do not create an instance using the `init` method, but create one using the `postfix` operator.
/// ```
/// let humidity = 50%
/// ```
public typealias RelativeHumidity = Tagged<Relative, Humidity<Relative>>

/// A container for holding onto humidity values.
public struct Humidity<T: HumidityType>: Equatable, Codable, Sendable, RawInitializable {

  /// The relative humidity value.
  public var rawValue: Double

  /// Create a new ``Humidity`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The percentage.
  public init(_ value: Double) {
    self.rawValue = value
  }

  /// Access the underlying raw-value.
  ///
  /// This is useful when it is wrapped in a `Tagged` type.
  ///
  public var value: Double { rawValue }
}

postfix operator %

extension RelativeHumidity {
  /// The relative humidity as a decimal.
  public var fraction: Double {
    rawValue.rawValue / 100
  }

  public static func fraction(_ value: Double) -> Self {
    .init(.init(value * 100))
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
