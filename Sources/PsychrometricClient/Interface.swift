@_exported import Dependencies
import Foundation
@_exported import PsychrometricEnvironment
@_exported import SharedModels

/// Performs calculations for different psychrometric properties.
public struct PsychrometricClient {

  /// Perform degree of saturation calculations  / conversions
  public var degreeOfSaturation:
    @Sendable (DegreeOfSaturationRequest) async throws -> DegreeOfSaturation

  /// Perform density calculations / conversions.
  public var density: DensityClient

  /// Perform dew-point temperature calculations / conversions.
  public var dewPoint: @Sendable (DewPointRequest) async throws -> DewPoint

  /// Perform enthalpy calculations / conversions.
  public var enthalpy: EnthalpyClient

  /// Perform grains of moisture calculations / conversions.
  public var grainsOfMoisture: @Sendable (GrainsOfMoistureRequest) async throws -> GrainsOfMoisture

  /// Perform humidity ratio calculations / conversions.
  public var humidityRatio: @Sendable (HumidityRatioRequest) async throws -> HumidityRatio

  /// Perform multiple calculations to return the psychrometric properties of an air stream / sample.
  public var psychrometricProperties:
    @Sendable (PsychrometricPropertiesRequest) async throws -> PsychrometricProperties

  /// Perform relative humidity calculations / conversions.
  public var relativeHumidity: @Sendable (RelativeHumidityRequest) async throws -> RelativeHumidity

  /// Perform saturation pressure calculations / conversions.
  public var saturationPressure:
    @Sendable (SaturationPressureRequest) async throws -> SaturationPressure

  /// Perform specific heat calculations / conversions.
  public var specificHeat: SpecificHeatClient

  /// Perform specific humidity calculations / conversions.
  public var specificHumidity: @Sendable (SpecificHumidityRequest) async throws -> SpecificHumidity

  /// Perform specific volume calculations / conversions.
  public var specificVolume: SpecificVolumeClient

  /// Perform vapor pressure calculations / conversions.
  public var vaporPressure: @Sendable (VaporPressureRequest) async throws -> VaporPressure

  /// Perform wet-bulb calculations / conversions.
  public var wetBulb: @Sendable (WetBulbRequest) async throws -> WetBulb

  public init(
    degreeOfSaturation: @escaping @Sendable (DegreeOfSaturationRequest) async throws ->
      DegreeOfSaturation,
    density: DensityClient,
    dewPoint: @escaping @Sendable (DewPointRequest) async throws -> DewPoint,
    enthalpy: EnthalpyClient,
    grainsOfMoisture: @escaping @Sendable (GrainsOfMoistureRequest) async throws ->
      GrainsOfMoisture,
    humidityRatio: @escaping @Sendable (HumidityRatioRequest) async throws -> HumidityRatio,
    psychrometricProperties: @escaping @Sendable (PsychrometricPropertiesRequest) async throws ->
      PsychrometricProperties,
    relativeHumidity: @escaping @Sendable (RelativeHumidityRequest) async throws ->
      RelativeHumidity,
    saturationPressure: @escaping @Sendable (SaturationPressureRequest) async throws ->
      SaturationPressure,
    specificHeat: SpecificHeatClient,
    specificHumidity: @escaping @Sendable (SpecificHumidityRequest) async throws ->
      SpecificHumidity,
    specificVolume: SpecificVolumeClient,
    vaporPressure: @escaping @Sendable (VaporPressureRequest) async throws -> VaporPressure,
    wetBulb: @escaping @Sendable (WetBulbRequest) async throws -> WetBulb
  ) {
    self.degreeOfSaturation = degreeOfSaturation
    self.density = density
    self.dewPoint = dewPoint
    self.enthalpy = enthalpy
    self.grainsOfMoisture = grainsOfMoisture
    self.humidityRatio = humidityRatio
    self.psychrometricProperties = psychrometricProperties
    self.relativeHumidity = relativeHumidity
    self.saturationPressure = saturationPressure
    self.specificHeat = specificHeat
    self.specificHumidity = specificHumidity
    self.specificVolume = specificVolume
    self.vaporPressure = vaporPressure
    self.wetBulb = wetBulb
  }

