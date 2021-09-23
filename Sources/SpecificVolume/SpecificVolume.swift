import Core
import Foundation
import HumidityRatio

/// Represents the specific volume of air for the conditions.
///
/// Often represented by the symbol `v` in ASHRAE - Fundamentals (2017)
public struct SpecificVolume<T> {

  /// The raw value for the volume.
  public private(set) var rawValue: Double

  /// The unit of measure for the raw value.
  public private(set) var units: SpecificVolumeUnits

  public init(_ value: Double, units: SpecificVolumeUnits = .default) {
    self.rawValue = value
    self.units = units
  }
}

public enum SpecificVolumeUnits: UnitOfMeasure {

  case cubicFeetPerPound
  case cubicMeterPerKilogram

  public static var `default`: Self = .cubicFeetPerPound

  internal static func `for`(_ units: PsychrometricEnvironment.Units) -> Self {
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
