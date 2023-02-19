import Foundation

/// Represents / calculates pressure for different units.
public struct Pressure: Hashable, Codable, Sendable {

  public private(set) var rawValue: Double

  public private(set) var units: Unit

  public init(_ value: Double, units: Unit) {
    self.rawValue = value
    self.units = units
  }

  // MARK: - Pressure.Unit
  /// Represents the units of measure for ``Pressure``.
  public enum Unit: String, Equatable, Hashable, CaseIterable, Sendable {

    public static func defaultFor(units: PsychrometricUnits) -> Self {
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

// TODO: Move conversions somewhere else.

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

// MARK: - Pressure + Altitude

// TODO: This needs moved somewhere else.

extension Pressure {

  private struct Constants {
    let c1: Double
    let c2: Double
    let c3 = 5.2559
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 14.696 : 101325
      self.c2 = units.isImperial ? 6.8754e-06 : 2.25577e-05
    }

    func run(altitude: Length) -> Double {
      let altitude = units.isImperial ? altitude.feet : altitude.meters
      return c1 * pow(1 - c2 * altitude, c3)
    }
  }
  
  /// Create a new ``Pressure`` for the given altitude.
  ///
  /// - Note:
  ///   The altitude will be converted to the appropriate unit of measure base on the units you are trying to solve for.
  ///
  /// - Parameters:
  ///   - altitude: The altitude to calculate the pressure.
  ///   - units: The unit of measure to solve the pressure for, if not supplied then will default to ``Core.environment`` units.
  public init(
    altitude: Length,
    units: PsychrometricUnits? = nil
  ) {
    let units = units ?? .imperial // fix
    let value = Constants(units: units).run(altitude: altitude)
    self.init(value, units: .defaultFor(units: units))
  }
}