  public struct DegreeOfSaturationRequest: Equatable, Sendable {
    public let dryBulb: DryBulb
    public let humidityRatio: HumidityRatio
    public let totalPressure: TotalPressure
    public let units: PsychrometricUnits?

    public static func dryBulb(
      _ dryBulb: DryBulb,
      humidityRatio: HumidityRatio,
      totalPressure: TotalPressure,
      units: PsychrometricUnits? = nil
    ) -> Self {
      .init(
        dryBulb: dryBulb,
        humidityRatio: humidityRatio,
        totalPressure: totalPressure,
        units: units
      )
    }
  }

  /// Perform density calculations.
  public struct DensityClient {

    /// Calculate the density of dry air for the given request.
    public var dryAir: @Sendable (DryAirRequest) async throws -> DensityOf<DryAir>

    /// Calculate the density of moist air for the given request.
    public var moistAir: @Sendable (MoistAirRequest) async throws -> DensityOf<MoistAir>

    /// Calculate the density of water for the given temperature.
    public var water: @Sendable (DryBulb) async throws -> DensityOf<Water>

    public init(
      dryAir: @escaping @Sendable (DryAirRequest) async throws -> DensityOf<DryAir>,
      moistAir: @escaping @Sendable (MoistAirRequest) async throws -> DensityOf<MoistAir>,
      water: @escaping @Sendable (DryBulb) async throws -> DensityOf<Water>
    ) {
      self.dryAir = dryAir
      self.moistAir = moistAir
      self.water = water
    }

    public struct DryAirRequest: Equatable, Sendable {
      public let dryBulb: DryBulb
      public let totalPressure: TotalPressure
      public let units: PsychrometricUnits?

      public init(
        dryBulb: DryBulb,
        totalPressure: TotalPressure,
        units: PsychrometricUnits? = nil
      ) {
        self.dryBulb = dryBulb
        self.totalPressure = totalPressure
        self.units = units
      }
    }

    public struct MoistAirRequest: Equatable, Sendable {
      public let humidityRatio: HumidityRatio
      public let specificVolume: SpecificVolumeOf<MoistAir>
      public let units: PsychrometricUnits?

      public init(
        humidityRatio: HumidityRatio,
        specificVolume: SpecificVolumeOf<MoistAir>,
        units: PsychrometricUnits? = nil
      ) {
        self.humidityRatio = humidityRatio
        self.specificVolume = specificVolume
        self.units = units
      }

    }

  }

  public struct DewPointRequest: Equatable, Sendable {
    public let temperature: DryBulb
    public let vaporPressure: VaporPressure
    public let units: PsychrometricUnits?

    public init(
      temperature: DryBulb,
      vaporPressure: VaporPressure,
      units: PsychrometricUnits? = nil
    ) {
      self.temperature = temperature
      self.vaporPressure = vaporPressure
      self.units = units
    }
  }

  public struct EnthalpyClient {
    public var dryAir: (DryAirRequest) async throws -> EnthalpyOf<DryAir>
    public var moistAir: (MoistAirRequest) async throws -> EnthalpyOf<MoistAir>

    public init(
      dryAir: @escaping (DryAirRequest) async throws -> EnthalpyOf<DryAir>,
      moistAir: @escaping (MoistAirRequest) async throws -> EnthalpyOf<MoistAir>
    ) {
      self.dryAir = dryAir
      self.moistAir = moistAir
    }

    public struct DryAirRequest: Equatable, Sendable {
      public let temperature: DryBulb
      public let units: PsychrometricUnits?

      public static func dryBulb(
        _ dryBulb: DryBulb,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(temperature: dryBulb, units: units)
      }
    }

    public struct MoistAirRequest: Equatable, Sendable {
      public let temperature: DryBulb
      public let humidityRatio: HumidityRatio
      public let units: PsychrometricUnits?

