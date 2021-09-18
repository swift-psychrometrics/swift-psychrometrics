import Foundation

/// Represents / calculates temperature in SI and IP units as well as scientific / absolute units.
public struct Temperature: Equatable, Hashable {
  
  public static var defaultUnits: TemperatureUnit = .fahrenheit
  
  public private(set) var rawValue: Double
  public private(set) var units: TemperatureUnit
  
  
  public init(_ value: Double, units: TemperatureUnit = Self.defaultUnits) {
    self.rawValue = value
    self.units = units
  }
}

extension Temperature {

  /// Create a new ``Temperature`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The celsius value of the temperature.
  public static func celsius(_ value: Double) -> Temperature {
    .init(value, units: .celsius)
  }

  /// Create a new ``Temperature`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The fahrenheit value of the temperature.
  public static func fahrenheit(_ value: Double) -> Temperature {
    .init(value, units: .fahrenheit)
  }

  /// Create a new ``Temperature`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The kelvin value of the temperature.
  public static func kelvin(_ value: Double) -> Temperature {
    .init(value, units: .kelvin)
  }

  /// Create a new ``Temperature`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The rankine value of the temperature.
  public static func rankine(_ value: Double) -> Temperature {
    .init(value, units: .rankine)
  }
}

extension Temperature {

  /// Access / calculate the temperatre in celsius.
  public var celsius: Double {
    get {
      switch units {
      case .celsius:
        return rawValue
      case .fahrenheit:
        return (rawValue - 32) * 5 / 9
      case .kelvin:
        return rawValue - 273.15
      case .rankine:
        return (rawValue - 491.67) * 5 / 9
      }
    }
    set {
      self = .celsius(newValue)
    }
  }

  /// Access / calculate the temperatre in fahrenheit.
  public var fahrenheit: Double {
    get {
      switch units {
      case .celsius:
        return rawValue * 9 / 5 + 32
      case .fahrenheit:
        return rawValue
      case .kelvin:
        return rawValue * 9 / 5 - 459.67
      case .rankine:
        return rawValue - 459.67
      }
    }
    set {
      self = .fahrenheit(newValue)
    }
  }

  /// Access / calculate the temperatre in kelvin.
  public var kelvin: Double {
    get {
      switch units {
      case .celsius, .rankine:
        return Temperature.fahrenheit(self.fahrenheit).kelvin
      case .fahrenheit:
        return (rawValue + 459.67) * 5 / 9
      case .kelvin:
        return rawValue
      }
    }
    set {
      self = .kelvin(newValue)
    }
  }

  /// Access / calculate the temperatre in rankine.
  public var rankine: Double {
    get {
      switch units {
      case .celsius, .kelvin:
        return Temperature.fahrenheit(self.fahrenheit).rankine
      case .fahrenheit:
        return rawValue + 459.67
      case .rankine:
        return rawValue
      }
    }
    set {
      self = .rankine(newValue)
    }
  }
}

extension Temperature: AdditiveArithmetic {

  public static func - (lhs: Temperature, rhs: Temperature) -> Temperature {
    let value = lhs.rawValue - rhs[keyPath: lhs.units.temperatureKeyPath]
    return .init(value, units: lhs.units)
  }

  public static func + (lhs: Temperature, rhs: Temperature) -> Temperature {
    let value = lhs.rawValue + rhs[keyPath: lhs.units.temperatureKeyPath]
    return .init(value, units: lhs.units)
  }

  public static var zero: Temperature {
    .init(0)
  }
}

extension Temperature: Comparable {
  public static func < (lhs: Temperature, rhs: Temperature) -> Bool {
    lhs.rawValue < rhs[keyPath: lhs.units.temperatureKeyPath]
  }
}

extension Temperature: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(Double(value))
  }
}

extension Temperature: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(value)
  }
}

extension Temperature: Numeric {

  public init?<T>(exactly source: T) where T: BinaryInteger {
    self.init(floatLiteral: Double(source))
  }

  public var magnitude: Double.Magnitude {
    rawValue.magnitude
  }

  public static func * (lhs: Temperature, rhs: Temperature) -> Temperature {
    let value = lhs.rawValue * rhs[keyPath: lhs.units.temperatureKeyPath]
    return .init(value, units: lhs.units)
  }

  public static func *= (lhs: inout Temperature, rhs: Temperature) {
    lhs.rawValue *= rhs[keyPath: lhs.units.temperatureKeyPath]
  }

  public typealias Magnitude = Double.Magnitude
}

/// Represents the units of measure for a ``Temperature``.
public enum TemperatureUnit: String, Equatable, CaseIterable, Codable, Hashable {
  case celsius = "°C"
  case fahrenheit = "°F"
  case kelvin = "°K"
  case rankine = "°R"

  public var symbol: String {
    rawValue
  }

  public var temperatureKeyPath: WritableKeyPath<Temperature, Double> {
    switch self {
    case .celsius:
      return \.celsius
    case .fahrenheit:
      return \.fahrenheit
    case .kelvin:
      return \.kelvin
    case .rankine:
      return \.rankine
    }
  }
}
