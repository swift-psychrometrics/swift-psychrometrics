import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

/// Calculate the psychrometric properties of an air sample.
fileprivate struct PsychrometricResponseEnvelope: Codable, Equatable, Sendable {

  @Dependency(\.psychrometricEnvironment) static var environment
  let psychrometrics: PsychrometricResponse

  public init(
    dryBulb temperature: Temperature,
    wetBulb: WetBulb,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    let units = units ?? Self.environment.units
    let humidityRatio = await HumidityRatio(
      dryBulb: temperature,
      wetBulb: wetBulb,
      pressure: totalPressure,
      units: units
    )
    let relativeHumidity = await RelativeHumidity.init(
      dryBulb: temperature,
      ratio: humidityRatio,
      pressure: totalPressure,
      units: units
    )
    
    self.psychrometrics = await .init(
      atmosphericPressure: totalPressure,
      degreeOfSaturation: Self.degreeOfSaturation(
        dryBulb: temperature,
        ratio: humidityRatio,
        pressure: totalPressure,
        units: units
      ),
      density: .init(for: temperature, at: relativeHumidity, pressure: totalPressure, units: units),
      dewPoint: await .init(dryBulb: temperature, humidity: relativeHumidity, units: units),
      dryBulb: temperature,
      enthalpy: .init(dryBulb: temperature, ratio: humidityRatio, units: units),
      humidityRatio: humidityRatio,
      relativeHumidity: relativeHumidity,
      vaporPressure: .init(ratio: humidityRatio, pressure: totalPressure, units: units),
      volume: .init(
        dryBulb: temperature,
        ratio: humidityRatio,
        pressure: totalPressure,
        units: units
      ),
      wetBulb: wetBulb,
      units: units
    )
    
    
  }

  public init?(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    
    let units = units ?? Self.environment.units
    
    guard let wetBulb = await WetBulb(
        dryBulb: temperature,
        humidity: relativeHumidity,
        pressure: totalPressure,
        units: units
      )
    else { return nil }
   
    let humidityRatio = await HumidityRatio(
      dryBulb: temperature,
      humidity: relativeHumidity,
      pressure: totalPressure,
      units: units
    )
    
    self.psychrometrics = await .init(
      atmosphericPressure: totalPressure,
      degreeOfSaturation: Self.degreeOfSaturation(
        dryBulb: temperature,
        ratio: humidityRatio,
        pressure: totalPressure,
        units: units
      ),
      density: .init(for: temperature, at: relativeHumidity, pressure: totalPressure, units: units),
      dewPoint: await .init(
        dryBulb: temperature,
        ratio: humidityRatio,
        pressure: totalPressure,
        units: units
      ),
      dryBulb: temperature,
      enthalpy: .init(dryBulb: temperature, ratio: humidityRatio, units: units),
      humidityRatio: humidityRatio,
      relativeHumidity: relativeHumidity,
      vaporPressure: .init(ratio: humidityRatio, pressure: totalPressure, units: units),
      volume: .init(
        dryBulb: temperature,
        ratio: humidityRatio,
        pressure: totalPressure,
        units: units
      ),
      wetBulb: wetBulb,
      units: units
    )

  }

  public init?(
    dryBulb temperature: Temperature,
    dewPoint: DewPoint,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    let units = units ?? Self.environment.units
    
    let humidityRatio = await HumidityRatio(
      dewPoint: dewPoint,
      pressure: totalPressure,
      units: units
    )
    
    guard
      let wetBulb = await WetBulb(
        dryBulb: temperature,
        ratio: humidityRatio,
        pressure: totalPressure,
        units: units
      )
    else { return nil }
    
    let relativeHumidity = await RelativeHumidity.init(
      dryBulb: temperature,
      ratio: humidityRatio,
      pressure: totalPressure,
      units: units
    )
    
    self.psychrometrics = await .init(
      atmosphericPressure: totalPressure,
      degreeOfSaturation:  Self.degreeOfSaturation(
        dryBulb: temperature,
        ratio: humidityRatio,
        pressure: totalPressure,
        units: units
      ),
      density: .init(for: temperature, at: relativeHumidity, pressure: totalPressure, units: units),
      dewPoint: dewPoint,
      dryBulb: temperature,
      enthalpy: .init(dryBulb: temperature, ratio: humidityRatio, units: units),
      humidityRatio: humidityRatio,
      relativeHumidity: relativeHumidity,
      vaporPressure: .init(ratio: humidityRatio, pressure: totalPressure, units: units),
      volume: .init(
        dryBulb: temperature,
        ratio: humidityRatio,
        pressure: totalPressure,
        units: units
      ),
      wetBulb: wetBulb,
      units: units
    )

  }

  public static func degreeOfSaturation(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async -> Double {
    precondition(humidityRatio > 0)
    let saturatedRatio = await HumidityRatio.init(
      dryBulb: temperature,
      pressure: totalPressure,
      units: units
    )
    return humidityRatio.rawValue.rawValue / saturatedRatio.rawValue.rawValue
  }
}

extension PsychrometricResponse {
  public init(
    dryBulb temperature: Temperature,
    wetBulb: WetBulb,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    self = await PsychrometricResponseEnvelope(
      dryBulb: temperature,
      wetBulb: wetBulb,
      pressure: totalPressure,
      units: units
    ).psychrometrics
  }
  
  public init?(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    guard let value = await PsychrometricResponseEnvelope(
      dryBulb: temperature,
      humidity: relativeHumidity,
      pressure: totalPressure,
      units: units
    )
    else { return nil }
    self = value.psychrometrics
  }
  
  public init?(
    dryBulb temperature: Temperature,
    dewPoint: DewPoint,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    guard let value = await PsychrometricResponseEnvelope(
      dryBulb: temperature,
      dewPoint: dewPoint,
      pressure: totalPressure,
      units: units
    )
    else { return nil }
    self = value.psychrometrics
  }
}
