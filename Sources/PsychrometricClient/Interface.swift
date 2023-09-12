import Dependencies
import Foundation
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

  /// Calculate the degree of saturation for an air stream / sample
  ///
  ///
  public struct DegreeOfSaturationRequest: Equatable, Sendable {

    /// The dry bulb temperature.
    public let dryBulb: DryBulb

    /// The humidity ratio.
    public let humidityRatio: HumidityRatio

    /// The total pressure, generally based on the altitude.
    public let totalPressure: TotalPressure

    /// The unit of measure for the calculation.
    public let units: PsychrometricUnits?

    /// Create a new request.
    ///
    /// - Parameters:
    ///   - dryBulb: The dry bulb temperature.
    ///   - humidityRatio: The humidity ratio.
    ///   - totalPressure: The total pressure.
    ///   - units: The unit of measure.
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

  /// Requests used to perform density calculation.
  ///
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

    /// Perform density calculations for dry-air samples.
    ///
    public struct DryAirRequest: Equatable, Sendable {

      /// The dry bulb temperature.
      public let dryBulb: DryBulb

      /// The total pressure, generally based on altitude.
      public let totalPressure: TotalPressure

      /// The unit of measure.
      public let units: PsychrometricUnits?

      /// Create a new ``DryAirRequest`` with the given parameters.
      ///
      /// - Parameters:
      ///   - dryBulb: The dry bulb temperature.
      ///   - totalPressure: The total pressure.
      ///   - units: The unit of measure.
      public static func dryBulb(
        _ dryBulb: DryBulb,
        totalPressure: TotalPressure,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(dryBulb: dryBulb, totalPressure: totalPressure, units: units)
      }
    }

    /// Perform density calculation on a moist-air sample.
    ///
    public struct MoistAirRequest: Equatable, Sendable {

      /// The humidity ratio.
      public let humidityRatio: HumidityRatio

      /// The specific volume.
      public let specificVolume: SpecificVolumeOf<MoistAir>

      /// The unit of measure.
      public let units: PsychrometricUnits?

      /// Create a new density request for a moist air sample.
      ///
      /// - Parameters:
      ///   - humidityRatio: The humidity ratio.
      ///   - specificVolume: The specific volume.
      ///   - units: The unit of measure.
      public static func humidityRatio(
        _ humidityRatio: HumidityRatio,
        specificVolume: SpecificVolumeOf<MoistAir>,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(
          humidityRatio: humidityRatio,
          specificVolume: specificVolume,
          units: units
        )
      }
    }

  }

  /// Represents a request to perform a dew point calculation for the given air sample.
  ///
  public struct DewPointRequest: Equatable, Sendable {

    /// The dry bulb temperature.
    public let dryBulb: DryBulb

    /// The vapor pressure.
    public let vaporPressure: VaporPressure

    /// The units of measure.
    public let units: PsychrometricUnits?

    /// Create a new dew point request with the given parameters.
    ///
    /// - Parameters:
    ///   - dryBulb: The dry bulb temperature.
    ///   - vaporPressure: The vapor pressure.
    ///   - units: The units of measure.
    public static func dryBulb(
      _ dryBulb: DryBulb,
      vaporPressure: VaporPressure,
      units: PsychrometricUnits? = nil
    ) -> Self {
      self.init(dryBulb: dryBulb, vaporPressure: vaporPressure, units: units)
    }
  }

  /// Represents the different types of enthalpy requests we can perform.
  ///
  public struct EnthalpyClient {

    /// Perform an enthalpy calculation for a dry air sample.
    public var dryAir: (DryAirRequest) async throws -> EnthalpyOf<DryAir>

    /// Perform an enthalpy calculation for a moist air sample.
    public var moistAir: (MoistAirRequest) async throws -> EnthalpyOf<MoistAir>

    /// Create a new enthalpy client instance.
    ///
    /// - Parameters:
    ///   - dryAir: Performs enthalpy calculations for dry air samples.
    ///   - moistAir: Performs enthalpy calculations for moist air samples.
    public init(
      dryAir: @escaping (DryAirRequest) async throws -> EnthalpyOf<DryAir>,
      moistAir: @escaping (MoistAirRequest) async throws -> EnthalpyOf<MoistAir>
    ) {
      self.dryAir = dryAir
      self.moistAir = moistAir
    }

    /// Represents parameters for an enthalpy calculation on dry air samples.
    ///
    public struct DryAirRequest: Equatable, Sendable {

      /// The dry bulb temperature
      public let dryBulb: DryBulb

      /// The units of measure.
      public let units: PsychrometricUnits?

      /// Create a new enthalpy request for a dry air sample.
      ///
      /// - Parameters:
      ///   - dryBulb: The dry bulb temperature.
      ///   - units: The units of measure.
      public static func dryBulb(
        _ dryBulb: DryBulb,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(dryBulb: dryBulb, units: units)
      }
    }

    /// Represents the parameters for an enthalpy calculation on a moist air sample.
    ///
    public struct MoistAirRequest: Equatable, Sendable {

      /// The dry bulb temperature.
      public let dryBulb: DryBulb
      /// The humidity ratio.
      public let humidityRatio: HumidityRatio
      /// The units of measure.
      public let units: PsychrometricUnits?

      /// Create a new enthalpy request for the given parameters.
      ///
      /// - Parameters:
      ///   - dryBulb: The dry bulb temperature.
      ///   - humidityRatio: The humidity ratio.
      ///   - units: The units of measure.
      public static func dryBulb(
        _ dryBulb: DryBulb,
        humidityRatio: HumidityRatio,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(dryBulb: dryBulb, humidityRatio: humidityRatio, units: units)
      }
    }
  }

  /// Represents the parameters to calculate the grains of moisture for an air sample.
  ///
  public struct GrainsOfMoistureRequest: Equatable, Sendable {
    /// The dry bulb temperature.
    public let dryBulb: DryBulb
    /// The relative humidity.
    public let humidity: RelativeHumidity
    /// The total pressure.
    public let totalPressure: TotalPressure

    /// Create a new grains of moisture request with the given parameters.
    ///
    /// - Parameters:
    ///   - dryBulb: The dry bulb temperature.
    ///   - relativeHumidity: The relative humidity.
    ///   - totalPressure: The total pressure.
    public static func dryBulb(
      _ dryBulb: DryBulb,
      relativeHumidity: RelativeHumidity,
      totalPressure: TotalPressure
    ) -> Self {
      .init(dryBulb: dryBulb, humidity: relativeHumidity, totalPressure: totalPressure)
    }
  }

  /// Represents the parameters for a humidity-ratio calculation of a moist air sample.
  ///
  public enum HumidityRatioRequest: Equatable, Sendable {

    /// Create a new humidity ratio request with the given parameters.
    ///
    /// - Parameters:
    ///   - enthalpy: The enthalpy of the air sample.
    ///   - dryBulb: The dry bulb temperature.
    ///   - units: The units of measure.
    case enthalpy(
      EnthalpyOf<MoistAir>,
      dryBulb: DryBulb,
      units: PsychrometricUnits? = nil
    )

    /// Create a new humidity ratio request with the given parameters.
    ///
    /// - Parameters:
    ///   - totalPressure: The total pressure of the air sample.
    ///   - partialPressure: The partial vapor pressure of the air sample.
    ///   - units: The units of measure.
    case totalPressure(
      TotalPressure,
      partialPressure: VaporPressure,
      units: PsychrometricUnits? = nil
    )

    /// Create a new humidity ratio request with the given parameters.
    ///
    /// - Parameters:
    ///   - specificHumidity: The specific humidity of the air sample.
    case specificHumidity(SpecificHumidity)

    /// Create a new humidity ratio request with the given parameters.
    ///
    /// - Parameters:
    ///   - water: The water mass of the air sample.
    ///   - dryAir: The dry air mass of the air sample.
    case mass(water: Double, dryAir: Double)

    /// Create a new humidity ratio request with the given parameters.
    ///
    /// - Parameters:
    ///   - wetBulb: The wet bulb temperature of the air sample.
    ///   - dryBulb: The dry bulb temperature of the air sample.
    ///   - humidityRatio: The humidity ratio of the air sample.
    ///   - units: The units of measure.
    case wetBulb(
      WetBulb,
      dryBulb: DryBulb,
      humidityRatio: HumidityRatio,
      units: PsychrometricUnits? = nil
    )
  }

  /// Represents parameters to calculate the psychrometric properties of an air sample.
  ///
  public struct PsychrometricPropertiesRequest: Equatable, Sendable {

    /// The dry bulb temperature.
    public let dryBulb: DryBulb
    /// The total pressure.
    public let totalPressure: TotalPressure
    /// The wet bulb temperature.
    public let wetBulb: WetBulb
    /// The units of measure.
    public let units: PsychrometricUnits?

    /// Create new psychrometric properties request with the given parameters.
    ///
    /// - Parameters:
    ///   - wetBulb: The wet bulb temperature.
    ///   - dryBulb: the dry bulb temperature.
    ///   - totalPressure: The total pressure.
    ///   - units: The units of measure.
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

  /// Represents parameters to calculate the relative humidity of an air sample.
  ///
  public enum RelativeHumidityRequest: Equatable, Sendable {

    /// Create a new relative humdity request with the given parameters.
    ///
    /// - Parameters:
    ///   - dewPoint: The dew point temperature.
    ///   - dryBulb: The dry bulb temperature.
    case dewPoint(DewPoint, dryBulb: DryBulb)

    /// Create a new relative humdity request with the given parameters.
    ///
    /// - Parameters:
    ///   - vaporPressure: The vapor pressure.
    ///   - dryBulb: The dry bulb temperature.
    ///   - units: The units of measure.
    case vaporPressure(VaporPressure, dryBulb: DryBulb, units: PsychrometricUnits? = nil)
  }

  /// Represents the parameters required to calculate the saturation pressure of an air sample.
  public struct SaturationPressureRequest: Equatable, Sendable {
    /// The dry bulb temperature.
    public let dryBulb: DryBulb
    /// The units of measure.
    public let units: PsychrometricUnits?

    /// Create a new saturation pressure request instance with the given parameters.
    ///
    /// - Parameters:
    ///   - dryBulb: The dry bulb temperature.
    ///   - units: The units of measure.
    public static func dryBulb(
      _ dryBulb: DryBulb,
      units: PsychrometricUnits? = nil
    ) -> Self {
      .init(dryBulb: dryBulb, units: units)
    }
  }

  /// Represents the calculations that can calculate the specific heat of a substance.
  ///
  public struct SpecificHeatClient {

    /// The parameters required to calculate the specific heat of water.
    public var water: @Sendable (DryBulb) async throws -> SpecificHeat

    /// Create a new specific heat client instance.
    ///
    /// - Parameters:
    ///   - water: Calculate the specific heat of water.
    public init(
      water: @escaping @Sendable (DryBulb) async throws -> SpecificHeat
    ) {
      self.water = water
    }
  }

  /// Represents the parameters needed to calculate the specific humidity of an air stream.
  public enum SpecificHumidityRequest {

    /// Parameters to calculate specific humidity with the given parameters.
    ///
    /// - Parameters:
    ///   - humidityRatio: The humidity ratio.
    ///   - units: The units of measure.
    case humidityRatio(HumidityRatio, units: PsychrometricUnits? = nil)

    /// Parameters to calculate the specific humidity with the given parameters.
    ///
    /// - Parameters:
    ///   - waterMass: The mass of the water portion of the air stream.
    ///   - dryAirMass: The mass of the dry air portion of the air stream.
    ///   - units: The units of measure.
    case waterMass(Double, dryAirMass: Double, units: PsychrometricUnits? = nil)
  }

  /// Represents the different calculations that can return the specific volume of the air stream.
  public struct SpecificVolumeClient {

    /// Perform a specific volume calculation for dry air.
    public var dryAir: @Sendable (DryAirRequest) async throws -> SpecificVolumeOf<DryAir>

    /// Perform a specific volume calculation for moist air.
    public var moistAir: @Sendable (MoistAirRequest) async throws -> SpecificVolumeOf<MoistAir>

    /// Create a new specific volume client instance.
    ///
    /// - Parameters:
    ///   - dryAir: Perform a specific volume calculation for dry air.
    ///   - moistAir: Perform a specific volume calculation for moist air.
    public init(
      dryAir: @escaping @Sendable (DryAirRequest) async throws -> SpecificVolumeOf<DryAir>,
      moistAir: @escaping @Sendable (MoistAirRequest) async throws -> SpecificVolumeOf<MoistAir>
    ) {
      self.dryAir = dryAir
      self.moistAir = moistAir
    }

    /// Represents the parameters needed to perform a specific volume calculation on a dry air stream.
    public struct DryAirRequest: Equatable, Sendable {
      /// The dry bulb temperature.
      public let dryBulb: DryBulb
      /// The total pressure.
      public let totalPressure: TotalPressure
      /// The units of measure.
      public let units: PsychrometricUnits?

      /// Create a new specific volume request for dry air with the given parameters.
      ///
      /// - Parameters:
      ///   - dryBulb: The dry bulb temperature.
      ///   - totalPressure: The total pressure.
      ///   - units: The units of measure.
      public static func dryBulb(
        _ dryBulb: DryBulb,
        totalPressure: TotalPressure,
        units: PsychrometricUnits? = nil
      ) -> Self {
        .init(dryBulb: dryBulb, totalPressure: totalPressure, units: units)
      }

      /// Create a new specific volume request for dry air with the given parameters.
      ///
      /// - Parameters:
      ///   - dryBulb: The dry bulb temperature.
      ///   - altitude: The altitude used to calculate the total pressure.
      ///   - units: The units of measure.
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

    /// Represents the parameters needed to perform a specific volume calculation on a moist air stream.
    public struct MoistAirRequest: Equatable, Sendable {
      /// The dry bulb temperature.
      public let dryBulb: DryBulb
      /// The humidity ratio.
      public let humidityRatio: HumidityRatio
      /// The total pressure.
      public let totalPressure: TotalPressure
      /// The  units of measure.
      public let units: PsychrometricUnits?

      /// Create a new specific volume request for moist air with the given parameters.
      ///
      /// - Parameters:
      ///   - dryBulb: The dry bulb temperature.
      ///   - humidityRatio: The humidity ratio.
      ///   - totalPressure: The total pressure.
      ///   - units: The units of measure.
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

  /// Represents parameters required to calculate the vapor pressure of moist air.
  public enum VaporPressureRequest: Equatable, Sendable {

    /// Create a new vapor pressure request with the given parameters.
    ///
    /// - Parameters:
    ///   - humidityRatio: The humidity ratio of the air sample.
    ///   - totalPressure: The total pressure of the air sample.
    ///   - units: The units of measure.
    case humidityRatio(
      HumidityRatio,
      totalPressure: TotalPressure,
      units: PsychrometricUnits? = nil
    )

    /// Create a new vapor pressure request with the given parameters.
    ///
    /// - Parameters:
    ///   - relativeHumidity: The relative humidity of the air sample.
    ///   - dryBulb: The dry bulb temperature of the air sample.
    ///   - units: The units of measure.
    case relativeHumidity(
      RelativeHumidity,
      dryBulb: DryBulb,
      units: PsychrometricUnits? = nil
    )
  }

  /// Represents parameters for calculating wet bulb temperature of an air stream.
  public struct WetBulbRequest: Equatable, Sendable {

    /// The dry bulb temperature.
    public let dryBulb: DryBulb
    /// The humidity ratio.
    public let humidityRatio: HumidityRatio
    /// The total pressure.
    public let totalPressure: TotalPressure
    /// The  units of measure.
    public let units: PsychrometricUnits?

    /// Create a new ``PsychrometricClient/WetBulbRequest`` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - dryBulb: The dry bulb temperature
    ///   - humidityRatio: The humidity ratio.
    ///   - totalPressure: The total pressure.
    ///   - units: The units of measure.
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

  /// Create a new ``DryAirRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - altitude: The altitude of the project.
  ///   - units: The units of measure.
  public static func dryBulb(
    _ dryBulb: DryBulb,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) -> Self {
    .init(
      dryBulb: dryBulb,
      totalPressure: .init(altitude: altitude, units: units),
      units: units
    )
  }
}

extension PsychrometricClient.DensityClient.MoistAirRequest {
  /// Create a new ``PsychrometricClient/DensityClient/MoistAirRequest`` for the given dry bulb temperature,
  /// relative humidity, and total pressure.
  ///
  /// **Reference**:
  ///   ASHRAE - Fundamentals (2017) ch. 1 eq. 11
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature to calculate the density for.
  ///   - humidityRatio: The humidity ratio to calculate the density for.
  ///   - pressure: The total atmospheric pressure to calculate the density for.
  ///   - units: The unit of measure to solve for.
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
  ///   - units: The unit of measure to solve for.
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
    return .dryBulb(
      dryBulb,
      vaporPressure: vaporPressure,
      units: units
    )
  }

  /// Create a new ``DewPointRequest`` for the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - humidityRatio: The humidity ratio.
  ///   - totalPressure: The atmospheric pressure.
  ///   - units: The units to solve for.
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

    return .dryBulb(
      dryBulb,
      vaporPressure: vaporPressure,
      units: units
    )
  }

  /// Create a new ``DewPointRequest`` for the given parameters.
  ///
  /// - Parameters:
  ///   - wetBulb: The wet bulb temperature.
  ///   - dryBulb: The dry bulb temperature.
  ///   - totalPressure: The atmospheric pressure.
  ///   - units: The units to solve for.
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

  /// Create a new ``MoistAirRequest`` for the given parameters.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - totalPressure: The total atmospheric pressure.
  ///   - units: The units to solve for.
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
      dryBulb: dryBulb,
      humidityRatio: humidityRatio,
      units: units
    )
  }

  /// Create a new ``MoistAirRequest`` for the given temperature, relative humidity, and pressure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature to calculate the enthalpy for.
  ///   - relativeHumidity: The relative humidity to calculate the enthalpy for.
  ///   - totalPressure: The total atmospheric pressure to calculate the enthalpy for.
  ///   - units: The units to solve for.
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
      dryBulb: dryBulb,
      humidityRatio: humidityRatio,
      units: units
    )
  }

  /// Create a new ``MoistAirRequest`` for the given temperature, relative humidity, and pressure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature to calculate the enthalpy for.
  ///   - relativeHumidity: The relative humidity to calculate the enthalpy for.
  ///   - altitude: The altitude to calculate the enthalpy for.
  ///   - units: The units to solve for.
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
  /// Create a new ``GrainsOfMoistureRequest`` with the given temperature, humidity, and altitude.
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

  /// Create a new ``HumidityRatioRequest`` for the given parameters.
  ///
  ///  - Parameters:
  ///   - dewPoint: The dew point temperature.
  ///   - totalPressure: The total atmospheric pressure
  ///   - units: The units to solve for.
  public static func dewPoint(
    _ dewPoint: DewPoint,
    totalPressure: TotalPressure,
    units: PsychrometricUnits? = nil
  ) async throws -> Self {
    @Dependency(\.psychrometricClient) var client

    let saturationPressure = try await client.saturationPressure(
      .dryBulb(.init(.init(dewPoint.value, units: dewPoint.units)), units: units)
    )

    return .totalPressure(
      totalPressure,
      saturationPressure: saturationPressure,
      units: units
    )
  }

  /// Create a new ``HumidityRatioRequest`` for the given parameters.
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

  /// Create a new ``HumidityRatioRequest`` for the given parameters.
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
      .dryBulb(dryBulb, units: units)
    )

    return .totalPressure(
      totalPressure,
      partialPressure: .init(.init(saturationPressure.value, units: saturationPressure.units)),
      units: units
    )
  }

  /// Create a new ``HumidityRatioRequest`` for the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature of the air.
  ///   - relativeHumidity: The humidity of the air.
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

  /// Create a new ``HumidityRatioRequest`` for the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature of the air.
  ///   - relativeHumidity: The humidity of the air.
  ///   - altitude: The altitude.
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

  /// Create a new ``HumidityRatioRequest`` for the given parameters.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - vaporPressure: The partial vapor pressure of the air.
  ///   - units: The units for the calculation.
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

  /// Create a new ``HumidityRatioRequest`` for the given parameters.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - saturationPressure: The saturation pressure of the air.
  ///   - units: The units for the calculation.
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

  /// Create a new ``HumidityRatioRequest`` for the given parameters.
  ///
  /// - Parameters:
  ///   - wetBulb: The wet bulb temperature.
  ///   - dryBulb: The dry bulb temperature.
  ///   - totalPressure: The total pressure of the air.
  ///   - units: The units for the calculation.
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
      humidityRatio: saturatedHumidityRatio,
      units: units
    )
  }
}

