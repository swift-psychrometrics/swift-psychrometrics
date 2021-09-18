import Foundation
import Length
import Temperature

public struct Pressure: Equatable {

  var unit: Unit

  init(_ unit: Unit) {
    self.unit = unit
  }

  public init(altitude: Length) {
    let meters = altitude.meters
    let pascals = 101325 * pow((1 - 2.25577e-5 * meters), 5.525588)
    self.init(.pascals(pascals))
  }

  public enum Unit: Equatable {
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
  public static func atmosphere(_ value: Double) -> Pressure {
    .init(.atmosphere(value))
  }

  public static func bar(_ value: Double) -> Pressure {
    .init(.bar(value))
  }

  public static func inchesWaterColumn(_ value: Double) -> Pressure {
    .init(.inchesWaterColumn(value))
  }

  public static func millibar(_ value: Double) -> Pressure {
    .init(.millibar(value))
  }

  public static func pascals(_ value: Double) -> Pressure {
    .init(.pascals(value))
  }

  public static func psi(_ value: Double) -> Pressure {
    .init(.psi(value))
  }

  public static func torr(_ value: Double) -> Pressure {
    .init(.torr(value))
  }
}

// MARK: - Conversions

extension Pressure {

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

  public var bar: Double {
    get { self.atmosphere / 0.98692316931427 }
    set { self = .bar(newValue) }
  }

  public var inchesWaterColumn: Double {
    get { self.atmosphere / 0.00245832 }
    set { self = .atmosphere(newValue) }
  }

  public var millibar: Double {
    get { self.atmosphere / 0.00098692316931427 }
    set { self = .millibar(newValue) }
  }

  public var pascals: Double {
    get { self.atmosphere / 9.8692316931427e-6 }
    set { self = .pascals(newValue) }
  }

  public var psi: Double {
    get { self.atmosphere / 0.06804596377991787 }
    set { self = .psi(newValue) }
  }

  public var torr: Double {
    get { self.atmosphere / 0.0013157893594089 }
    set { self = .torr(newValue) }
  }
}

// MARK: - Vapor Pressure
extension Pressure {

  public static func vaporPressure(at temperature: Temperature) -> Pressure {
    let celsius = temperature.celsius
    let exponent = (7.5 * celsius) / (237.3 + celsius)
    let millibar = 6.11 * pow(10, exponent)
    return .init(.millibar(millibar))
  }
}

// MARK: - PressureUnit
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
