import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension HumidityRatio {

  private struct ConstantsAboveFreezing {

    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double

    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.c1 = units.isImperial ? 1093 : 2501
      self.c2 = units.isImperial ? 0.556 : 2.326
      self.c3 = units.isImperial ? 0.24 : 1.006
      self.c4 = units.isImperial ? 0.444 : 1.86
      self.units = units
    }

    func run(
      dryBulb: Temperature,
      wetBulb: WetBulb,
      saturatedHumidityRatio: HumidityRatio
    ) -> Double {
      let dryBulb = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let wetBulb = units.isImperial ? wetBulb.fahrenheit : wetBulb.celsius
      return ((c1 - c2 * wetBulb) * saturatedHumidityRatio.rawValue - c3 * (dryBulb - wetBulb))
        / (c1 + c4 * dryBulb - wetBulb)
    }
  }

  private struct ConstantsBelowFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.c1 = units.isImperial ? 1220 : 2830
      self.c2 = units.isImperial ? 0.04 : 0.24
      self.c3 = units.isImperial ? 0.24 : 1.006
      self.c4 = units.isImperial ? 0.44 : 1.86
      self.c5 = units.isImperial ? 0.48 : 2.1
      self.units = units
    }

    func run(
      dryBulb: Temperature,
      wetBulb: WetBulb,
      saturatedHumidityRatio: HumidityRatio
    ) -> Double {
      let dryBulb = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let wetBulb = units.isImperial ? wetBulb.fahrenheit : wetBulb.celsius
      let diff = dryBulb - wetBulb
      return ((c1 - c2 * wetBulb) * saturatedHumidityRatio.rawValue - c3 * diff)
        / (c1 + c4 * dryBulb - c5 * wetBulb)
    }
  }

  /// Create a new ``HumidityRatio`` for the given dry bulb temperature, wet bulb temperature and pressure.
  ///
  ///  - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - wetBulb: The wet bulb temperature.
  ///   - pressure: The total pressure.
  public init(
    dryBulb: Temperature,
    wetBulb: WetBulb,
    pressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    precondition(dryBulb > wetBulb.rawValue)

    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units

    let saturatedHumidityRatio = HumidityRatio(dryBulb: wetBulb.rawValue, pressure: pressure)
    if wetBulb.rawValue > PsychrometricEnvironment.triplePointOfWater(for: units) {
      self.init(
        .init(
          ConstantsBelowFreezing(units: units)
            .run(dryBulb: dryBulb, wetBulb: wetBulb, saturatedHumidityRatio: saturatedHumidityRatio)
        )
      )
    } else {
      self.init(
        .init(
          ConstantsAboveFreezing(units: units)
            .run(dryBulb: dryBulb, wetBulb: wetBulb, saturatedHumidityRatio: saturatedHumidityRatio)
        )
      )
    }
  }
}

extension WetBulb {

  public init?(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {

    @Dependency(\.psychrometricEnvironment) var environment

    guard
      let wetBulb = try? wetBulb_from_humidity_ratio(
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
) throws -> WetBulb? {
  precondition(humidityRatio > 0)

  @Dependency(\.psychrometricEnvironment) var environment

  let dewPoint = DewPoint(dryBulb: dryBulb, ratio: humidityRatio, pressure: pressure, units: units)
  let temperatureUnits = units.isImperial ? Temperature.Units.fahrenheit : .celsius

  // Initial guesses
  var wetBulbSup = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
  var wetBulbInf = units.isImperial ? dewPoint.fahrenheit : dewPoint.celsius
  var wetBulb = (wetBulbInf + wetBulbSup) / 2

  var index = 1

  while (wetBulbSup - wetBulbInf) > environment.temperatureTolerance.rawValue {
    let ratio = HumidityRatio(
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
