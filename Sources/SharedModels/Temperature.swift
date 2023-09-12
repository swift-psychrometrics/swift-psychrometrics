import Dependencies
import Foundation
import Tagged

/// Represents the dew-point temperature of moist air.
public typealias DewPoint = Tagged<DewPointTemperature, Temperature<DewPointTemperature>>

/// Represents a dry-bulb temperature.
public typealias DryBulb = Tagged<DryAir, Temperature<DryAir>>

/// Represents the specific heat of a substance.
public typealias SpecificHeat = Tagged<Specific, Temperature<Specific>>

/// Represents the wet-bulb temperature of moist air.
public typealias WetBulb = Tagged<MoistAir, Temperature<MoistAir>>

/// Represents a temperature in SI and IP units as well as scientific / absolute units.
public struct Temperature<T: TemperatureType>: Hashable, Codable, Sendable {

  /// The raw value set on the instance, this should typically not be used. You should access
  /// the value through the units that you need.
  public private(set) var rawValue: Double

  /// The units for the raw value of the instance.
  public private(set) var units: TemperatureUnit

  /// Create a new ``Temperature`` with the given raw value and units.
  ///
  /// - Parameters:
  ///   - value: The raw value of the temperature.
  ///   - units: The units for the raw value.
  public init(_ value: Double, units: TemperatureUnit) {
    self.rawValue = value
    self.units = units
  }

  /// Access the underlying raw-value.
  ///
  /// This is useful when the temperature is wrapped in a `Tagged` type.
  ///
  public var value: Double { rawValue }
}

/// Represents the units of measure for a ``Temperature``.
public enum TemperatureUnit: String, Equatable, CaseIterable, Codable, Hashable, Sendable {

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

extension Tagged {

  /// Create a new ``Tagged`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The celsius value of the temperature.
  public static func celsius<T>(
    _ value: Double
  ) -> Self where RawValue == Temperature<T> {
    .init(.init(value, units: .celsius))
  }

  /// Create a new ``Tagged`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The fahrenheit value of the temperature.
  public static func fahrenheit<T>(
    _ value: Double
  ) -> Self where RawValue == Temperature<T> {
    .init(.init(value, units: .fahrenheit))
  }

  /// Create a new ``Tagged`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The kelvin value of the temperature.
  public static func kelvin<T>(
    _ value: Double
  ) -> Self where RawValue == Temperature<T> {
    .init(.init(value, units: .kelvin))
  }

  /// Create a new ``Tagged`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The rankine value of the temperature.
  public static func rankine<T>(
    _ value: Double
  ) -> Self where RawValue == Temperature<T> {
    .init(.init(value, units: .rankine))
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

extension TemperatureUnit: UnitOfMeasure {}

extension Temperature: NumberWithUnitOfMeasure {
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias Units = TemperatureUnit

  public static func keyPath(for units: TemperatureUnit) -> WritableKeyPath<Temperature, Double> {
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

  /// Create a ``Temperature`` as a function of the given altitude.
  ///
  ///  - Parameters:
  ///   - altitude: The altitude to calculate the temperature.
  public static func atAltitude(
    _ altitude: Length,
    units: PsychrometricUnits? = nil
  ) -> Temperature {
    @Dependency(\.psychrometricEnvironment) var environment
    let units = units ?? environment.units
    let altitude = altitude[units.isImperial ? .feet : .meters]
    guard units.isImperial else {
      return .init(15 - 0.0065 * altitude, units: .defaultFor(units: units))
    }
    return .init(59 - 0.00356220 * altitude, units: .defaultFor(units: units))
  }
}
