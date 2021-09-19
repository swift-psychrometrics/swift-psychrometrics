import Foundation
@_exported import Length
@_exported import Pressure
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the enthalpy of moist air.
public struct Enthalpy {

//  public static func partialPressure(for temperature: Temperature, at humidity: RelativeHumidity)
//    -> Double
//  {
//    let rankineTemperature = temperature.rankine
//    let naturalLog = log(rankineTemperature)
//    let exponent =
//      -10440.4 / rankineTemperature - 11.29465 - 0.02702235 * rankineTemperature + 1.289036e-5
//      * pow(rankineTemperature, 2) - 2.478068e-9 * pow(rankineTemperature, 3) + 6.545967
//      * naturalLog
//
//    return humidity.fraction * exp(exponent)
//  }

  /// The humidity ratio of the air.
  public static func humidityRatio(for pressure: Pressure, with partialPressure: Pressure) -> Double {
    0.62198 * partialPressure.psi / (pressure.psi - partialPressure.psi)
  }

  private var input: Input

  private enum Input {
    case raw(Double)
    case calculate(Temperature, RelativeHumidity, Pressure)

    var rawValue: Double {
      switch self {
      case let .raw(value):
        return value
      case let .calculate(temperature, humidity, pressure):
//        let partialPressure = Enthalpy.partialPressure(for: temperature, at: humidity)
        let humidityRatio = Enthalpy.humidityRatio(
          for: pressure,
          with: .partialPressure(for: temperature, at: humidity)
        )
        return 0.24 * temperature.fahrenheit + humidityRatio
          * (1061 + 0.444 * temperature.fahrenheit)
      }
    }
  }

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - pressure: The pressure of the air.
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    pressure: Pressure
  ) {
    self.input = .calculate(temperature, humidity, pressure)
  }

  /// Creates a new ``Enthalpy`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.init(
      temperature: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude)
    )
  }

  public init(_ value: Double) {
    self.input = .raw(value)
  }

  /// The calculated enthalpy of the air.
  public var rawValue: Double {
    get { input.rawValue }
    set { input = .raw(newValue) }
  }
}

extension Enthalpy: Equatable {
  public static func == (lhs: Enthalpy, rhs: Enthalpy) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

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

extension Temperature {

  /// Calculates the enthalpy for the temperature at a given relative humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public func enthalpy(humidity: RelativeHumidity, altitude: Length) -> Enthalpy {
    .init(temperature: self, humidity: humidity, altitude: altitude)
  }

  /// Calculates the enthalpy for the temperature at a given relative humidity and pressure.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - pressure: The pressure of the air.
  public func enthalpy(humidity: RelativeHumidity, pressure: Pressure) -> Enthalpy {
    .init(temperature: self, humidity: humidity, pressure: pressure)
  }
}
