import Foundation
@_exported import RelativeHumidity
@_exported import Temperature

/// Represents / calculates the wet-bulb temperature for the given temperature and relative humidity.
public struct WetBulb {

  fileprivate var input: Input
  
  /// Create a new ``WetBulb`` for the given temperature.
  ///
  /// - Parameters:
  ///    - value: The temperature for the wet bulb.
  public init(_ value: Temperature) {
    self.input = .raw(value)
  }

  /// Create a new ``WetBulb`` for the given temperature and relative humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate wet-bulb for.
  ///   - humidity: The relative humidity.
  public init(temperature: Temperature, humidity: RelativeHumidity) {
    self.input = .calculate(temperature, humidity)
  }

  /// Access the calculated wet-bulb temperature.
  public var temperature: Temperature {
    get { input.rawValue }
    set { input = .raw(newValue) }
  }

  fileprivate enum Input {
    case raw(Temperature)
    case calculate(Temperature, RelativeHumidity)
    
    var rawValue: Temperature {
      switch self {
      case let .raw(value):
        return value
      case let .calculate(temperature, humidity):
        let celsius = temperature.celsius
        let humidity = humidity.rawValue
        let value =
          ((-5.806 + 0.672 * celsius - 0.006 * celsius * celsius
            + (0.061 + 0.004 * celsius + 0.000099 * celsius * celsius) * humidity
            + (-0.000033 - 0.000005 * celsius - 0.0000001 * celsius * celsius)
              * humidity * humidity))
        return .celsius(value)
      }
    }
  }
}

extension WetBulb: Equatable {
  public static func == (lhs: WetBulb, rhs: WetBulb) -> Bool {
    lhs.temperature == rhs.temperature
  }
}

extension WetBulb: Comparable {
  public static func < (lhs: WetBulb, rhs: WetBulb) -> Bool {
    lhs.temperature < rhs.temperature
  }
}

extension WetBulb: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(floatLiteral: Double(value))
  }
}

extension WetBulb: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(Temperature(value))
  }
}

extension WetBulb: AdditiveArithmetic {
  public static func - (lhs: WetBulb, rhs: WetBulb) -> WetBulb {
    .init(lhs.temperature - rhs.temperature)
  }
  
  public static func + (lhs: WetBulb, rhs: WetBulb) -> WetBulb {
    .init(lhs.temperature + rhs.temperature)
  }
}

extension WetBulb: Numeric {
  public init?<T>(exactly source: T) where T : BinaryInteger {
    self.init(floatLiteral: Double(source))
  }
  
  public var magnitude: Temperature.Magnitude {
    temperature.magnitude
  }
  
  public static func * (lhs: WetBulb, rhs: WetBulb) -> WetBulb {
    .init(lhs.temperature * rhs.temperature)
  }
  
  public static func *= (lhs: inout WetBulb, rhs: WetBulb) {
    lhs.temperature *= rhs.temperature
  }

  public typealias Magnitude = Temperature.Magnitude
}

extension Temperature {

  /// Calculate the wet-bulb temperature for the given relative humidity.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity.
  public func wetBulb(humidity: RelativeHumidity) -> WetBulb {
    .init(temperature: self, humidity: humidity)
  }
}
