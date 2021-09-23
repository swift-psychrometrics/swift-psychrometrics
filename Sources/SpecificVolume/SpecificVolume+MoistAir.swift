import Core
import Foundation
import HumidityRatio

extension SpecificVolume where T == MoistAir {

  fileprivate struct Constants {
    let universalGasConstant: Double
    let c1: Double = 1.607858
    let units: PsychrometricEnvironment.Units

    init(units: PsychrometricEnvironment.Units) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: Temperature, ratio: HumidityRatio, pressure: Pressure) -> Double {
      let T = units.isImperial ? dryBulb.rankine : dryBulb.kelvin
      let P = units.isImperial ? pressure.psi : pressure.pascals
      let intermediateValue = universalGasConstant * T * (1 + c1 * ratio.rawValue)
      return units.isImperial ? intermediateValue / (144 * P) : intermediateValue / P
    }

    // inverts the calculation to solve for dry-bulb
    func dryBulb(volume: SpecificVolumeOf<MoistAir>, ratio: HumidityRatio, pressure: Pressure)
      -> Temperature
    {
      let P = units.isImperial ? pressure.psi : pressure.pascals
      let c2 = units.isImperial ? 144.0 : 1.0
      let value = volume.rawValue * (c2 * P) / (universalGasConstant * (1 + c2 * ratio.rawValue))
      print("value: \(value)")
      return units.isImperial ? .rankine(value) : .kelvin(value)
    }
  }

  /// Calculate the ``SpecificVolume`` for ``Core.MoistAir`` the given temperature,humidity ratio, and total pressure.
  ///
  /// **References**: ASHRAE - Fundamentals (2017) ch. 1 eq. 26
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidityRatio: The humidity ratio to calculate the specific volume for.
  ///   - totalPressure: The total pressure to calculate the specific volume for.
  ///   - units: The unit of measure to solve for, if not supplied then ``Core.environment`` value will be used.
  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    precondition(humidityRatio.rawValue > 0)
    let units = units ?? environment.units
    let value = Constants(units: units)
      .run(dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure)
    self.init(value, units: .for(units))
  }

  /// Calculate the ``SpecificVolume`` for ``Core.MoistAir`` the given temperature,humidity ratio, and total pressure.
  ///
  /// **References**: ASHRAE - Fundamentals (2017) ch. 1 eq. 26
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidity: The relative humidity to calculate the specific volume for.
  ///   - altitude: The altitude to calculate the specific volume for.
  ///   - units: The unit of measure to solve for, if not supplied then ``Core.environment`` value will be used.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      dryBulb: temperature,
      ratio: .init(for: temperature, pressure: totalPressure),
      pressure: totalPressure,
      units: units
    )
  }

  /// Calculate the ``SpecificVolume`` for ``Core.MoistAir`` the given temperature,humidity ratio, and total pressure.
  ///
  /// **References**: ASHRAE - Fundamentals (2017) ch. 1 eq. 26
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidity: The relative humidity to calculate the specific volume for.
  ///   - altitude: The altitude to calculate the specific volume for.
  ///   - units: The unit of measure to solve for, if not supplied then ``Core.environment`` value will be used.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      dryBulb: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}

extension Temperature {

  /// Create a new dry bulb ``Temperature`` for the given specific volume, humidity ratio, and total pressure.
  ///
  /// **Reference**:
  ///   ASHRAE - Fundamentals (2017) ch. 1 eq 26 rearranged to solve for dry bulb temperature.
  ///
  /// - Parameters:
  ///   - specificVolume: The specific volume of the moist air sample, this should be in the same unit of measure as the result we are calculating for.
  ///   - humidityRatio: The humidity ratio.
  ///   - totalPressure: The total pressure of the air sample.
  ///   - units: The unit of measure to solve the dry-bulb temperature for, if not supplied then we will use ``Core.environment`` value.
  public init(
    volume specificVolume: SpecificVolumeOf<MoistAir>,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {

    let units = units ?? environment.units

    precondition(specificVolume.units == SpecificVolumeUnits.for(units))

    let absoluteTemperature = SpecificVolumeOf<MoistAir>.Constants(units: units)
      .dryBulb(volume: specificVolume, ratio: humidityRatio, pressure: totalPressure)

    print("abs: \(absoluteTemperature)")
    // Convert the absolute temperature appropriately for the given units.
    self =
      units.isImperial
      ? .fahrenheit(absoluteTemperature.fahrenheit)
      : .celsius(absoluteTemperature.celsius)
  }

  /// Create a new dry bulb ``Temperature`` for the given specific volume, humidity ratio, and altitude.
  ///
  /// **Reference**:
  ///   ASHRAE - Fundamentals (2017) ch. 1 eq 26 rearranged to solve for dry bulb temperature.
  ///
  /// - Parameters:
  ///   - specificVolume: The specific volume of the moist air sample, this should be in the same unit of measure as the result we are calculating for.
  ///   - humidityRatio: The humidity ratio.
  ///   - altitude: The altitude of the air sample.
  ///   - units: The unit of measure to solve the dry-bulb temperature for, if not supplied then we will use ``Core.environment`` value.
  public init(
    volume specificVolume: SpecificVolumeOf<MoistAir>,
    ratio humidityRatio: HumidityRatio,
    altitude: Length,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      volume: specificVolume, ratio: humidityRatio, pressure: .init(altitude: altitude),
      units: units)
  }
}
