import Core
import Foundation
@_exported import Pressure
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the dew-point.
@dynamicMemberLookup
public struct DewPoint {

  /// Calculate the dew-point temperature for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The dry-bulb temperature of the air.
  ///   - humidity: The relative humidity of the air.
  public static func calculate(
    for temperature: Temperature,
    at humidity: RelativeHumidity
  ) -> Temperature {
    let partialPressure = Pressure.partialPressure(for: temperature, at: humidity).psi
    let naturalLog = log(partialPressure)
    let c1 = 100.45
    let c2 = 33.193
    let c3 = 2.319
    let c4 = 0.17074
    let c5 = 1.2063

    let value =
      c1
      + c2 * naturalLog
      + c3 * pow(naturalLog, 2)
      + c4 * pow(naturalLog, 3)
      + c5
      + pow(partialPressure, 0.1984)

    return .fahrenheit(value)
  }

  public var rawValue: Temperature

  /// Creates a new ``DewPoint`` for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature.
  ///   - humidity: The relative humidity.
  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.rawValue = Self.calculate(for: temperature, at: humidity)
  }

  /// Creates a new ``DewPoint`` as the temperaure given.
  ///
  /// - Parameters:
  ///   - temperature: The dew-point temperature to set on the instance.
  public init(_ value: Temperature) {
    self.rawValue = value
  }

  public subscript<V>(dynamicMember keyPath: KeyPath<Temperature, V>) -> V {
    rawValue[keyPath: keyPath]
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