      public static func dryBulb(
        _ dryBulb: DryBulb,
        humidityRatio: HumidityRatio,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(temperature: dryBulb, humidityRatio: humidityRatio, units: units)
      }
    }
  }

  public struct GrainsOfMoistureRequest: Equatable, Sendable {
    public let temperature: DryBulb
    public let humidity: RelativeHumidity
    public let totalPressure: TotalPressure

    public static func dryBulb(
      _ dryBulb: DryBulb,
      relativeHumidity: RelativeHumidity,
      totalPressure: TotalPressure
    ) -> Self {
      .init(temperature: dryBulb, humidity: relativeHumidity, totalPressure: totalPressure)
    }
  }

  public enum HumidityRatioRequest: Equatable, Sendable {
    case enthalpy(
      EnthalpyOf<MoistAir>,
      dryBulb: DryBulb,
      units: PsychrometricUnits? = nil
    )

    case totalPressure(
      TotalPressure,
      partialPressure: VaporPressure,
      units: PsychrometricUnits? = nil
    )

    case specificHumidity(SpecificHumidity)

    case waterMass(Double, dryAirMass: Double)

    case wetBulb(
      WetBulb,
      dryBulb: DryBulb,
      saturatedHumidityRatio: HumidityRatio,
      units: PsychrometricUnits? = nil
    )
  }

  public struct PsychrometricPropertiesRequest: Equatable, Sendable {
    public let dryBulb: DryBulb
    public let totalPressure: TotalPressure
    public let wetBulb: WetBulb
    public let units: PsychrometricUnits?

    public static func wetBulb(
      _ wetBulb: WetBulb,
      dryBulb: DryBulb,
      totalPressure: TotalPressure,
      units: PsychrometricUnits? = nil
    ) -> Self {
      .init(
        dryBulb: dryBulb,
        totalPressure: totalPressure,
        wetBulb: wetBulb,
        units: units
      )
    }
  }

  public enum RelativeHumidityRequest: Equatable, Sendable {
    case dewPoint(DewPoint, dryBulb: DryBulb)
    case vaporPressure(VaporPressure, dryBulb: DryBulb, units: PsychrometricUnits? = nil)
  }

  public struct SaturationPressureRequest: Equatable, Sendable {
    public let temperature: DryBulb
    public let units: PsychrometricUnits?

    public init(
      temperature: DryBulb,
      units: PsychrometricUnits? = nil
    ) {
      self.temperature = temperature
      self.units = units
    }
  }

  public struct SpecificHeatClient {
    public var water: @Sendable (DryBulb) async throws -> SpecificHeat

    public init(
      water: @escaping @Sendable (DryBulb) async throws -> SpecificHeat
    ) {
      self.water = water
    }
  }

  public enum SpecificHumidityRequest {
    case humidityRatio(HumidityRatio, units: PsychrometricUnits? = nil)
    case waterMass(Double, dryAirMass: Double, units: PsychrometricUnits? = nil)
  }

  public struct SpecificVolumeClient {
    public var dryAir: @Sendable (DryAirRequest) async throws -> SpecificVolumeOf<DryAir>
    public var moistAir: @Sendable (MoistAirRequest) async throws -> SpecificVolumeOf<MoistAir>

    public init(
      dryAir: @escaping @Sendable (DryAirRequest) async throws -> SpecificVolumeOf<DryAir>,
      moistAir: @escaping @Sendable (MoistAirRequest) async throws -> SpecificVolumeOf<MoistAir>
    ) {
      self.dryAir = dryAir
      self.moistAir = moistAir
    }

    public struct DryAirRequest: Equatable, Sendable {
      public let dryBulb: DryBulb
      public let totalPressure: TotalPressure
      public let units: PsychrometricUnits?

      public static func dryBulb(
        _ dryBulb: DryBulb,
        totalPressure: TotalPressure,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(dryBulb: dryBulb, totalPressure: totalPressure, units: units)
      }