// MARK: - Psychrometric Properties
extension PsychrometricClient.PsychrometricPropertiesRequest {

  /// Create a new ``PsychrometricPropertiesRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - relativeHumidity: The relative humidity.
  ///   - totalPressure: The total pressure.
  ///   - units: The units of measure.
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
  /// Create a new ``PsychrometricPropertiesRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - relativeHumidity: The relative humidity.
  ///   - altitude: The altitude of the project.
  ///   - units: The units of measure.
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

  /// Create a new ``PsychrometricPropertiesRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - dewPoint: The dew point temperature.
  ///   - dryBulb: The dry bulb temperature.
  ///   - totalPressure: The total pressure.
  ///   - units: The units of measure.
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
  /// Create a new ``PsychrometricPropertiesRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - dewPoint: The dew point temperature.
  ///   - dryBulb: The dry bulb temperature.
  ///   - altitude: The altitude of the project.
  ///   - units: The units of measure.
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

  /// Create a new ``PsychrometricPropertiesRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - wetBulb: The wet bulb temperature.
  ///   - dryBulb: The dry bulb temperature.
  ///   - altitude: The altitude of the project.
  ///   - units: The units of measure.
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
  /// Create a new ``RelativeHumidityRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - humidityRatio: The humidity ratio.
  ///   - totalPressure: The total pressure.
  ///   - units: The units of measure.
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

