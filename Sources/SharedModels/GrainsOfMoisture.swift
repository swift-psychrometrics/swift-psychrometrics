import Foundation

// TODO: Add units of measure.

/// Represents / calculates the grains of moisture for air.
public struct GrainsOfMoisture: Codable, Equatable, Sendable {

  /// Constant for the mole weight of water.
  public static let moleWeightWater = 18.02

  /// Constant for the mole weight of air.
  public static let moleWeightAir = 28.85

  /// Constant for the ratio of the mole weight of water over the mole weight of air.
  public static let moleWeightRatio = (Self.moleWeightWater / Self.moleWeightAir)
  /// The calculated grains per pound of air.
  public var rawValue: Double

  public init(_ value: Double) {
    self.rawValue = value
  }
}

extension GrainsOfMoisture: RawNumericType {
  public typealias Magnitude = Double.Magnitude
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
}
