import Core
import Foundation

/// Represents the humidity ratio (or mixing ratio) of a given moist air sample.
///
/// Defined as the ratio of the mass of water vapor to the mass of dry air in the sample and is often represented
/// by the symbol `W` in the ASHRAE Fundamentals (2017).
///
public struct HumidityRatio: Equatable {
  
  /// Constant for the mole weight of water.
  public static let moleWeightWater = 18.015268

  /// Constant for the mole weight of air.
  public static let moleWeightAir = 28.966
  
  /// Constant for the ratio of the mole weight of water over the mole weight of air.
  public static let moleWeightRatio = (Self.moleWeightWater / Self.moleWeightAir)
  
  /// The raw humidity ratio.
  public var rawValue: Double

  /// Create a new ``HumidityRatio`` with the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw humidity ratio value.
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
    self.init(Self.moleWeightRatio * (waterMass / dryAirMass))
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
      Self.moleWeightRatio * partialPressure.psi
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
