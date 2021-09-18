import Foundation
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the dew-point.
public struct DewPoint {

  private var input: Input

  private init(_ input: Input) {
    self.input = input
  }

  /// Creates a new ``DewPoint`` for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature.
  ///   - humidity: The relative humidity.
  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.init(.calculate(temperature, humidity))
  }

  /// Creates a new ``DewPoint`` as the temperaure given.
  ///
  /// - Parameters:
  ///   - temperature: The dew-point temperature to set on the instance.
  public init(temperature: Temperature) {
    self.init(.temperature(temperature))
  }

  /// The dew-point temperature for this instance.
  public var temperature: Temperature {
    input.value
  }

  private enum Input {
    case calculate(Temperature, RelativeHumidity)
    case temperature(Temperature)

    var value: Temperature {
      switch self {
      case let .calculate(temperature, humidity):
        let naturalLog = log(humidity.fraction)
        let celsius = temperature.celsius
        let value =
          243.04 * (naturalLog + ((17.625 * celsius) / (243.04 + celsius)))
          / (17.625 - naturalLog - ((17.625 * celsius) / (243.04 + celsius)))

        return .celsius(value)
      case let .temperature(temperature):
        return temperature
      }
    }
  }
}

extension DewPoint: Equatable {
  public static func == (lhs: DewPoint, rhs: DewPoint) -> Bool {
    lhs.temperature == rhs.temperature
  }
}

extension DewPoint: Comparable {
  public static func < (lhs: DewPoint, rhs: DewPoint) -> Bool {
    lhs.temperature < rhs.temperature
  }
}

extension DewPoint: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(temperature: .init(value))
  }
}

extension DewPoint: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(floatLiteral: Double(value))
  }
}

extension DewPoint: AdditiveArithmetic {
  public static func - (lhs: DewPoint, rhs: DewPoint) -> DewPoint {
    .init(temperature: lhs.temperature - rhs.temperature)
  }
  
  public static func + (lhs: DewPoint, rhs: DewPoint) -> DewPoint {
    .init(temperature: lhs.temperature + rhs.temperature)
  }
}

extension DewPoint: Numeric {
  public init?<T>(exactly source: T) where T : BinaryInteger {
    self.init(floatLiteral: Double(source))
  }
  
  public var magnitude: Temperature.Magnitude {
    temperature.magnitude
  }
  
  public static func * (lhs: DewPoint, rhs: DewPoint) -> DewPoint {
    .init(temperature: lhs.temperature * rhs.temperature)
  }
  
  public static func *= (lhs: inout DewPoint, rhs: DewPoint) {
    lhs = .init(temperature: lhs.temperature * rhs.temperature)
  }
  
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
