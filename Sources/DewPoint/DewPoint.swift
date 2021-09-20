import Core
import Foundation
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the dew-point.
public struct DewPoint {

  public static func calculate(for temperature: Temperature, at humidity: RelativeHumidity)
    -> Temperature
  {
    let naturalLog = log(humidity.fraction)
    let celsius = temperature.celsius
    let value =
      243.04 * (naturalLog + ((17.625 * celsius) / (243.04 + celsius)))
      / (17.625 - naturalLog - ((17.625 * celsius) / (243.04 + celsius)))

    return .celsius(value)
  }

  public var rawValue: Temperature

  /// Creates a new ``DewPoint`` for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature.
  ///   - humidity: The relative humidity.
  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.rawValue = Self.calculate(for: temperature, at: humidity)
    //    self.init(.calculate(temperature, humidity))
  }

  /// Creates a new ``DewPoint`` as the temperaure given.
  ///
  /// - Parameters:
  ///   - temperature: The dew-point temperature to set on the instance.
  public init(_ value: Temperature) {
    self.rawValue = value
  }
}

extension DewPoint: RawNumericType {
  public typealias IntegerLiteralType = Temperature.IntegerLiteralType
  public typealias FloatLiteralType = Temperature.FloatLiteralType
  public typealias Magnitude = Temperature.Magnitude
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
