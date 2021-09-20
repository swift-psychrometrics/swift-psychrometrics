import Foundation
import Core
@_exported import Length
@_exported import Pressure
@_exported import RelativeHumidity
@_exported import Temperature

// TODO: Add units of measure.

/// Represents / calculates the grains of moisture for air.
public struct GrainsOfMoisture: Equatable {

  /// Constant for the mole weight of water.
  public static let moleWeightWater = 18.02

  /// Constant for the mole weight of air.
  public static let moleWeightAir = 28.85

  public static func saturationHumidity(vaporPressure: Pressure, ambientPressure: Pressure)
    -> Double
  {
    7000 * (Self.moleWeightWater / Self.moleWeightAir) * vaporPressure.psi
      / (ambientPressure.psi - vaporPressure.psi)
  }

  private static func calculate(
    _ temperature: Temperature,
    _ humidity: RelativeHumidity,
    _ pressure: Pressure
  ) -> Double {
    let vaporPressure = Pressure.vaporPressure(at: temperature)
    let saturationHumidity = saturationHumidity(
      vaporPressure: vaporPressure, ambientPressure: pressure)
    return saturationHumidity * humidity.fraction
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
    self.rawValue = Self.calculate(temperature, humidity, pressure)
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

extension GrainsOfMoisture: RawValueInitializable, NumericType {
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
