import Dependencies
import PsychrometricEnvironment
import SharedModels

// MARK: - Enthalpy
extension Temperature {

  /// Calculates the ``Enthalpy`` of ``MoistAir`` for the temperature at a given relative humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  ///   - units: The units to solve for, if not supplied then this will default to ``Core.environment`` units.
  public func enthalpy(
    at humidity: RelativeHumidity,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) async throws -> MoistAirEnthalpy {
    try await .init(dryBulb: self, humidity: humidity, altitude: altitude, units: units)
  }

  /// Calculates the ``Enthalpy`` of ``MoistAir``  for the temperature at a given relative humidity and pressure.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - totalPressure: The pressure of the air.
  ///   - units: The units to solve for, if not supplied then this will default to ``Core.environment`` units.
  public func enthalpy(
    at humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws -> MoistAirEnthalpy {
    try await .init(dryBulb: self, humidity: humidity, pressure: totalPressure, units: units)
  }

  /// Calculates the ``Enthalpy`` of ``DryAir``  for the temperature.
  ///
  /// - Parameters:
  ///   - units: The units to solve for, if not supplied then this will default to ``Core.environment`` units.
  public func enthalpy(
    units: PsychrometricUnits? = nil
  ) async -> DryAirEnthalpy {
    await .init(dryBulb: self, units: units)
  }

  /// Calculate the dry bulb``Temperature`` for the given enthalpy and humidity ratio.
  ///
  /// - Parameters:
  ///   - enthalpy: The enthalpy to solve the temperature for.
  ///   - humidityRatio: The humidity ration to solve the temperature for.
  ///   - units: The units to solve for, if not supplied then this will default to ``Core.environment`` units.
  public init(
    enthalpy: MoistAirEnthalpy,
    ratio humidityRatio: HumidityRatio,
    units: PsychrometricUnits? = nil
  ) async throws {
    guard humidityRatio > 0 else {
      throw ValidationError(
        label: "Temperature",
        summary: "Humidity Ratio should be greater than 0."
      )
    }
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    self = await MoistAirEnthalpy.Constants(units: units).dryBulb(
      enthalpy: enthalpy, ratio: humidityRatio)
  }
}

// MARK: - Grains of Moisture

extension Temperature {

  /// Calculates the ``GrainsOfMoisture`` for the temperature at the given humidity and altitude.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public func grains(humidity: RelativeHumidity, altitude: Length = .seaLevel) async throws -> GrainsOfMoisture {
    try await .init(temperature: self, humidity: humidity, altitude: altitude)
  }
}

// MARK: - Specific Volume

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
    units: PsychrometricUnits? = nil
  ) async throws {

    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units

    guard specificVolume.units == SpecificVolumeUnits.defaultFor(units: units) else {
      throw ValidationError(
        label: "Temperature",
        summary: "Units do not match."
      )
    }

    let absoluteTemperature = await SpecificVolumeOf<MoistAir>
      .MoistAirConstants(units: units)
      .dryBulb(volume: specificVolume, ratio: humidityRatio, pressure: totalPressure)

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
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      volume: specificVolume, ratio: humidityRatio, pressure: .init(altitude: altitude),
      units: units)
  }
}