      public static func dryBulb(
        _ dryBulb: DryBulb,
        altitude: Length,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(
          dryBulb: dryBulb,
          totalPressure: .init(altitude: altitude, units: units),
          units: units
        )
      }
    }

    public struct MoistAirRequest: Equatable, Sendable {
      public let dryBulb: DryBulb
      public let humidityRatio: HumidityRatio
      public let totalPressure: TotalPressure
      public let units: PsychrometricUnits?

      public static func dryBulb(
        _ dryBulb: DryBulb,
        humidityRatio: HumidityRatio,
        totalPressure: TotalPressure,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(
          dryBulb: dryBulb,
          humidityRatio: humidityRatio,
          totalPressure: totalPressure,
          units: units
        )
      }
    }
  }

  public enum VaporPressureRequest: Equatable, Sendable {

    case humidityRatio(
      HumidityRatio,
      totalPressure: TotalPressure,
      units: PsychrometricUnits? = nil
    )

    case relativeHumidity(
      RelativeHumidity,
      dryBulb: DryBulb,
      units: PsychrometricUnits? = nil
    )
  }

  public struct WetBulbRequest: Equatable, Sendable {
    public let dryBulb: DryBulb
    public let humidityRatio: HumidityRatio
    public let totalPressure: TotalPressure
    public let units: PsychrometricUnits?

    public static func dryBulb(
      _ dryBulb: DryBulb,
      humidityRatio: HumidityRatio,
      totalPressure: TotalPressure,
      units: PsychrometricUnits? = nil
    ) -> Self {
      .init(
        dryBulb: dryBulb,
        humidityRatio: humidityRatio,
        totalPressure: totalPressure,
        units: units
      )
    }
  }
}

// MARK: - Extensions
extension PsychrometricClient.DensityClient.DryAirRequest {

  public init(
    dryBulb: DryBulb,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      dryBulb: dryBulb,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}

extension PsychrometricClient.DensityClient.MoistAirRequest {
  /// Create a new ``Density<MoistAir>`` for the given dry bulb temperature, relative humidity, and total pressure.
  ///
  /// **Reference**:
  ///   ASHRAE - Fundamentals (2017) ch. 1 eq. 11
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature to calculate the density for.
  ///   - humidityRatio: The humidity ratio to calculate the density for.
  ///   - pressure: The total atmospheric pressure to calculate the density for.
  ///   - units: The unit of measure to solve for, will default the the ``Core.environment`` setting if not supplied.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    humidityRatio: HumidityRatio,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let specificVolume = try await client.specificVolume.moistAir(
      .dryBulb(
        dryBulb,
        humidityRatio: humidityRatio,
        totalPressure: totalPressure,
        units: units
      )
    )

    return .init(
      humidityRatio: humidityRatio,
      specificVolume: specificVolume,
      units: units
    )
  }

  /// Create a new ``PsychrometricClient/DensityClient/MoistAirRequest`` for the given dry bulb temperature, relative humidity, and total pressure.
  ///
  /// **Reference**:
  ///   ASHRAE - Fundamentals (2017) ch. 1 eq. 11
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature to calculate the density for.
  ///   - humidity: The relative humidity to calculate the density for.
  ///   - pressure: The total pressure to calculate the density for.
  ///   - units: The unit of measure to solve for, will default the the ``Core.environment`` setting if not supplied.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {

    @Dependency(\.psychrometricClient) var client

    let humidityRatio = try await client.humidityRatio(
      .dryBulb(
        dryBulb,
        relativeHumidity: relativeHumidity,
        totalPressure: totalPressure,
        units: units
      ))

    return try await .dryBulb(
      dryBulb,
      humidityRatio: humidityRatio,
      totalPressure: totalPressure,
      units: units
    )
  }

}

