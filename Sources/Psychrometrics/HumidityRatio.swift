import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

extension HumidityRatio {

  public static func ensureHumidityRatio(_ ratio: HumidityRatio) async -> HumidityRatio {
    @Dependency(\.psychrometricEnvironment) var environment;
    
    guard ratio.rawValue.rawValue > environment.minimumHumidityRatio else {
      return .init(.init(environment.minimumHumidityRatio))
    }
    return ratio
  }

  // TODO: Remove
  /// The humidity ratio of air for the given mass of water and mass of dry air.
  ///
  /// - Parameters:
  ///   - waterMass: The mass of the water in the air.
  ///   - dryAirMass: The mass of the dry air.
  public init(
    water waterMass: Double,
    dryAir dryAirMass: Double
  ) async {
    self.init(.init(Self.moleWeightRatio * (waterMass / dryAirMass)))
  }

  // TODO: Remove
  internal init(
    totalPressure: Pressure,
    partialPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async {
    @Dependency(\.psychrometricEnvironment) var environment;
    
    let units = units ?? environment.units
    let partialPressure =
      units.isImperial ? partialPressure.psi : partialPressure.pascals
    let totalPressure = units.isImperial ? totalPressure.psi : totalPressure.pascals

    self.init(
      .init(
        Self.moleWeightRatio * partialPressure
          / (totalPressure - partialPressure)
      )
    )
  }

  // TODO: Remove
  /// The  humidity ratio of the air for the given total pressure and vapor pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - vaporPressure: The partial pressure of the air.
  public init(
    totalPressure: Pressure,
    vaporPressure: VaporPressure,
    units: PsychrometricUnits? = nil
  ) async {
    await self.init(
      totalPressure: totalPressure,
      partialPressure: vaporPressure.rawValue,
      units: units
    )
  }

  // TODO: Remove
  /// The  humidity ratio of the air for the given total pressure and saturation pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - saturationPressure: The saturation of the air.
  public init(
    totalPressure: Pressure,
    saturationPressure: SaturationPressure,
    units: PsychrometricUnits? = nil
  ) async {
    await self.init(
      totalPressure: totalPressure,
      partialPressure: saturationPressure.rawValue,
      units: units
    )
  }

  // TODO: Remove
  /// The  humidity ratio of the air for the given dry bulb temperature and total pressure.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature of the air.
  ///   - totalPressure: The total pressure of the air.
  public init(
    dryBulb temperature: Temperature,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      totalPressure: totalPressure,
      saturationPressure: .init(at: temperature, units: units),
      units: units
    )
  }

  // TODO: Remove
  /// The humidity ratio of the air for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      totalPressure: totalPressure,
      partialPressure: VaporPressure(
        dryBulb: temperature,
        humidity: humidity,
        units: units
      ).rawValue,
      units: units
    )
  }

  // TODO: Remove
  /// The humidity ratio of the air for the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length,
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      dryBulb: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude),
      units: units
    )
  }
}

// MARK: - Specific Humidity
extension HumidityRatio {

  /// Create a new ``HumidityRatio`` from the given specific humidity.
  ///
  /// **Reference**:  ASHRAE Handbook - Fundamentals (2017) ch. 1 eqn 9b (solved for humidity ratio)
  ///
  /// - Parameters:
  ///   - specificHumidity: The specific humidity.
  public init(specificHumidity: SpecificHumidity) throws {
    guard specificHumidity.rawValue > 0.0 else {
      throw ValidationError(
        label: "Humidity Ratio",
        summary: "Specific humidity should be greater than 0"
      )
    }
    guard specificHumidity.rawValue < 1.0 else {
      throw ValidationError(
        label: "Humidity Ratio",
        summary: "Specific humidity should be less than 1.0"
      )
    }
    self.init(.init(specificHumidity.rawValue / (1 - specificHumidity.rawValue)))
  }
}

// MARK: - Wet Bulb

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

  // TODO: Remove

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
  ) async throws {
    guard dryBulb > wetBulb.rawValue else {
      throw ValidationError(
        label: "Humidity Ratio",
        summary: "Wet bulb temperature should be less than dry bulb temperature."
      )
    }

    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units

    let saturatedHumidityRatio = try await HumidityRatio(
      dryBulb: wetBulb.rawValue,
      pressure: pressure
    )
    
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

// MARK: - Enthalpy
extension HumidityRatio {

  private struct HumidityRatioConstants {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 0.24 : 1.006
      self.c2 = units.isImperial ? 1061 : 2501
      self.c3 = units.isImperial ? 0.444 : 1.86
    }

    func run(enthalpy: MoistAirEnthalpy, dryBulb: Temperature) async -> Double {
      let T = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let intermediateValue =
        units.isImperial
        ? enthalpy.rawValue.rawValue - c1 * T
        : enthalpy.rawValue.rawValue / 1000 - c1 * T

      return intermediateValue / (c2 + c3 * T)
    }
  }

  /// Calculate the ``HumidityRatio`` for the given enthalpy and temperature.
  ///
  /// - Parameters:
  ///   - enthalpy: The enthalpy of the air.
  ///   - temperature: The dry bulb temperature of the air.
  public init(
    enthalpy: MoistAirEnthalpy,
    dryBulb temperature: Temperature,
    units: PsychrometricUnits? = nil
  ) async {
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    
    let value = await HumidityRatioConstants(units: units)
      .run(enthalpy: enthalpy, dryBulb: temperature)
    
    self.init(.init(value))
  }
}

// MARK: - Dew Point
extension HumidityRatio {

  // TODO: Remove.
  /// Create a new ``HumidityRatio`` for the given dew point temperature and atmospheric pressure.
  ///
  ///  - Parameters:
  ///   - dewPoint: The dew point temperature.
  ///   - totalPressure: The total atmospheric pressure
  ///   - units: The units to solve for, if not supplied then ``Core.environment`` units will be used.
  public init(
    dewPoint: DewPoint,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      totalPressure: totalPressure,
      saturationPressure: SaturationPressure(at: dewPoint.rawValue, units: units),
      units: units
    )
  }
}
