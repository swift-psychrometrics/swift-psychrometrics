import Foundation

public enum LengthUnit: String, Equatable, Codable, Hashable, CaseIterable {
  case centimeters = "cm"
  case meters = "m"
  case feet = "ft"
  case inches = "in"

  public var symbol: String { rawValue }

  public var lengthKeyPath: WritableKeyPath<Length, Double> {
    switch self {
    case .centimeters:
      return \.centimeters
    case .meters:
      return \.meters
    case .feet:
      return \.feet
    case .inches:
      return \.inches
    }
  }
}
