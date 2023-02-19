import Foundation

/// Represents the specific volume of air for the conditions.
///
/// Often represented by the symbol `v` in ASHRAE - Fundamentals (2017)
public struct SpecificVolume<T>: Codable, Equatable, Sendable {

  /// The raw value for the volume.
  public var rawValue: Double

  /// The unit of measure for the raw value.
  public var units: SpecificVolumeUnits

  public init(_ value: Double, units: SpecificVolumeUnits) {
    self.rawValue = value
    self.units = units
  }
}

public enum SpecificVolumeUnits: String, UnitOfMeasure, Codable, Sendable {

  case cubicFeetPerPound = "ft^3/lb"
  case cubicMeterPerKilogram = "m^3/kg"

  public static func defaultFor(units: PsychrometricUnits) -> Self {
    switch units {
    case .metric: return .cubicMeterPerKilogram
    case .imperial: return .cubicFeetPerPound
    }
  }
}

extension SpecificVolume: NumberWithUnitOfMeasure {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias Units = SpecificVolumeUnits

  public static func keyPath(for units: SpecificVolumeUnits) -> WritableKeyPath<
    SpecificVolume<T>, Double
  > {
    \.rawValue
  }
}

public typealias SpecificVolumeOf<T> = SpecificVolume<T>
