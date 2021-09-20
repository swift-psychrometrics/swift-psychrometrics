import Core
import Foundation
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the wet-bulb temperature for the given temperature and relative humidity.
public struct WetBulb {

  private static func calculate(_ temperature: Temperature, _ humidity: RelativeHumidity)
    -> Temperature
  {
    let celsius = temperature.celsius
    let humidity = humidity.rawValue
    let value =
      ((-5.806 + 0.672 * celsius - 0.006 * celsius * celsius
        + (0.061 + 0.004 * celsius + 0.000099 * celsius * celsius) * humidity
        + (-0.000033 - 0.000005 * celsius - 0.0000001 * celsius * celsius)
          * humidity * humidity))
    return .celsius(value)
  }

  public var rawValue: Temperature

  //  fileprivate var input: Input

  /// Create a new ``WetBulb`` for the given temperature.
  ///
  /// - Parameters:
  ///    - value: The temperature for the wet bulb.
  public init(_ value: Temperature) {
    self.rawValue = value
  }

  /// Create a new ``WetBulb`` for the given temperature and relative humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate wet-bulb for.
  ///   - humidity: The relative humidity.
  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.rawValue = Self.calculate(temperature, humidity)
  }
}

extension WetBulb: RawValueInitializable, NumericType {

  public typealias FloatLiteralType = Temperature.FloatLiteralType
  public typealias Magnitude = Temperature
  public typealias IntegerLiteralType = Temperature.IntegerLiteralType
}

extension Temperature {

  /// Calculate the wet-bulb temperature for the given relative humidity.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity.
  public func wetBulb(at humidity: RelativeHumidity) -> WetBulb {
    .init(temperature: self, humidity: humidity)
  }
}
