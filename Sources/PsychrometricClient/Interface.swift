import Foundation
import SharedModels

/// Performs calculations for different psychrometric properties.
public struct PsychrometricClient {

  public var density: DensityClient
  public var dewPoint: @Sendable (DewPointRequest) async -> DewPoint
  public var enthalpy: Enthalpy
  public var grainsOfMoisture: @Sendable (GrainsOfMoistureRequest) async throws -> GrainsOfMoisture
  public var humidityRatio: @Sendable (HumidityRatioRequest) async throws -> HumidityRatio
  public var relativeHumidity: @Sendable (RelativeHumidityRequest) async throws -> RelativeHumidity
  public var saturationPressure: @Sendable (SaturationPressureRequest) async throws -> SaturationPressure
  public var specificHeat: SpecificHeatClient
  public var specificHumidity: @Sendable (SpecificHumidityRequest) async -> SpecificHumidity

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
      water: @escaping @Sendable (Temperature) -> SpecificHeat
    ) {
      self.water = water
    }
  }

  public enum SpecificHumidityRequest {
    case humidityRatio(HumidityRatio, units: PsychrometricUnits? = nil)
    case waterMass(Double, dryAirMass: Double, units: PsychrometricUnits? = nil)
  }

  public struct SpecificVolumeClient {
    public var dryAir: @Sendable () async -> SpecificVolumeOf<DryAir>
    public var moistAir: @Sendable () async -> SpecificVolumeOf<MoistAir>
  }
}
