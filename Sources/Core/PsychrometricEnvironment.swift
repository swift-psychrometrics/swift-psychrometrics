import Foundation

public struct PsychrometricEnvironment {

  public var maximumIterationCount: Int = 100

  public var minimumHumidityRatio: Double = 1e-7

  public var temperatureTolerance: Temperature = .celsius(0.001)

  public var units: Units = .imperial

  public var freezingPointOfWater: Temperature {
    switch units {
    case .metric:
      return .celsius(0)
    case .imperial:
      return .fahrenheit(32)
    }
  }

  public var triplePointOfWater: Temperature {
    switch units {
    case .metric:
      return .celsius(0.01)
    case .imperial:
      return .fahrenheit(32.018)
    }
  }
  
  public var pressureBounds: (low: Temperature, high: Temperature) {
    switch units {
    case .metric:
      return (low: -100, high: 200)
    case .imperial:
      return (low: -148, high: 392)
    }
  }

  public enum Units {
    case metric, imperial
  }
}

public var environment = PsychrometricEnvironment()
