import Foundation

/// Represents a unit of length in both SI and IP units.
public struct Length: Hashable, Codable, Sendable {

  /// The raw value of the length for the units set on the instance.
  public private(set) var rawValue: Double

  /// The unit of measure for the lenght set on the instance.
  public private(set) var units: Unit

  /// Create a new ``Length`` with the given value and units.
  ///
  /// - Parameters:
  ///   - value: The value of the length.
  ///   - units: The unit of measure for the length.
  public init(
    _ value: Double = 0,
    units: Unit
  ) {
    self.rawValue = value
    self.units = units
  }

  /// Represents unit of measure used in a ``Length``.
  public enum Unit: String, Equatable, Codable, Hashable, CaseIterable, Sendable {

    public static func defaultFor(units: PsychrometricUnits) -> Length.Unit {
      switch units {
      case .metric: return .meters
      case .imperial: return .feet
      }
    }

    case centimeters = "cm"
    case meters = "m"
    case feet = "ft"
    case inches = "in"

    /// The symbol string for the unit of length.
    public var symbol: String { rawValue }
  }
}

extension Length {

  /// Create a new ``Length`` with the given centimeter value.
  ///
  /// - Parameters:
  ///   - value: The centimeters of the length.
  public static func centimeters(_ value: Double) -> Length {
    self.init(value, units: .centimeters)
  }

  /// Create a new ``Length`` with the given feet value.
  ///
  /// - Parameters:
  ///   - value: The feet of the length.
  public static func feet(_ value: Double) -> Length {
    self.init(value, units: .feet)
  }

  /// Create a new ``Length`` with the given inches value.
  ///
  /// - Parameters:
  ///   - value: The inches of the length.
  public static func inches(_ value: Double) -> Length {
    self.init(value, units: .inches)
  }

  /// Create a new ``Length`` with the given meters value.
  ///
  /// - Parameters:
  ///   - value: The meters of the length.
  public static func meters(_ value: Double) -> Length {
    self.init(value, units: .meters)
  }

  /// Create a new ``Length`` at sea-level.
  public static var seaLevel: Self {
    .feet(0)
  }
}

extension Length {

  /// Access / convert the length in centimeters.
  public var centimeters: Double {
    get {
      switch units {
      case .centimeters:
        return rawValue
      case .feet:
        return rawValue / 0.032808
      case .inches:
        return rawValue * 2.54
      case .meters:
        return rawValue * 100
      }
    }
    set { self = .centimeters(newValue) }
  }

  /// Access / convert the length in feet.
  public var feet: Double {
    get {
      switch units {
      case .centimeters:
        return rawValue * 0.032808
      case .feet:
        return rawValue
      case .inches:
        return rawValue / 12
      case .meters:
        return rawValue * 3.2808
      }
    }
    set { self = .feet(newValue) }
  }

  /// Access / convert the length in inches.
  public var inches: Double {
    get {
      switch units {
      case .centimeters:
        return rawValue * 0.39370
      case .feet:
        return rawValue * 12
      case .inches:
        return rawValue
      case .meters:
        return rawValue / 0.0254
      }
    }
    set { self = .inches(newValue) }
  }

  /// Access / convert the length in meters.
  public var meters: Double {
    get {
      switch units {
      case .centimeters:
        return rawValue / 100
      case .feet:
        return rawValue / 3.2808
      case .inches:
        return rawValue * 0.0254
      case .meters:
        return rawValue
      }
    }
    set { self = .meters(newValue) }
  }

}

extension Length.Unit: UnitOfMeasure {}

extension Length: NumberWithUnitOfMeasure {
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias Units = Unit

  /// The key-path on a ``Length`` for the units.
  public static func keyPath(for units: Unit) -> WritableKeyPath<Length, Double> {
    switch units {
    case .centimeters:
      return \.centimeters
    case .meters:
      return \.meters
    case .feet:
      return \.feet
    case .inches:
      return \.inches
    }
  }
}
