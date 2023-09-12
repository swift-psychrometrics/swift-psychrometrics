import Dependencies
import Foundation
import SharedModels

/// This controls the way psychrometric calculations get ran.  Whether they are for imperial
/// or metric ``SharedModels/PsychrometricUnits``
///
public struct PsychrometricEnvironment {

  /// Maximum iteration count for iterative methods.
  public var maximumIterationCount: Int = 100

  /// Ensures humidity ratios are non-negative values.
  public var minimumHumidityRatio: Double = 1e-7

  /// Temperature tolerance for iterative temperature calculations.
  public var temperatureTolerance: DryBulb = .celsius(0.001)

  /// The unit of measure.
  public var units: PsychrometricUnits = .imperial

  /// Create a new environment instance.
  ///
  /// - Parameters:
  ///   - maximumIterationCount: The iteration count for iterative methods.
  ///   - minimumHumidityRatio: The minimum humidity ration acceptable.
  ///   - temperatureTolerance: The temperature tolerance to break out of iterative methods.
  ///   - units: The default unit of measure.
  public init(
    maximumIterationCount: Int = 100,
    minimumHumidityRatio: Double = 1e-7,
    temperatureTolerance: DryBulb = .celsius(0.001),
    units: PsychrometricUnits = .imperial
  ) {
    self.maximumIterationCount = maximumIterationCount
    self.minimumHumidityRatio = minimumHumidityRatio
    self.temperatureTolerance = temperatureTolerance
    self.units = units
  }

  /// Returns the freezing point of water for the given units.
  ///
  /// - Parameters:
  ///   - units: The units to return the freezing point of water for.
  public static func freezingPointOfWater(for units: PsychrometricUnits) -> DryBulb {
    switch units {
    case .metric:
      return .celsius(0)
    case .imperial:
      return .fahrenheit(32)
    }
  }

  /// Returns the triple point of water for the given units.
  ///
  /// - Parameters:
  ///   - units: The units to return the triple point of water for.
  public static func triplePointOfWater(for units: PsychrometricUnits) -> DryBulb {
    switch units {
    case .metric:
      return .celsius(0.01)
    case .imperial:
      return .fahrenheit(32.018)
    }
  }

  /// Returns the temperature bounds for calculating saturation pressures for the given units.
  ///
  /// - Parameters:
  ///   - units: The units to return the bounds for.
  public static func pressureBounds(for units: PsychrometricUnits) -> (
    low: DryBulb, high: DryBulb
  ) {
    switch units {
    case .metric:
      return (low: .celsius(-100), high: .celsius(200))
    case .imperial:
      return (low: .fahrenheit(-148), high: .fahrenheit(392))
    }
  }

  /// Returns the universal gas constant for the given units.
  ///
  /// - Parameters:
  ///   - units: The units to return the triple point of water for.
  public static func universalGasConstant(for units: PsychrometricUnits) -> Double {
    switch units {
    case .metric:
      return 287.042
    case .imperial:
      return 53.350
    }
  }

}

extension PsychrometricEnvironment: DependencyKey {
  public static var liveValue: PsychrometricEnvironment {
    .init()
  }

  public static var testValue: PsychrometricEnvironment {
    .init()
  }
}

extension DependencyValues {
  
  /// Access the psychrometric environment as a dependency.
  ///
  public var psychrometricEnvironment: PsychrometricEnvironment {
    get { self[PsychrometricEnvironment.self] }
    set { self[PsychrometricEnvironment.self] = newValue }
  }
}
