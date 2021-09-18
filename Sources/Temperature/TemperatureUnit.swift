import Foundation

public enum TemperatureUnit: String, Equatable, CaseIterable, Codable, Hashable {
  case celsius = "°C"
  case fahrenheit = "°F"
  case kelvin = "°K"
  case rankine = "°R"

  public var symbol: String {
    rawValue
  }

  public var temperatureKeyPath: WritableKeyPath<Temperature, Double> {
    switch self {
    case .celsius:
      return \.celsius
    case .fahrenheit:
      return \.fahrenheit
    case .kelvin:
      return \.kelvin
    case .rankine:
      return \.rankine
    }
  }
}
