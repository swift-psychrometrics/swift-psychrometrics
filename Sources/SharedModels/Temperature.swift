import Foundation

/// Represents a temperature in SI and IP units as well as scientific / absolute units.
public struct Temperature: Hashable, Codable, Sendable {

  /// The raw value set on the instance, this should typically not be used. You should access
  /// the value through the units that you need.
  public private(set) var rawValue: Double

  /// The units for the raw value of the instance.
  public private(set) var units: Unit

  /// Create a new ``Temperature`` with the given raw value and units.
  ///
  /// - Parameters:
  ///   - value: The raw value of the temperature.
  ///   - units: The units for the raw value.
  public init(_ value: Double, units: Unit) {
    self.rawValue = value
    self.units = units
  }
}

extension Temperature {

  /// Represents the units of measure for a ``Temperature``.
  public enum Unit: String, Equatable, CaseIterable, Codable, Hashable, Sendable {

    public static func defaultFor(units: PsychrometricUnits) -> Self {
      switch units {
      case .metric: return .celsius
      case .imperial: return .fahrenheit
      }
    }

    case celsius = "°C"
    case fahrenheit = "°F"
    case kelvin = "°K"
    case rankine = "°R"

    public var symbol: String {
      rawValue
    }
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

// TODO: Move Conversions somewhere else.

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
      case .celsius:
        return rawValue + 273.15
      case .rankine, .fahrenheit:
        return Temperature.celsius(self.celsius).kelvin
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

extension Temperature.Unit: UnitOfMeasure {}

extension Temperature: NumberWithUnitOfMeasure {
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias Units = Unit

  public static func keyPath(for units: Unit) -> WritableKeyPath<Temperature, Double> {
    switch units {
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

extension Temperature {

  // TODO: This needs moved somewhere else where it can use environment dependency.
  
  /// Create a ``Temperature`` as a function of the given altitude.
  ///
  ///  - Parameters:
  ///   - altitude: The altitude to calculate the temperature.
  public static func atAltitude(
    _ altitude: Length,
    units: PsychrometricUnits? = nil
  ) -> Temperature {
    let units = units ?? .imperial // fix.
    let altitude = units.isImperial ? altitude.feet : altitude.meters
    guard units.isImperial else {
      return .init(15 - 0.0065 * altitude, units: .defaultFor(units: units))
    }
    return .init(59 - 0.00356220 * altitude, units: .defaultFor(units: units))
  }
}
