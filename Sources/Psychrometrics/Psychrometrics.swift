import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

// TODO: These types need to be codable.

/// Calculate the psychrometric properties of an air sample.
public struct Psychrometrics {

  @Dependency(\.psychrometricEnvironment) static var environment

  public let atmosphericPressure: Pressure
  public let degreeOfSaturation: Double
  public let density: DensityOf<MoistAir>
  public let dewPoint: DewPoint
  public let dryBulb: Temperature
  public let enthalpy: MoistAirEnthalpy
  public let humidityRatio: HumidityRatio
  public let relativeHumidity: RelativeHumidity
  public let units: PsychrometricUnits
  public let vaporPressure: VaporPressure
  public let volume: SpecificVolumeOf<MoistAir>
  public let wetBulb: WetBulb

  public init(
    dryBulb temperature: Temperature,
    wetBulb: WetBulb,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.units = units ?? Self.environment.units
    self.atmosphericPressure = totalPressure
    self.dryBulb = temperature
    self.wetBulb = wetBulb
    self.humidityRatio = .init(
      dryBulb: temperature, wetBulb: wetBulb, pressure: totalPressure, units: units)
    self.degreeOfSaturation = Self.degreeOfSaturation(
      dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.relativeHumidity = .init(
      dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.vaporPressure = .init(ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.enthalpy = .init(dryBulb: temperature, ratio: self.humidityRatio, units: units)
    self.volume = .init(
      dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure, units: units)
    self.dewPoint = .init(dryBulb: temperature, humidity: self.relativeHumidity, units: units)
    self.density = .init(for: dryBulb, at: relativeHumidity, pressure: totalPressure, units: units)
  }

  public init?(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.units = units ?? Self.environment.units
    self.atmosphericPressure = totalPressure
    self.dryBulb = temperature
    self.relativeHumidity = relativeHumidity
    self.humidityRatio = .init(
      dryBulb: temperature, humidity: relativeHumidity, pressure: totalPressure, units: units)
    guard
      let wetBulb = WetBulb(
        dryBulb: temperature,
        humidity: relativeHumidity,
        pressure: totalPressure,
        units: units
      )
    else { return nil }
    self.wetBulb = wetBulb
    self.degreeOfSaturation = Self.degreeOfSaturation(
      dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.dewPoint = .init(
      dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.vaporPressure = .init(ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.enthalpy = .init(dryBulb: temperature, ratio: self.humidityRatio, units: units)
    self.volume = .init(
      dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure, units: units)
    self.density = .init(for: dryBulb, at: relativeHumidity, pressure: totalPressure, units: units)

  }

  public init?(
    dryBulb temperature: Temperature,
    dewPoint: DewPoint,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.units = units ?? Self.environment.units
    self.atmosphericPressure = totalPressure
    self.dryBulb = temperature
    self.dewPoint = dewPoint
    self.humidityRatio = .init(dewPoint: dewPoint, pressure: totalPressure, units: units)
    self.relativeHumidity = .init(
      dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    guard
      let wetBulb = WetBulb(
        dryBulb: temperature,
        ratio: self.humidityRatio,
        pressure: totalPressure,
        units: units
      )
    else { return nil }
    self.wetBulb = wetBulb
    self.degreeOfSaturation = Self.degreeOfSaturation(
      dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.vaporPressure = .init(ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.enthalpy = .init(dryBulb: temperature, ratio: self.humidityRatio, units: units)
    self.volume = .init(
      dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure, units: units)
    self.density = .init(for: dryBulb, at: relativeHumidity, pressure: totalPressure, units: units)

  }

  public static func degreeOfSaturation(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) -> Double {
    precondition(humidityRatio > 0)
    let saturatedRatio = HumidityRatio.init(
      dryBulb: temperature, pressure: totalPressure, units: units)
    return humidityRatio.rawValue.rawValue / saturatedRatio.rawValue.rawValue
  }
}
