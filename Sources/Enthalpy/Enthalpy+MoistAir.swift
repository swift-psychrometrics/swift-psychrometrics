import Core
import Foundation
import HumidityRatio

extension Enthalpy where T == MoistAir {

  internal struct Constants {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricEnvironment.Units

    init(units: PsychrometricEnvironment.Units) {
      self.units = units
      self.c1 = units.isImperial ? 0.24 : 1.006
      self.c2 = units.isImperial ? 1061 : 2501
      self.c3 = units.isImperial ? 0.444 : 1.86
    }

    func run(dryBulb: Temperature, ratio: HumidityRatio) -> Double {
      let T = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let value = c1 * T + ratio.rawValue * (c2 + c3 * T)
      return units.isImperial ? value : value * 1000
    }

    func dryBulb(enthalpy: EnthalpyOf<MoistAir>, ratio: HumidityRatio) -> Temperature {
      let intermediateValue =
        units.isImperial
        ? enthalpy.rawValue - c2 * ratio.rawValue
        : enthalpy.rawValue / 1000 - c2 * ratio.rawValue
      let value = intermediateValue / (c1 + c3 * ratio.rawValue)
      return units.isImperial ? .fahrenheit(value) : .celsius(value)
    }
  }

  /// Create a new ``Enthalpy`` for the given temperature and humidity ratio.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the enthalpy for.
  ///   - humidityRatio: The humidity ratio to calculate the enthalpy for.
  ///   - units: The units to solve for, if not supplied then the ``Core.environment`` will be used.
  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    precondition(humidityRatio > 0)
    let units = units ?? environment.units
    let value = Constants(units: units).run(dryBulb: temperature, ratio: humidityRatio)
    self.init(value, units: .for(units))
  }

  /// Create a new ``Enthalpy`` for the given temperature and pressure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature to calculate the enthalpy for.
  ///   - totalPressure: The total atmospheric pressure to calculate the enthalpy for.
  ///   - units: The units to solve for, if not supplied then the ``Core.environment`` will be used.
  public init(
    dryBulb temperature: Temperature,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      dryBulb: temperature,
      ratio: .init(for: temperature, pressure: totalPressure, units: units),
      units: units
    )
  }

  /// Create a new ``Enthalpy`` for the given temperature, relative humidity, and pressure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature to calculate the enthalpy for.
  ///   - humidity: The relative humidity to calculate the enthalpy for.
  ///   - totalPressure: The total atmospheric pressure to calculate the enthalpy for.
  ///   - units: The units to solve for, if not supplied then the ``Core.environment`` will be used.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      dryBulb: temperature,
      ratio: .init(for: temperature, at: humidity, pressure: totalPressure, units: units),
      units: units
    )
  }

  /// Create a new ``Enthalpy`` for the given temperature, relative humidity, and pressure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature to calculate the enthalpy for.
  ///   - humidity: The relative humidity to calculate the enthalpy for.
  ///   - altitude: The altitude to calculate the enthalpy for.
  ///   - units: The units to solve for, if not supplied then the ``Core.environment`` will be used.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel,
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
