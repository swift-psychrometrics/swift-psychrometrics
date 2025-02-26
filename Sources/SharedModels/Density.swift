import Foundation
import Tagged

/// Represents the mass per unit of volume.
///
/// Often represented by `ρ` in ASHRAE Fundamentals (2017)
///
public struct Density<T: DensityType>: Codable, Equatable, Sendable {

  /// The raw value of the density.
  public private(set) var rawValue: Double

  /// The units of the raw value.
  public private(set) var units: DensityUnits

  /// Create a new ``Density`` with the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw value of the density.
  ///   - units: The unit of measure for the raw value.
  public init(_ value: Double, units: DensityUnits) {
    self.rawValue = value
    self.units = units
  }

  /// Access the underlying raw-value.
  ///
  /// This is useful when density is wrapped in a `Tagged` type.
  ///
  public var value: Double { rawValue }
}

/// The units of measure for a ``Density`` type.
public enum DensityUnits: String, UnitOfMeasure, Codable, Sendable {

  case poundsPerCubicFoot = "lb/ft³"
  case kilogramPerCubicMeter = "kg/m³"

  public static func defaultFor(units: PsychrometricUnits) -> Self {
    switch units {
    case .imperial: return .poundsPerCubicFoot
    case .metric: return .kilogramPerCubicMeter
    }
  }
}

public typealias DensityOf<T: DensityType> = Tagged<T, Density<T>>

extension Density: NumberWithUnitOfMeasure {

  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias Units = DensityUnits

  public static func keyPath(for units: DensityUnits) -> WritableKeyPath<Self, Double> {
    \.rawValue
  }
}
