import Foundation
@_exported import Core
import HumidityRatio
import SpecificVolume

/// Represents the mass per unit of volume.
///
/// Often represented by `ρ` in ASHRAE Fundamentals (2017)
///
public struct Density<T> {
  
  /// The raw value of the density.
  public var rawValue: Double
  
  /// Create a new ``Density`` with the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw value of the density.
  public init(_ value: Double) {
    self.rawValue = value
  }
}

public typealias DensityOf<T> = Density<T>

// MARK: - Water
extension Density where T == Water {
  
  /// Create a new ``Density<Water>`` for the given temperature.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the density for.
  public init(for temperature: Temperature) {
    self.init(
      62.56
      + 3.413
      * (pow(10, -4) * temperature.fahrenheit)
      - 6.255
      * pow((pow(10, -5) * temperature.fahrenheit), 2)
    )
  }
}

// MARK: - DryAir
extension Density where T == DryAir {
  
  /// Create a new ``Density<DryAir>`` for the given temperature and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the density for.
  ///   - totalPressure: The pressure to calculate the density for.
  public init(
    for temperature: Temperature,
    pressure totalPressure: Pressure
  ) {
    self.init(
      (
        (29.0 * (totalPressure.psi))
        / (345.23 * temperature.rankine)
      )
      * 32.174
    )
  }
  
  /// Create a new ``Density<DryAir>`` for the given temperature and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the density for.
  ///   - altitude: The altitude to calculate the density for.
  public init(
    for temperature: Temperature,
    altitude: Length = .seaLevel
  ) {
    self.init(for: temperature, pressure: .init(altitude: altitude))
  }
}

// MARK: - MoistAir
extension Density where T == MoistAir {
  
  /// Create a new ``Density<MoistAir>`` for the given specific volume and humidity ratio.
  ///
  /// - Parameters:
  ///   - specificVolume: The specific volume to calculate the density for.
  ///   - humidityRatio: The humidity ratio to calculate the density for.
  public init(
    volume specificVolume: SpecificVolume,
    ratio humidityRatio: HumidityRatio
  ) {
    self.init(
      (1 / specificVolume) * (1 + humidityRatio)
    )
  }

  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    pressure totalPressure: Pressure
  ) {
    self.init(
      volume: .init(for: temperature, at: humidity, pressure: totalPressure),
      ratio: .init(for: temperature, at: humidity, pressure: totalPressure)
    )
  }
}

extension Density: RawNumericType {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
}
