import Core
import Foundation
import HumidityRatio

extension HumidityRatio {

  private struct ConstantsAboveFreezing {

    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double

    let units: PsychrometricEnvironment.Units

    init(units: PsychrometricEnvironment.Units) {
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
      return ((c1 - c2 * wetBulb) * saturatedHumidityRatio - c3 * (dryBulb - wetBulb))
        / (c1 + c4 * dryBulb - wetBulb)
    }
  }

  private struct ConstantsBelowFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let units: PsychrometricEnvironment.Units

    init(units: PsychrometricEnvironment.Units) {
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
      return ((c1 - c2 * wetBulb) * saturatedHumidityRatio - c3 * diff)
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
    units: PsychrometricEnvironment.Units? = nil
  ) {
    precondition(dryBulb > wetBulb.temperature)

    let units = units ?? environment.units

    let saturatedHumidityRatio = HumidityRatio(for: wetBulb.temperature, pressure: pressure)
    if wetBulb.temperature > environment.triplePointOfWater(for: units) {
      self.init(
        ConstantsBelowFreezing(units: environment.units)
          .run(dryBulb: dryBulb, wetBulb: wetBulb, saturatedHumidityRatio: saturatedHumidityRatio)
      )
    } else {
      self.init(
        ConstantsAboveFreezing(units: environment.units)
          .run(dryBulb: dryBulb, wetBulb: wetBulb, saturatedHumidityRatio: saturatedHumidityRatio)
      )
    }
  }
}
