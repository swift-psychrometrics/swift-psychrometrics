import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

// MARK: - Dry Air
extension DryAirEnthalpy {

  private struct DryAirConstants {
    let specificHeat: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) async {
      self.units = units
      self.specificHeat = units.isImperial ? 0.24 : 1006
    }

    func run(_ dryBulb: Temperature) async -> Double {
      let T = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      return specificHeat * T
    }
  }

  /// Create a new ``Enthalpy`` of ``Core.DryAir`` for the given dry bulb temperature and unit of measure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1 eq 28
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature in °F [IP] or °C [SI].
  ///   - units: The unit of measure, if not supplied then we will resolve from the ``Core.environment`` setting.
  public init(
    dryBulb temperature: Temperature,
    units: PsychrometricUnits? = nil
  ) async {
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let value = await DryAirConstants(units: units).run(temperature)
    self.init(Enthalpy(value, units: .defaultFor(units: units)))
  }
}

// MARK: - Moist Air

extension MoistAirEnthalpy {

  internal struct Constants {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) async {
      self.units = units
      self.c1 = units.isImperial ? 0.24 : 1.006
      self.c2 = units.isImperial ? 1061 : 2501
      self.c3 = units.isImperial ? 0.444 : 1.86
    }

    func run(dryBulb: Temperature, ratio: HumidityRatio) async -> Double {
      let T = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let value = c1 * T + ratio.rawValue * (c2 + c3 * T)
      return units.isImperial ? value : value * 1000
    }

    func dryBulb(enthalpy: MoistAirEnthalpy, ratio: HumidityRatio) async -> Temperature {
      let intermediateValue =
        units.isImperial
        ? enthalpy.rawValue.rawValue - c2 * ratio.rawValue
        : enthalpy.rawValue.rawValue / 1000 - c2 * ratio.rawValue
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
    units: PsychrometricUnits? = nil
  ) async throws {
    
    guard humidityRatio > 0 else {
      throw ValidationError(
        label: "Moist Air Enthalpy",
        summary: "Humidity ratio should be greater than 0."
      )
    }

    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let value = await Constants(units: units).run(dryBulb: temperature, ratio: humidityRatio)
    self.init(Enthalpy(value, units: .defaultFor(units: units)))
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
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      dryBulb: temperature,
      ratio: .init(dryBulb: temperature, pressure: totalPressure, units: units),
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
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      dryBulb: temperature,
      ratio: .init(
        dryBulb: temperature,
        humidity: humidity,
        pressure: totalPressure,
        units: units
      ),
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
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      dryBulb: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}

extension MoistAirEnthalpy {

  /// Calculate the ``HumidityRatio`` for the given temperature.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature of the air.
  public func humidityRatio(at temperature: Temperature) async -> HumidityRatio {
    await .init(enthalpy: self, dryBulb: temperature)
  }
}
