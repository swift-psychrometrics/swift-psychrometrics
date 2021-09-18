import Foundation

/// Represents a unit of length in both SI and IP units.
public struct Length: Equatable {

  var unit: Unit

  init(_ unit: Unit) {
    self.unit = unit
  }

  enum Unit: Equatable {
    case centimeters(Double)
    case feet(Double)
    case inches(Double)
    case meters(Double)
  }
}

extension Length {

  /// Create a new ``Length`` with the given centimeter value.
  ///
  /// - Parameters:
  ///   - value: The centimeters of the length.
  public static func centimeters(_ value: Double) -> Length {
    self.init(.centimeters(value))
  }

  /// Create a new ``Length`` with the given feet value.
  ///
  /// - Parameters:
  ///   - value: The feet of the length.
  public static func feet(_ value: Double) -> Length {
    self.init(.feet(value))
  }

  /// Create a new ``Length`` with the given inches value.
  ///
  /// - Parameters:
  ///   - value: The inches of the length.
  public static func inches(_ value: Double) -> Length {
    self.init(.inches(value))
  }

  /// Create a new ``Length`` with the given meters value.
  ///
  /// - Parameters:
  ///   - value: The meters of the length.
  public static func meters(_ value: Double) -> Length {
    self.init(.meters(value))
  }
}

// MARK: - Conversions
extension Length {

  /// Access / convert the length in centimeters.
  public var centimeters: Double {
    get {
      switch unit {
      case let .centimeters(value):
        return value
      case let .feet(feet):
        return feet / 0.032808
      case let .inches(inches):
        return inches * 2.54
      case let .meters(meters):
        return meters * 100
      }
    }
    set { self = .centimeters(newValue) }
  }

  /// Access / convert the length in feet.
  public var feet: Double {
    get {
      switch unit {
      case let .centimeters(centimeters):
        return centimeters * 0.032808
      case let .feet(value):
        return value
      case let .inches(inches):
        return inches / 12
      case let .meters(meters):
        return meters * 3.2808
      }
    }
    set { self = .feet(newValue) }
  }

  /// Access / convert the length in inches.
  public var inches: Double {
    get {
      switch unit {
      case let .centimeters(centimeters):
        return centimeters * 0.39370
      case let .feet(feet):
        return feet * 12
      case let .inches(value):
        return value
      case let .meters(meters):
        return meters / 0.0254
      }
    }
    set { self = .inches(newValue) }
  }

  /// Access / convert the length in meters.
  public var meters: Double {
    get {
      switch unit {
      case let .centimeters(centimeters):
        return centimeters / 100
      case let .feet(feet):
        return feet / 3.2808
      case let .inches(inches):
        return inches * 0.0254
      case let .meters(value):
        return value
      }
    }
    set { self = .meters(newValue) }
  }

  public static var seaLevel: Self {
    .init(.feet(0))
  }
}

extension Length: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(.feet(value))
  }
}

extension Length: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(.feet(Double(value)))
  }
}

/// Represents a symbol for a unit of length.
public enum LengthUnit: String, Equatable, Codable, Hashable, CaseIterable {
  case centimeters = "cm"
  case meters = "m"
  case feet = "ft"
  case inches = "in"

  public var symbol: String { rawValue }

  public var lengthKeyPath: WritableKeyPath<Length, Double> {
    switch self {
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