  /// Create a new ``RelativeHumidityRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure.
  ///   - dryBulb: The dry bulb temperature.
  ///   - humidityRatio: The humidity ratio.
  ///   - units: The units of measure.
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
  /// Create a new ``SpecificHumidityRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - relativeHumidity: The relative humidity.
  ///   - totalPressure: The total pressure.
  ///   - units: The units of measure.
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
  /// Create a new ``SpecificHumidityRequest`` with the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - relativeHumidity: The relative humidity.
  ///   - altitude: The altitude of the project.
  ///   - units: The units of measure.
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

  /// Create a new ``MoistAirRequest`` with  the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The temperature to calculate the specific volume for.
  ///   - relativeHumidity: The relative humidity to calculate the specific volume for.
  ///   - totalPressure: The altitude to calculate the specific volume for.
  ///   - units: The units of measure to solve for.
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

  /// Create a new ``MoistAirRequest`` with  the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The temperature to calculate the specific volume for.
  ///   - relativeHumidity: The relative humidity to calculate the specific volume for.
  ///   - altitude: The altitude to calculate the specific volume for.
  ///   - units: The unit of measure to solve for.
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

  /// Create a new ``WetBulbRequest`` with  the given parameters.
  ///
  /// - Parameters:
  ///   - dryBulb: The dry bulb temperature.
  ///   - relativeHumidity: The relative humidity.
  ///   - totalPressure: The total pressure.
  ///   - units: The unit of measure to solve for.
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
