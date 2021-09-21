import Core
import Foundation


public struct HumidityRatio: Equatable {

  public var rawValue: Double

  public init(_ value: Double) {
    self.rawValue = value
  }

  /// The humidity ratio of air for the given mass of water and mass of dry air.
  ///
  /// - Parameters:
  ///   - waterMass: The mass of the water in the air.
  ///   - dryAirMass: The mass of the dry air.
  public init(
    water waterMass: Double,
    dryAir dryAirMass: Double
  ) {
    self.init(0.621945 * (waterMass / dryAirMass))
  }

  /// The  humidity ratio of the air for the given total pressure and partial pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - partialPressure: The partial pressure of the air.
  public init(
    for totalPressure: Pressure,
    with partialPressure: Pressure
  ) {
    self.init(
      0.621945 * partialPressure.psi
        / (totalPressure.psi - partialPressure.psi)
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at altitude: Length
  ) {
    self.init(
      for: .init(altitude: altitude),
      with: .partialPressure(for: temperature, at: humidity)
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    for temperature: Temperature,
    with humidity: RelativeHumidity,
    at totalPressure: Pressure
  ) {
    self.init(
      for: totalPressure,
      with: .partialPressure(for: temperature, at: humidity)
    )
  }
}

extension HumidityRatio: RawNumericType {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
}
