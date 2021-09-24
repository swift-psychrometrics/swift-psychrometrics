import Foundation
import CoreUnitTypes

/// Calculate the psychrometric properties of an air sample.
public struct Psychrometrics {
  
  public let degreeOfSaturation: Double
  public let dewPoint: DewPoint
  public let enthalpy: EnthalpyOf<MoistAir>
  public let humidityRatio: HumidityRatio
  public let relativeHumidity: RelativeHumidity
  public let vaporPressure: VaporPressure
  public let volume: SpecificVolumeOf<MoistAir>
  public let wetBulb: WetBulb
  
  public init(
    dryBulb temperature: Temperature,
    wetBulb: WetBulb,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.wetBulb = wetBulb
    self.humidityRatio = .init(dryBulb: temperature, wetBulb: wetBulb, pressure: totalPressure, units: units)
    self.degreeOfSaturation = Self.degreeOfSaturation(dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
//    self.dewPoint = .init(dryBulb: temperature, wetBulb: wetBulb, pressure: totalPressure, units: units)
    self.relativeHumidity = .init(dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.vaporPressure = .init(ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.enthalpy = .init(dryBulb: temperature, ratio: self.humidityRatio, units: units)
    self.volume = .init(dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure, units: units)
    self.dewPoint = .init(dryBulb: temperature, humidity: self.relativeHumidity, units: units)
  }
  
  public init?(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.relativeHumidity = relativeHumidity
    self.humidityRatio = .init(dryBulb: temperature, humidity: relativeHumidity, pressure: totalPressure, units: units)
    guard let wetBulb = WetBulb(
      dryBulb: temperature,
      humidity: relativeHumidity,
      pressure: totalPressure,
      units: units
    )
    else { return nil }
    self.wetBulb = wetBulb
    self.degreeOfSaturation = Self.degreeOfSaturation(dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.dewPoint = .init(dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.vaporPressure = .init(ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.enthalpy = .init(dryBulb: temperature, ratio: self.humidityRatio, units: units)
    self.volume = .init(dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure, units: units)
  }
  
  public init?(
    dryBulb temperature: Temperature,
    dewPoint: DewPoint,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.dewPoint = dewPoint
    self.humidityRatio = .init(dewPoint: dewPoint, pressure: totalPressure, units: units)
    self.relativeHumidity = .init(dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    guard let wetBulb = WetBulb(
      dryBulb: temperature,
      ratio: self.humidityRatio,
      pressure: totalPressure,
      units: units
    )
    else { return nil }
    self.wetBulb = wetBulb
    self.degreeOfSaturation = Self.degreeOfSaturation(dryBulb: temperature, ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.vaporPressure = .init(ratio: self.humidityRatio, pressure: totalPressure, units: units)
    self.enthalpy = .init(dryBulb: temperature, ratio: self.humidityRatio, units: units)
    self.volume = .init(dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure, units: units)
  }
  
  public static func degreeOfSaturation(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) -> Double {
    precondition(humidityRatio > 0)
    let saturatedRatio = HumidityRatio.init(dryBulb: temperature, pressure: totalPressure, units: units)
    return humidityRatio.rawValue / saturatedRatio.rawValue
  }
}
