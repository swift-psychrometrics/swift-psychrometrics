import Core
import Foundation

// TODO: Add units of measure.

/// Represents / calculates the grains of moisture for air.
public struct GrainsOfMoisture {

  /// Constant for the mole weight of water.
  public static let moleWeightWater = 18.02

  /// Constant for the mole weight of air.
  public static let moleWeightAir = 28.85
  
  /// Constant for the ratio of the mole weight of water over the mole weight of air.
  public static let moleWeightRatio = (Self.moleWeightWater / Self.moleWeightAir)

  public static func saturationHumidity(
    vaporPressure: Pressure,
    totalPressure: Pressure
  ) -> Double {
    7000 * moleWeightRatio
      * vaporPressure.psi
      / (totalPressure.psi - vaporPressure.psi)
  }

  /// The calculated grains per pound of air.
  public var rawValue: Double

  public init(_ value: Double) {
    self.rawValue = value
  }

  /// Create a new ``GrainsOfMoisture`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - pressure: The pressure of the air.
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    pressure: Pressure
  ) {
    let saturationHumidity = Self.saturationHumidity(
      vaporPressure: .saturationPressure(at: temperature),
      totalPressure: pressure
    )
    self.rawValue = saturationHumidity * humidity.fraction
  }

  /// Create a new ``GrainsOfMoisture`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.init(
      temperature: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude)
    )
  }
}

extension GrainsOfMoisture: RawNumericType {
  public typealias Magnitude = Double.Magnitude
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
}

extension Temperature {

  /// Calculates the ``GrainsOfMoisture`` for the temperature at the given humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public func grains(humidity: RelativeHumidity, altitude: Length = .seaLevel) -> GrainsOfMoisture {
    .init(temperature: self, humidity: humidity, altitude: altitude)
  }
}
