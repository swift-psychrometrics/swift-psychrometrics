/// Represents the specific humidity of moist air, which is defined as the ratio of the mass of water vapor to the total
/// mass of the moist air sample.
///
/// Often represented by the symbol `γ` in ASHRAE Fundamentals (2017).
///
public struct SpecificHumidity: Codable, Equatable, Sendable {

  /// The raw value for the given conditions.
  public var rawValue: Double

  public var units: Units

  /// Create a new ``SpecificHumidity`` with the given raw value.
  ///
  /// - Parameters:
  ///   - value: The specific humidity value.
  public init(_ value: Double, units: Units) {
    self.rawValue = value
    self.units = units
  }
}

extension SpecificHumidity {

  public enum Units: UnitOfMeasure, Codable, Sendable {

    case poundsOfWaterPerPoundOfAir
    case kilogramsOfWaterPerKilogramOfAir

    public static func defaultFor(units: PsychrometricUnits) -> SpecificHumidity.Units {
      switch units {
      case .metric: return .kilogramsOfWaterPerKilogramOfAir
      case .imperial: return .poundsOfWaterPerPoundOfAir
      }
    }
  }
}

extension SpecificHumidity: NumberWithUnitOfMeasure {

  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude

  public static func keyPath(for units: Units) -> WritableKeyPath<SpecificHumidity, Double> {
    \.rawValue
  }
}