// MARK: - Dew Point
extension PsychrometricClient.DewPointRequest {
  /// Creates a new ``DewPointRequest`` for the given dry bulb temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - relativeHumidity: The relative humidity.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client
    let vaporPressure = try await client.vaporPressure(
      .relativeHumidity(
        relativeHumidity,
        dryBulb: dryBulb,
        units: units
      )
    )
    return .init(
      temperature: dryBulb,
      vaporPressure: vaporPressure,
      units: units
    )
  }
  /// Create a new ``DewPoint`` for the given dry bulb temperature, humidity ratio, and atmospheric pressure.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - humidityRatio: The humidity ratio.
  ///   - totalPressure: The atmospheric pressure.
  ///   - units: The units to solve for, if not supplied then ``Core.environment`` units will be used.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    humidityRatio: HumidityRatio,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    guard humidityRatio > 0 else {
      throw ValidationError(summary: "Humidity ratio should be greater than 0.")
    }

    let vaporPressure = try await client.vaporPressure(
      .humidityRatio(
        humidityRatio,
        totalPressure: totalPressure,
        units: units
      ))

    return .init(
      temperature: dryBulb,
      vaporPressure: vaporPressure,
      units: units
    )
  }

  public static func wetBulb(
    _ wetBulb: WetBulb,
    dryBulb: DryBulb,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    guard dryBulb.value > wetBulb.value else {
      throw ValidationError(
        summary: "Wet bulb temperature should be less than dry bulb temperature."
      )
    }

    let humidityRatio = try await client.humidityRatio(
      .wetBulb(
        wetBulb,
        dryBulb: dryBulb,
        totalPressure: totalPressure,
        units: units
      ))

    return try await .dryBulb(
      dryBulb,
      humidityRatio: humidityRatio,
      totalPressure: totalPressure,
      units: units
    )

  }
}

