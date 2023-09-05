import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

/// Performs calculations for different psychrometric properties.
public struct PsychrometricClient {

  /// Perform density calculations / conversions.
  public var density: DensityClient

  /// Perform dew-point temperature calculations / conversions.
  public var dewPoint: @Sendable (DewPointRequest) async -> DewPoint

  /// Perform enthalpy calculations / conversions.
  public var enthalpy: Enthalpy

  /// Perform grains of moisture calculations / conversions.
  public var grainsOfMoisture: @Sendable (GrainsOfMoistureRequest) async throws -> GrainsOfMoisture

  /// Perform humidity ratio calculations / conversions.
  public var humidityRatio: @Sendable (HumidityRatioRequest) async throws -> HumidityRatio

  /// Perform relative humidity calculations / conversions.
  public var relativeHumidity: @Sendable (RelativeHumidityRequest) async throws -> RelativeHumidity

  /// Perform saturation pressure calculations / conversions.
  public var saturationPressure: @Sendable (SaturationPressureRequest) async throws -> SaturationPressure

  /// Perform specific heat calculations / conversions.
  public var specificHeat: SpecificHeatClient

  /// Perform specific humidity calculations / conversions.
  public var specificHumidity: @Sendable (SpecificHumidityRequest) async -> SpecificHumidity

  /// Perform specific volume calculations / conversions.
  public var specificVolume: SpecificVolumeClient

  /// Perform vapor pressure calculations / conversions.
  public var vaporPressure: (VaporPressureRequest) async throws -> VaporPressure

  public init(
    density: DensityClient, 
    dewPoint: @escaping @Sendable (DewPointRequest) -> DewPoint,
    enthalpy: Enthalpy,
    grainsOfMoisture: @escaping @Sendable (GrainsOfMoistureRequest) async throws -> GrainsOfMoisture,
    humidityRatio: @escaping @Sendable (HumidityRatioRequest) async throws -> HumidityRatio,
    relativeHumidity: @escaping @Sendable (RelativeHumidityRequest) async throws -> RelativeHumidity,
    saturationPressure: @escaping @Sendable (SaturationPressureRequest) async throws -> SaturationPressure,
    specificHeat: SpecificHeatClient,
    specificHumidity: @escaping @Sendable (SpecificHumidityRequest) async -> SpecificHumidity,
    specificVolume: SpecificVolumeClient,
    vaporPressure: @escaping @Sendable (VaporPressureRequest) async throws -> VaporPressure
  ) {
    self.density = density
    self.dewPoint = dewPoint
    self.enthalpy = enthalpy
    self.grainsOfMoisture = grainsOfMoisture
    self.humidityRatio = humidityRatio
    self.relativeHumidity = relativeHumidity
    self.saturationPressure = saturationPressure
    self.specificHeat = specificHeat
    self.specificHumidity = specificHumidity
    self.specificVolume = specificVolume
    self.vaporPressure = vaporPressure
  }

  /// Perform density calculations.
  public struct DensityClient {

    /// Calculate the density of dry air for the given request.
    public var dryAir: @Sendable (DryAirRequest) async -> Density<DryAir>

    /// Calculate the density of moist air for the given request.
    public var moistAir: @Sendable (MoistAirRequest) async throws -> Density<MoistAir>

    /// Calculate the density of water for the given temperature.
    public var water: @Sendable (Temperature) async -> Density<Water>

