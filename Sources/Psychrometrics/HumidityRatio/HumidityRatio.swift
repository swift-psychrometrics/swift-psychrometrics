import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension HumidityRatio {
  @Dependency(\.psychrometricEnvironment) static var environment

  public static func ensureHumidityRatio(_ ratio: HumidityRatio) -> HumidityRatio {
    guard ratio.rawValue.rawValue > environment.minimumHumidityRatio else {
      return .init(.init(environment.minimumHumidityRatio))
    }
    return ratio
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
    self.init(.init(Self.moleWeightRatio * (waterMass / dryAirMass)))
  }

  internal init(
    totalPressure: Pressure,
    partialPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    let units = units ?? Self.environment.units
    let partialPressure =
      units.isImperial ? partialPressure.psi : partialPressure.pascals
    let totalPressure = units.isImperial ? totalPressure.psi : totalPressure.pascals

    self.init(
      .init(
        Self.moleWeightRatio * partialPressure
          / (totalPressure - partialPressure)
      )
    )
  }

  /// The  humidity ratio of the air for the given total pressure and vapor pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - vaporPressure: The partial pressure of the air.
  public init(
    totalPressure: Pressure,
    vaporPressure: VaporPressure,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      partialPressure: vaporPressure.rawValue,
      units: units
    )
  }

  /// The  humidity ratio of the air for the given total pressure and saturation pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - saturationPressure: The saturation of the air.
  public init(
    totalPressure: Pressure,
    saturationPressure: SaturationPressure,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      partialPressure: saturationPressure.rawValue,
      units: units
    )
  }

  /// The  humidity ratio of the air for the given dry bulb temperature and total pressure.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature of the air.
  ///   - totalPressure: The total pressure of the air.
  public init(
    dryBulb temperature: Temperature,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      saturationPressure: .init(at: temperature, units: units),
      units: units
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      partialPressure: VaporPressure(
        dryBulb: temperature,
        humidity: humidity,
        units: units
      ).rawValue,
      units: units
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      dryBulb: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude),
      units: units
    )
  }
}

//extension HumidityRatio: RawNumericType {
//  public typealias IntegerLiteralType = Double.IntegerLiteralType
//  public typealias FloatLiteralType = Double.FloatLiteralType
//  public typealias Magnitude = Double.Magnitude
//}
