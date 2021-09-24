import Foundation

/// Represents / calculates pressure for different units.
public struct Pressure: Hashable {

  public private(set) var rawValue: Double

  public private(set) var units: Unit

  public init(_ value: Double = 0, units: Unit = .default) {
    self.rawValue = value
    self.units = units
  }

  // MARK: - Pressure.Unit
  /// Represents the units of measure for ``Pressure``.
  public enum Unit: String, Equatable, Hashable, CaseIterable {

    public static var `default`: Self = .psi

    public static func `for`(_ units: PsychrometricEnvironment.Units) -> Self {
      switch units {
      case .metric: return .pascals
      case .imperial: return .psi
      }
    }

    case atmosphere = "atm"
    case bar = "bar"
    case inchesWater = "inH2O"
    case millibar = "mb"
    case pascals = "Pa"
    case psi = "psi"
    case torr = "torr"

    public var symbol: String {
      return rawValue
    }
  }
}

extension Pressure {

  /// Create a new ``Pressure`` with the given atmosphere value.
  ///
  /// - Parameters:
  ///    - value: The atmosphere value.
  public static func atmosphere(_ value: Double) -> Pressure {
    .init(value, units: .atmosphere)
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The bar value.
  public static func bar(_ value: Double) -> Pressure {
    .init(value, units: .bar)
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The inches of water column value.
  public static func inchesWater(_ value: Double) -> Pressure {
    .init(value, units: .inchesWater)
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The millibar value.
  public static func millibar(_ value: Double) -> Pressure {
    .init(value, units: .millibar)
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The pascals value.
  public static func pascals(_ value: Double) -> Pressure {
    .init(value, units: .pascals)
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The psi guage value.
  public static func psi(_ value: Double) -> Pressure {
    .init(value, units: .psi)
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The torr value.
  public static func torr(_ value: Double) -> Pressure {
    .init(value, units: .torr)
  }
}

// MARK: - Conversions

extension Pressure {

  /// Access / calculate the pressure as atmosphere.
  public var atmosphere: Double {
    get {
      switch units {
      case .atmosphere:
        return rawValue
      case .bar:
        return rawValue * 0.98692316931427
      case .inchesWater:
        return rawValue * 0.00245832
      case .millibar:
        return rawValue * 0.00098692316931427
      case .pascals:
        return rawValue * 9.8692316931427e-6
      case .psi:
        return rawValue * 0.06804596377991787
      case .torr:
        return rawValue * 0.0013157893594089
      }
    }
    set { self = .atmosphere(newValue) }
  }

  /// Access / calculate the pressure as bar.
  public var bar: Double {
    get { self.atmosphere / 0.98692316931427 }
    set { self = .bar(newValue) }
  }

  /// Access / calculate the pressure as inches of water column.
  public var inchesWater: Double {
    get { self.atmosphere / 0.00245832 }
    set { self = .inchesWater(newValue) }
  }

  /// Access / calculate the pressure as millibar.
  public var millibar: Double {
    get { self.atmosphere / 0.00098692316931427 }
    set { self = .millibar(newValue) }
  }

  /// Access / calculate the pressure as pascals.
  public var pascals: Double {
    get { self.atmosphere / 9.8692316931427e-6 }
    set { self = .pascals(newValue) }
  }

  /// Access / calculate the pressure as psi guage.
  public var psi: Double {
    get { self.atmosphere / 0.06804596377991787 }
    set { self = .psi(newValue) }
  }

  /// Access / calculate the pressure as torr.
  public var torr: Double {
    get { self.atmosphere / 0.0013157893594089 }
    set { self = .torr(newValue) }
  }
}

extension Pressure.Unit: UnitOfMeasure {}

extension Pressure: NumberWithUnitOfMeasure {
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias Units = Unit

  public static func keyPath(for units: Unit) -> WritableKeyPath<Pressure, Double> {
    switch units {
    case .atmosphere:
      return \.atmosphere
    case .bar:
      return \.bar
    case .inchesWater:
      return \.inchesWater
    case .millibar:
      return \.millibar
    case .pascals:
      return \.pascals
    case .psi:
      return \.psi
    case .torr:
      return \.torr
    }
  }
}