    public init(
      dryAir: @escaping @Sendable (DryAirRequest) async -> Density<DryAir>,
      moistAir: @escaping @Sendable (MoistAirRequest) async throws -> Density<MoistAir>,
      water: @escaping @Sendable (Temperature) async -> Density<Water>
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

  public struct Enthalpy {
    public var dryAir: (DryAirRequest) async -> DryAirEnthalpy
    public var moistAir: (MoistAirRequest) async throws -> MoistAirEnthalpy

    public struct DryAirRequest: Equatable, Sendable {
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

    public struct MoistAirRequest: Equatable, Sendable {
      public let temperature: DryBulb
      public let humidityRatio: HumidityRatio
      public let units: PsychrometricUnits?

      public init(
        temperature: DryBulb,
        humidityRatio: HumidityRatio,
        units: PsychrometricUnits? = nil
      ) {
        self.temperature = temperature
        self.humidityRatio = humidityRatio
        self.units = units
      }
    }
  }

  public struct GrainsOfMoistureRequest: Equatable, Sendable {
    public let temperature: DryBulb
    public let humidity: RelativeHumidity
    public let totalPressure: TotalPressure

    public init(
      temperature: DryBulb,
      humidity: RelativeHumidity,
      totalPressure: TotalPressure
    ) {
      self.temperature = temperature
      self.humidity = humidity
      self.totalPressure = totalPressure
    }
  }

  public enum HumidityRatioRequest: Equatable, Sendable {
    case enthalpy(
      MoistAirEnthalpy,
      dryBulb: DryBulb,
      units: PsychrometricUnits? = nil
    )

    case totalPressure(
      TotalPressure,
      partialPressure: Pressure,
      units: PsychrometricUnits? = nil
    )

    case specificHumidity(SpecificHumidity)

    case waterMass(Double, dryAirMass: Double)

    case wetBulb(
      WetBulb,
      dryBulb: DryBulb,
      saturatedHumidityRatio: HumidityRatio
    )
  }

  public enum RelativeHumidityRequest: Equatable, Sendable {
    case totalPressure(TotalPressure, dryBulb: DryBulb, humidityRatio: HumidityRatio, units: PsychrometricUnits? = nil)
    case vaporPressure(VaporPressure, dryBulb: DryBulb, units: PsychrometricUnits? = nil)
  }

  public struct SaturationPressureRequest: Equatable, Sendable {
    public let temperature: Temperature
    public let units: PsychrometricUnits?

    public init(
      temperature: Temperature,
      units: PsychrometricUnits? = nil
    ) {
      self.temperature = temperature
      self.units = units
    }
  }

  public struct SpecificHeatClient {
    public var water: @Sendable (Temperature) async -> SpecificHeat

    public init(
      water: @escaping @Sendable (Temperature) async -> SpecificHeat
    ) {
      self.water = water
    }
  }

  public enum SpecificHumidityRequest {
    case humidityRatio(HumidityRatio, units: PsychrometricUnits? = nil)
    case waterMass(Double, dryAirMass: Double, units: PsychrometricUnits? = nil)
  }

  public struct SpecificVolumeClient {
    public var dryAir: @Sendable (DryAirRequest) async -> SpecificVolumeOf<DryAir>
    public var moistAir: @Sendable (MoistAirRequest) async throws -> SpecificVolumeOf<MoistAir>

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

      public init(
        dryBulb: DryBulb,
        humidityRatio: HumidityRatio,
        totalPressure: TotalPressure,
        units: PsychrometricUnits? = nil
      ) {
        self.dryBulb = dryBulb
        self.humidityRatio = humidityRatio
        self.totalPressure = totalPressure
        self.units = units
      }

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

//extension PsychrometricClient.DensityClient.MoistAirRequest {
//
//  public static func dryBulb(
//    _ dryBulb: DryBulb,
//    humidity: RelativeHumidity,
//    totalPressure: TotalPressure,
//    units: PsychrometricUnits? = nil
//  ) async throws -> Self {
//
//    @Dependency(\.psychrometricClient) var client
//
//    let specificVolume = try await client.specificVolume(
//      .moistAir(
//    )
//  }
//}

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
      .init(temperature: dewPoint.rawValue, units: units)
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

    let vaporPressure = try await client.saturationPressure(
      .init(temperature: dryBulb.rawValue, units: units)
    )

    return .totalPressure(
      totalPressure,
      partialPressure: vaporPressure.rawValue,
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
    humidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client
    @Dependency(\.psychrometricEnvironment) var environment

    let vaporPressure = try await client.vaporPressure(
      .relativeHumidity(humidity, dryBulb: dryBulb, units: units)
    )

    return .totalPressure(
      totalPressure,
      partialPressure: vaporPressure.rawValue,
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
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .dryBulb(
      dryBulb,
      humidity: humidity,
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
      partialPressure: vaporPressure.rawValue,
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
      partialPressure: saturationPressure.rawValue,
      units: units
    )
  }

  public static func wetBulb(
    _ wetBulb: WetBulb,
    dryBulb: DryBulb,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    guard dryBulb.rawValue > wetBulb.rawValue else {
      throw ValidationError(
        label: "Humidity Ratio",
        summary: "Wet bulb temperature should be less than dry bulb temperature."
      )
    }

    @Dependency(\.psychrometricClient) var client;

    let saturatedHumidityRatio = try await client.humidityRatio(
      .dryBulb(.init(wetBulb.rawValue), totalPressure: totalPressure, units: units)
    )

    return .wetBulb(
      wetBulb,
      dryBulb: dryBulb,
      saturatedHumidityRatio: saturatedHumidityRatio
    )
  }
}

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
    humidity: RelativeHumidity,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let humidityRatio = try await client.humidityRatio(
      .dryBulb(dryBulb, humidity: humidity, totalPressure: totalPressure, units: units)
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
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    try await .dryBulb(
      dryBulb,
      humidity: humidity,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}
