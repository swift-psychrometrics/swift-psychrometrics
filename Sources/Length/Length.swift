import Foundation

/// Represents a unit of length in both SI and IP units.
public struct Length: Equatable {
  
  /// The default units used for a Length.
  public static var defaultUnits: LengthUnit = .feet

  public var rawValue: Double = 0
  public var units: LengthUnit = .feet
  
  public init(_ value: Double, units: LengthUnit = .feet) {
    self.rawValue = value
    self.units = units
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
}

// MARK: - Conversions
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

  public static var seaLevel: Self {
    .feet(0)
  }
}

extension Length: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(value, units: Self.defaultUnits)
  }
}

extension Length: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(Double(value), units: Self.defaultUnits)
  }
}

/// Represents unit of measure used in a ``Length``.
public enum LengthUnit: String, Equatable, Codable, Hashable, CaseIterable {
  case centimeters = "cm"
  case meters = "m"
  case feet = "ft"
  case inches = "in"

  public var symbol: String { rawValue }

//  public var lengthKeyPath: WritableKeyPath<Length, Double> {
//    switch self {
//    case .centimeters:
//      return \.centimeters
//    case .meters:
//      return \.meters
//    case .feet:
//      return \.feet
//    case .inches:
//      return \.inches
//    }
//  }
}
