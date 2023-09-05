import Foundation
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
      public let temperature: Temperature
      public let totalPressure: TotalPressure
      public let units: PsychrometricUnits?

      public init(
        temperature: Temperature,
        totalPressure: TotalPressure,
        units: PsychrometricUnits? = nil
      ) {
        self.temperature = temperature
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
    case enthalpy(MoistAirEnthalpy, dryBulb: DryBulb)
    case totalPressure(TotalPressure, vaporPressure: VaporPressure, units: PsychrometricUnits? = nil)
    case waterMass(Double, dryAirMass: Double)
    case wetBulb(WetBulb, dryBulb: DryBulb, saturatedHumidityRatio: HumidityRatio)
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
    }
  }

  public enum VaporPressureRequest: Equatable, Sendable {
    case humidityRatio(HumidityRatio, totalPressure: TotalPressure, units: PsychrometricUnits? = nil)
    case relativeHumidity(RelativeHumidity, dryBulb: DryBulb, units: PsychrometricUnits? = nil)
  }
}
