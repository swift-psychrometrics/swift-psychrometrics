import Core
import DewPoint
import Foundation
import HumidityRatio

/// Represents / calculates the wet-bulb temperature for the given temperature and relative humidity.
@dynamicMemberLookup
public struct WetBulb {

  private static func calculate(_ temperature: Temperature, _ humidity: RelativeHumidity)
    -> Temperature
  {
    let celsius = temperature.celsius
    let humidity = humidity.rawValue
    let value =
      ((-5.806 + 0.672 * celsius - 0.006 * celsius * celsius
        + (0.061 + 0.004 * celsius + 0.000099 * celsius * celsius) * humidity
        + (-0.000033 - 0.000005 * celsius - 0.0000001 * celsius * celsius)
          * humidity * humidity))
    return .celsius(value)
  }

  public var rawValue: Temperature

  public var temperature: Temperature {
    get { rawValue }
    set { rawValue = newValue }
  }

  /// Create a new ``WetBulb`` for the given temperature.
  ///
  /// - Parameters:
  ///    - value: The temperature for the wet bulb.
  public init(_ value: Temperature) {
    self.rawValue = value
  }
  //  public init(temperature: Temperature, humidity: RelativeHumidity) {
  //    self.rawValue = Self.calculate(temperature, humidity)
  //  }

  public subscript<V>(dynamicMember keyPath: KeyPath<Temperature, V>) -> V {
    rawValue[keyPath: keyPath]
  }
}

extension WetBulb: RawNumericType {
  public typealias FloatLiteralType = Temperature.FloatLiteralType
  public typealias Magnitude = Temperature.Magnitude
  public typealias IntegerLiteralType = Temperature.IntegerLiteralType
}
