import Foundation

public struct PsychrometricEnvironment {

  /// Maximum iteration count for iterative methods.
  public var maximumIterationCount: Int = 100

  /// Ensures humidity ratios are non-negative values.
  public var minimumHumidityRatio: Double = 1e-7

  /// Temperature tolerance for iterative temperature calculations.
  public var temperatureTolerance: Temperature = .celsius(0.001)

  /// The unit of measure.
  public var units: Units = .imperial

  
  /// Returns the freezing point of water for the given units.
  ///
  /// - Parameters:
  ///   - units: The units to return the freezing point of water for.
  public func freezingPointOfWater(for units: Units) -> Temperature {
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
  public func triplePointOfWater(for units: Units) -> Temperature {
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
  public func pressureBounds(for units: Units) -> (low: Temperature, high: Temperature) {
    switch units {
    case .metric:
      return (low: -100, high: 200)
    case .imperial:
      return (low: -148, high: 392)
    }
  }
  
  
  /// Returns the universal gas constant for the given units.
  ///
  /// - Parameters:
  ///   - units: The units to return the triple point of water for.
  public static func universalGasConstant(for units: Units) -> Double {
    switch units {
    case .metric:
      return 287.042
    case .imperial:
      return 53.350
    }
  }

  /// Represents unit of measure used in calculations [SI] or [IP].
  public enum Units: String, CaseIterable {
    case metric, imperial
  }
}

/// The default  global environment settings.
public var environment = PsychrometricEnvironment()
