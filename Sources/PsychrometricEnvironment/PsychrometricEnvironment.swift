import CoreUnitTypes
import Dependencies
import Foundation

public struct PsychrometricEnvironment {

  /// Maximum iteration count for iterative methods.
  public var maximumIterationCount: Int = 100

  /// Ensures humidity ratios are non-negative values.
  public var minimumHumidityRatio: Double = 1e-7

  /// Temperature tolerance for iterative temperature calculations.
  public var temperatureTolerance: Temperature = .celsius(0.001)

  /// The unit of measure.
  public var units: PsychrometricUnits = .imperial

  /// Returns the freezing point of water for the given units.
  ///
  /// - Parameters:
  ///   - units: The units to return the freezing point of water for.
  public static func freezingPointOfWater(for units: PsychrometricUnits) -> Temperature {
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
  public static func triplePointOfWater(for units: PsychrometricUnits) -> Temperature {
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
  public static func pressureBounds(for units: PsychrometricUnits) -> (low: Temperature, high: Temperature) {
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

//extension PsychrometricEnvironment {
//  /// The default  global environment settings.
//  public static var shared = PsychrometricEnvironment()
//}

extension PsychrometricEnvironment: DependencyKey {
  public static var liveValue: PsychrometricEnvironment {
    .init()
  }
  
  public static var testValue: PsychrometricEnvironment {
    .init()
  }
}

extension DependencyValues {
  public var psychrometricEnvironment: PsychrometricEnvironment {
    get { self[PsychrometricEnvironment.self] }
    set { self[PsychrometricEnvironment.self] = newValue }
  }
}
