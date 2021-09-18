import Foundation
@_exported import Length
@_exported import Temperature

/// Represents / calculates pressure for different units.
public struct Pressure: Equatable {

  fileprivate var unit: Unit

  fileprivate init(_ unit: Unit) {
    self.unit = unit
  }

  /// Create a new ``Pressure`` for the given altitude.
  ///
  /// - Parameters:
  ///   - altitude: The altitude to calculate the pressure.
  public init(altitude: Length) {
    let meters = altitude.meters
    let pascals = 101325 * pow((1 - 2.25577e-5 * meters), 5.525588)
    self.init(.pascals(pascals))
  }

  fileprivate enum Unit: Equatable {
    case atmosphere(Double)
    case bar(Double)
    case inchesWaterColumn(Double)
    case millibar(Double)
    case pascals(Double)
    case psi(Double)
    case torr(Double)
  }
}

extension Pressure {

  /// Create a new ``Pressure`` with the given atmosphere value.
  ///
  /// - Parameters:
  ///    - value: The atmosphere value.
  public static func atmosphere(_ value: Double) -> Pressure {
    .init(.atmosphere(value))
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The bar value.
  public static func bar(_ value: Double) -> Pressure {
    .init(.bar(value))
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The inches of water column value.
  public static func inchesWaterColumn(_ value: Double) -> Pressure {
    .init(.inchesWaterColumn(value))
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The millibar value.
  public static func millibar(_ value: Double) -> Pressure {
    .init(.millibar(value))
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The pascals value.
  public static func pascals(_ value: Double) -> Pressure {
    .init(.pascals(value))
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The psi value.
  public static func psi(_ value: Double) -> Pressure {
    .init(.psi(value))
  }

  /// Create a new ``Pressure`` with the given value.
  ///
  /// - Parameters:
  ///    - value: The torr value.
  public static func torr(_ value: Double) -> Pressure {
    .init(.torr(value))
  }
}

// MARK: - Conversions

extension Pressure {

  /// Access / calculate the pressure as atmosphere.
  public var atmosphere: Double {
    get {
      switch unit {
      case let .atmosphere(value):
        return value
      case let .bar(bar):
        return bar * 0.98692316931427
      case let .inchesWaterColumn(inchesWaterColumn):
        return inchesWaterColumn * 0.00245832
      case let .millibar(millibar):
        return millibar * 0.00098692316931427
      case let .pascals(pascals):
        return pascals * 9.8692316931427e-6
      case let .psi(psig):
        return psig * 0.06804596377991787
      case let .torr(torr):
        return torr * 0.0013157893594089
      }
    }
    set { self = .init(.atmosphere(newValue)) }
  }

  /// Access / calculate the pressure as bar.
  public var bar: Double {
    get { self.atmosphere / 0.98692316931427 }
    set { self = .bar(newValue) }
  }

  /// Access / calculate the pressure as inches of water column.
  public var inchesWaterColumn: Double {
    get { self.atmosphere / 0.00245832 }
    set { self = .atmosphere(newValue) }
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

  /// Access / calculate the pressure as psi.
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

// MARK: - Vapor Pressure
extension Pressure {

  /// Calculate the vapor pressure of air at a given temperature.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the vapor pressure of.
  public static func vaporPressure(at temperature: Temperature) -> Pressure {
    let celsius = temperature.celsius
    let exponent = (7.5 * celsius) / (237.3 + celsius)
    let millibar = 6.11 * pow(10, exponent)
    return .init(.millibar(millibar))
  }
}

// MARK: - PressureUnit
/// Represents the different symbols / units of measure for ``Pressure``.
public enum PressureUnit: String, Equatable, Hashable, CaseIterable {
  case atmosphere
  case bar
  case inchesWater
  case millibar
  case pascals
  case psi
  case torr

  public var symbol: String {
    switch self {
    case .atmosphere:
      return "atm"
    case .bar:
      return "bar"
    case .inchesWater:
      return "inH2O"
    case .millibar:
      return "mb"
    case .pascals:
      return "Pa"
    case .psi:
      return "psi"
    case .torr:
      return "torr"
    }
  }

  public var title: String {
    switch self {
    case .atmosphere, .bar, .millibar, .pascals, .torr:
      return rawValue.capitalized
    case .inchesWater:
      return "Inches of Water"
    case .psi:
      return "PSI"
    }
  }

  public var pressureKeyPath: WritableKeyPath<Pressure, Double> {
    switch self {
    case .atmosphere:
      return \.atmosphere
    case .bar:
      return \.bar
    case .inchesWater:
      return \.inchesWaterColumn
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
