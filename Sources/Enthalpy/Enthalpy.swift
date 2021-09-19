import Foundation
import Length
import Pressure
import RelativeHumidity
import Temperature

/// Represents / calculates the enthalpy of moist air.
public struct Enthalpy {
  
  /// The enthalpy of the air based on input state.
  public var rawValue: Double

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - pressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    pressure: Pressure
  ) {
    self.init(
      0.24 * temperature.fahrenheit
        + Enthalpy.humidityRatio(for: temperature, with: humidity, at: pressure)
        * (1061 + 0.444 * temperature.fahrenheit)
    )
  }

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.init(
      for: temperature,
      at: humidity,
      pressure: .init(altitude: altitude)
    )
  }

  public init(_ value: Double) {
    self.rawValue = value
  }
}

extension Enthalpy: Equatable {
  public static func == (lhs: Enthalpy, rhs: Enthalpy) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

// MARK: - Numeric

extension Enthalpy: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(Double(value))
  }
}

extension Enthalpy: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(value)
  }
}

extension Enthalpy: Comparable {
  public static func < (lhs: Enthalpy, rhs: Enthalpy) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Enthalpy: AdditiveArithmetic {
  public static func - (lhs: Enthalpy, rhs: Enthalpy) -> Enthalpy {
    .init(lhs.rawValue - rhs.rawValue)
  }

  public static func + (lhs: Enthalpy, rhs: Enthalpy) -> Enthalpy {
    .init(lhs.rawValue + rhs.rawValue)
  }
}

extension Enthalpy: Numeric {

  public init?<T>(exactly source: T) where T: BinaryInteger {
    self.init(Double(source))
  }

  public var magnitude: Double.Magnitude {
    rawValue.magnitude
  }

  public static func * (lhs: Enthalpy, rhs: Enthalpy) -> Enthalpy {
    self.init(lhs.rawValue * rhs.rawValue)
  }

  public static func *= (lhs: inout Enthalpy, rhs: Enthalpy) {
    lhs.rawValue *= rhs.rawValue
  }

  public typealias Magnitude = Double.Magnitude
}
