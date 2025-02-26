import Foundation

/// Represents / calculates the grains of moisture for air.
public struct AbsoluteHumidity: Codable, Equatable, Sendable {

  /// Constant for the mole weight of water.
  public static let moleWeightWater = 18.02

  /// Constant for the mole weight of air.
  public static let moleWeightAir = 28.85

  /// Constant for the ratio of the mole weight of water over the mole weight of air.
  public static let moleWeightRatio = (Self.moleWeightWater / Self.moleWeightAir)

  /// The grains per pound of air.
  public private(set) var rawValue: Double

  /// The units.
  public private(set) var units: AbsoluteHumidityUnit

  public init(_ value: Double, units: AbsoluteHumidityUnit) {
    self.rawValue = value
    self.units = units
  }

  public var value: Double { rawValue }

}

extension AbsoluteHumidity: NumberWithUnitOfMeasure {
  public typealias Magnitude = Double.Magnitude
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Units = AbsoluteHumidityUnit

  public static func keyPath(for units: AbsoluteHumidityUnit) -> WritableKeyPath<AbsoluteHumidity, Double> {
    \.rawValue
  }
}

public enum AbsoluteHumidityUnit: String, Equatable, CaseIterable, Codable, Hashable, Sendable, UnitOfMeasure {
  case gramsPerCubicMeter = "g/m³"
  case grainsPerCubicFoot = "gr/ft³"

  public var symbol: String { rawValue }

  public static func defaultFor(units: PsychrometricUnits) -> AbsoluteHumidityUnit {
    switch units {
    case .metric: return .gramsPerCubicMeter
    case .imperial: return .grainsPerCubicFoot
    }
  }
}

/// Represents / calculates the grains of moisture for air.
@available(*, deprecated, message: "use AbsoluteHumidity instead")
public struct GrainsOfMoisture: Codable, Equatable, Sendable {

  /// Constant for the mole weight of water.
  public static let moleWeightWater = 18.02

  /// Constant for the mole weight of air.
  public static let moleWeightAir = 28.85

  /// Constant for the ratio of the mole weight of water over the mole weight of air.
  public static let moleWeightRatio = (Self.moleWeightWater / Self.moleWeightAir)

  /// The grains per pound of air.
  public private(set) var rawValue: Double

  /// The units.
  public private(set) var units: GrainsOfMoistureUnit

  public init(_ value: Double, units: GrainsOfMoistureUnit) {
    self.rawValue = value
    self.units = units
  }

  public var value: Double { rawValue }

}

extension GrainsOfMoisture: NumberWithUnitOfMeasure {
  public typealias Magnitude = Double.Magnitude
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Units = GrainsOfMoistureUnit

  public static func keyPath(for units: GrainsOfMoistureUnit) -> WritableKeyPath<GrainsOfMoisture, Double> {
    \.rawValue
  }
}

@available(*, deprecated, message: "use AbsoluteHumidityUnit instead")
public enum GrainsOfMoistureUnit: String, Equatable, CaseIterable, Codable, Hashable, Sendable, UnitOfMeasure {
  case gramsPerCubicMeter = "g/m³"
  case grainsPerCubicFoot = "gr/ft³"

  public var symbol: String { rawValue }

  public static func defaultFor(units: PsychrometricUnits) -> GrainsOfMoistureUnit {
    switch units {
    case .metric: return .gramsPerCubicMeter
    case .imperial: return .grainsPerCubicFoot
    }
  }
}
