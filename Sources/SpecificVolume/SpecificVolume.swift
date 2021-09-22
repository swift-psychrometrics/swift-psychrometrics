import Core
import Foundation
import HumidityRatio

// TODO: Add units.

/// Represents the specific volume of air for the conditions.  Currently only implemented as ft^3 / lb of dry air.
///
/// Often represented by the symbol `v` in ASHRAE Fundamentals (2017)
public struct SpecificVolume {

  /// The specific volume's raw value.
  public var rawValue: Double

  /// Create a new ``SpecificVolume`` for the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw value for the specific volume.
  public init(_ value: Double) {
    self.rawValue = value
  }

  /// Calculate the ``SpecificVolume`` for the given temperature, humidity ratio, and total pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidityRatio: The humidity ratio to calculate the specific volume for.
  ///   - totalPressure: The total pressure to calculate the specific volume for.
  public init(
    for temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure
  ) {
    self.init(
      0.370486
        * temperature.rankine
        * (1 + 1.607858 * humidityRatio)
        / totalPressure.psi
    )
  }

  /// Calculate the ``SpecificVolume`` for the given temperature, relative humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidity: The relative humidity to calculate the specific volume for.
  ///   - totalPressure: The total pressure to calculate the specific volume for.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    pressure totalPressure: Pressure
  ) {
    self.init(
      for: temperature,
      ratio: HumidityRatio(for: temperature, at: humidity, pressure: totalPressure),
      pressure: totalPressure
    )
  }

  /// Calculate the ``SpecificVolume`` for the given temperature, relative humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidity: The relative humidity to calculate the specific volume for.
  ///   - altitude: The altitude to calculate the specific volume for.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.init(
      for: temperature,
      at: humidity,
      pressure: .init(altitude: altitude)
    )
  }
}

public struct SpecificVolume2<T> {

  public private(set) var rawValue: Double

  public private(set) var units: SpecificVolumeUnits

  public init(_ value: Double, units: SpecificVolumeUnits = .default) {
    self.rawValue = value
    self.units = units
  }
}

public typealias SpecificVolumeOf<T> = SpecificVolume2<T>

public enum SpecificVolumeUnits: UnitOfMeasure {

  case cubicFeetPerPound
  case cubicMeterPerKilogram

  public static var `default`: Self = .cubicFeetPerPound

  internal static func `for`(_ units: PsychrometricEnvironment.Units) -> Self {
    switch units {
    case .metric: return .cubicMeterPerKilogram
    case .imperial: return .cubicFeetPerPound
    }
  }
}

extension SpecificVolume2: NumberWithUnitOfMeasure {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias Units = SpecificVolumeUnits

  public static func keyPath(for units: SpecificVolumeUnits) -> WritableKeyPath<
    SpecificVolume2<T>, Double
  > {
    \.rawValue
  }
}

extension SpecificVolume: RawNumericType {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
}