// MARK: - Enthalpy
extension PsychrometricClient.EnthalpyClient.MoistAirRequest {
  /// Create a new ``Enthalpy`` for the given temperature and pressure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature to calculate the enthalpy for.
  ///   - totalPressure: The total atmospheric pressure to calculate the enthalpy for.
  ///   - units: The units to solve for, if not supplied then the ``Core.environment`` will be used.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let humidityRatio = try await client.humidityRatio(
      .dryBulb(
        dryBulb,
        totalPressure: totalPressure,
        units: units
      ))

    return .init(
      temperature: dryBulb,
      humidityRatio: humidityRatio,
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
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let humidityRatio = try await client.humidityRatio(
      .dryBulb(
        dryBulb,
        relativeHumidity: relativeHumidity,
        totalPressure: totalPressure,
        units: units
      ))

    return .init(
      temperature: dryBulb,
      humidityRatio: humidityRatio,
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
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .dryBulb(
      dryBulb,
      relativeHumidity: relativeHumidity,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}

// MARK: - Grains of Moisture
extension PsychrometricClient.GrainsOfMoistureRequest {
  /// Create a new ``GrainsOfMoisture`` with the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The relative humidity of the air.
  ///   - altitude: The altitude of the air.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) -> Self {
    .dryBulb(
      dryBulb,
      relativeHumidity: relativeHumidity,
      totalPressure: .init(altitude: altitude)
    )
  }
}

// MARK: - Humidity Ratio
extension PsychrometricClient.HumidityRatioRequest {

  /// Create a new ``HumidityRatio`` for the given dew point temperature and atmospheric pressure.
  ///
  ///  - Parameters:
  ///   - dewPoint: The dew point temperature.
  ///   - totalPressure: The total atmospheric pressure
  ///   - units: The units to solve for, if not supplied then ``Core.environment`` units will be used.
  public static func dewPoint(
    _ dewPoint: DewPoint,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let saturationPressure = try await client.saturationPressure(
      .init(temperature: .init(.init(dewPoint.value, units: dewPoint.units)), units: units)
    )

    return .totalPressure(
      totalPressure,
      saturationPressure: saturationPressure,
      units: units
    )
  }

  /// Create a new ``HumidityRatio`` for the given dew point temperature and atmospheric pressure.
  ///
  ///  - Parameters:
  ///   - dewPoint: The dew point temperature.
  ///   - altitude: The altitude.
  ///   - units: The units to solve for.
  public static func dewPoint(
    _ dewPoint: DewPoint,
    altitude: Length,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    return try await .dewPoint(
      dewPoint,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }

  /// Request to calculate the humidity ratio of the air for the given
  /// dry bulb temperature and total pressure.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature of the air.
  ///   - totalPressure: The total pressure of the air.
  ///   - units: The units for the calculation.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client
    @Dependency(\.psychrometricEnvironment) var environment

    let saturationPressure = try await client.saturationPressure(
      .init(temperature: dryBulb, units: units)
    )

    return .totalPressure(
      totalPressure,
      partialPressure: .init(.init(saturationPressure.value, units: saturationPressure.units)),
      units: units
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  ///   - units: The units for the calculation.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client
    @Dependency(\.psychrometricEnvironment) var environment

    let vaporPressure = try await client.vaporPressure(
      .relativeHumidity(relativeHumidity, dryBulb: dryBulb, units: units)
    )

    return .totalPressure(
      totalPressure,
      partialPressure: vaporPressure,
      units: units
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - altitude: The pressure of the air.
  ///   - units: The units for the calculation.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .dryBulb(
      dryBulb,
      relativeHumidity: relativeHumidity,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }

  /// Request that will calculate the humidity ratio of the air for the given total pressure and
  /// the vapor pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - vaporPressure: The partial pressure of the air.
  public static func totalPressure(
    _ totalPressure: TotalPressure,
    vaporPressure: VaporPressure,
    units: PsychrometricUnits? = nil
  ) -> Self {
    .totalPressure(
      totalPressure,
      partialPressure: vaporPressure,
      units: units
    )
  }

  /// The  humidity ratio of the air for the given total pressure and saturation pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - saturationPressure: The saturation of the air.
  public static func totalPressure(
    _ totalPressure: TotalPressure,
    saturationPressure: SaturationPressure,
    units: PsychrometricUnits? = nil
  ) -> Self {
    .totalPressure(
      totalPressure,
      partialPressure: .init(.init(saturationPressure.value, units: saturationPressure.units)),
      units: units
    )
  }

  public static func wetBulb(
    _ wetBulb: WetBulb,
    dryBulb: DryBulb,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    guard dryBulb.value > wetBulb.value else {
      throw ValidationError(
        label: "Humidity Ratio",
        summary: "Wet bulb temperature should be less than dry bulb temperature."
      )
    }

    @Dependency(\.psychrometricClient) var client

    let saturatedHumidityRatio = try await client.humidityRatio(
      .dryBulb(
        .init(.init(wetBulb.value, units: wetBulb.units)),
        totalPressure: totalPressure,
        units: units
      )
    )

    return .wetBulb(
      wetBulb,
      dryBulb: dryBulb,
      saturatedHumidityRatio: saturatedHumidityRatio,
      units: units
    )
  }
}

// MARK: - Psychrometric Properties
extension PsychrometricClient.PsychrometricPropertiesRequest {

  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let wetBulb = try await client.wetBulb(
      .dryBulb(
        dryBulb,
        relativeHumidity: relativeHumidity,
        totalPressure: totalPressure,
        units: units
      ))

    return .init(
      dryBulb: dryBulb,
      totalPressure: totalPressure,
      wetBulb: wetBulb,
      units: units
    )
  }

  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .dryBulb(
      dryBulb,
      relativeHumidity: relativeHumidity,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }

  public static func dewPoint(
    _ dewPoint: DewPoint,
    dryBulb: DryBulb,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let humidityRatio = try await client.humidityRatio(
      .dewPoint(
        dewPoint,
        totalPressure: totalPressure,
        units: units
      ))

    let wetBulb = try await client.wetBulb(
      .dryBulb(
        dryBulb,
        humidityRatio: humidityRatio,
        totalPressure: totalPressure,
        units: units
      ))

    return .init(
      dryBulb: dryBulb,
      totalPressure: totalPressure,
      wetBulb: wetBulb,
      units: units
    )
  }

  public static func dewPoint(
    _ dewPoint: DewPoint,
    dryBulb: DryBulb,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .dewPoint(
      dewPoint,
      dryBulb: dryBulb,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }

  public static func wetBulb(
    _ wetBulb: WetBulb,
    dryBulb: DryBulb,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) -> Self {
    .init(
      dryBulb: dryBulb,
      totalPressure: .init(altitude: altitude, units: units),
      wetBulb: wetBulb,
      units: units
    )
  }

}

// MARK: - Relative Humidity
extension PsychrometricClient.RelativeHumidityRequest {

  public static func dryBulb(
    _ dryBulb: DryBulb,
    humidityRatio: HumidityRatio,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .totalPressure(
      totalPressure,
      dryBulb: dryBulb,
      humidityRatio: humidityRatio,
      units: units
    )
  }

  public static func totalPressure(
    _ totalPressure: TotalPressure,
    dryBulb: DryBulb,
    humidityRatio: HumidityRatio,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client
    let vaporPressure = try await client.vaporPressure(
      .humidityRatio(
        humidityRatio,
        totalPressure: totalPressure,
        units: units
      ))
    return .vaporPressure(vaporPressure, dryBulb: dryBulb, units: units)
  }
}

// MARK: - Specific Humidity

extension PsychrometricClient.SpecificHumidityRequest {

  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let humidityRatio = try await client.humidityRatio(
      .dryBulb(
        dryBulb,
        relativeHumidity: relativeHumidity,
        totalPressure: totalPressure,
        units: units
      ))

    return .humidityRatio(humidityRatio, units: units)
  }

  public static func dryBulb(
    _ dryBulb: DryBulb,
    altitude: Length = .seaLevel,
    relativeHumidity: RelativeHumidity,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .dryBulb(
      dryBulb,
      relativeHumidity: relativeHumidity,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}

// MARK: - Specific Volume
extension PsychrometricClient.SpecificVolumeClient.MoistAirRequest {

  /// Calculate the ``SpecificVolume`` for  the given temperature, humidity, and total pressure.
  ///
  /// **References**: ASHRAE - Fundamentals (2017) ch. 1 eq. 26
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidity: The relative humidity to calculate the specific volume for.
  ///   - totalPressure: The altitude to calculate the specific volume for.
  ///   - units: The unit of measure to solve for, if not supplied then ``Core.environment`` value will be used.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let humidityRatio = try await client.humidityRatio(
      .dryBulb(
        dryBulb, relativeHumidity: relativeHumidity, totalPressure: totalPressure, units: units)
    )

    return .dryBulb(
      dryBulb,
      humidityRatio: humidityRatio,
      totalPressure: totalPressure,
      units: units
    )
  }

  /// Calculate the ``SpecificVolume`` for  the given temperature, humidity, and total pressure.
  ///
  /// **References**: ASHRAE - Fundamentals (2017) ch. 1 eq. 26
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the specific volume for.
  ///   - humidity: The relative humidity to calculate the specific volume for.
  ///   - totalPressure: The altitude to calculate the specific volume for.
  ///   - units: The unit of measure to solve for, if not supplied then ``Core.environment`` value will be used.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .dryBulb(
      dryBulb,
      relativeHumidity: relativeHumidity,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}

// MARK: - Wet Bulb

extension PsychrometricClient.WetBulbRequest {

  public static func dryBulb(
    _ dryBulb: DryBulb,
    relativeHumidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let humidityRatio = try await client.humidityRatio(
      .dryBulb(
        dryBulb,
        relativeHumidity: relativeHumidity,
        totalPressure: totalPressure,
        units: units
      ))

    return .dryBulb(
      dryBulb,
      humidityRatio: humidityRatio,
      totalPressure: totalPressure,
      units: units
    )
  }
}
