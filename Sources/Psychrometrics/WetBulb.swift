import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension WetBulb {

  /// Create a new ``WetBulb`` for the given temperature and relative humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate wet-bulb for.
  ///   - relativeHumidity: The relative humidity.
  ///   - totalPressure: The atmospheric pressure.
  ///   -
  public init?(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      dryBulb: temperature,
      ratio: .init(
        dryBulb: temperature, humidity: relativeHumidity, pressure: totalPressure, units: units),
      pressure: totalPressure,
      units: units
    )
  }
}

extension WetBulb {

  public init?(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {

    @Dependency(\.psychrometricEnvironment) var environment

    guard
      let wetBulb = try? await wetBulb_from_humidity_ratio(
        dryBulb: temperature,
        humidityRatio: humidityRatio,
        pressure: totalPressure,
        units: units ?? environment.units
      )
    else { return nil }
    self = wetBulb
  }
}

// Helper to solve wet bulb for the humidity ratio.
private func wetBulb_from_humidity_ratio(
  dryBulb: Temperature,
  humidityRatio: HumidityRatio,
  pressure: Pressure,
  units: PsychrometricUnits
) async throws -> WetBulb? {
  guard humidityRatio > 0 else {
    throw ValidationError(
      label: "Wet Bulb",
      summary: "Humidity ratio should be greater than 0."
    )
  }

  @Dependency(\.psychrometricEnvironment) var environment

  let dewPoint = try await DewPoint(dryBulb: dryBulb, ratio: humidityRatio, pressure: pressure, units: units)
  let temperatureUnits = units.isImperial ? Temperature.Units.fahrenheit : .celsius

  // Initial guesses
  var wetBulbSup = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
  var wetBulbInf = units.isImperial ? dewPoint.fahrenheit : dewPoint.celsius
  var wetBulb = (wetBulbInf + wetBulbSup) / 2

  var index = 1

  while (wetBulbSup - wetBulbInf) > environment.temperatureTolerance.rawValue {
    let ratio = try await HumidityRatio(
      dryBulb: dryBulb,
      wetBulb: .init(.init(wetBulb, units: temperatureUnits)),
      pressure: pressure,
      units: units
    )

    if ratio > humidityRatio {
      wetBulbSup = wetBulb
    } else {
      wetBulbInf = wetBulb
    }

    // new guess of wet bulb
    wetBulb = (wetBulbSup + wetBulbInf) / 2

    if index >= environment.maximumIterationCount {
      return nil
    }

    index += 1
  }

  return .init(.init(wetBulb, units: temperatureUnits))
}
