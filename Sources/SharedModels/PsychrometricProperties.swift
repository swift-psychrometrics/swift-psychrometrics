import Foundation

/// A container for psychrometric properties of an air sample.
///
/// This is used to find / list many of the psychrometric properties of an air sample.
///
public struct PsychrometricProperties: Codable, Equatable, Sendable {

  /// The total atmospheric pressure.
  public let atmosphericPressure: TotalPressure
  /// The degree of saturation.
  public let degreeOfSaturation: DegreeOfSaturation
  /// The density.
  public let density: DensityOf<MoistAir>
  /// The dew point temperature.
  public let dewPoint: DewPoint
  /// The dry bulb temperature.
  public let dryBulb: DryBulb
  /// The enthalpy.
  public let enthalpy: EnthalpyOf<MoistAir>
  /// The grains of moisture.
  public let grainsOfMoisture: GrainsOfMoisture
  /// The humidity ratio.
  public let humidityRatio: HumidityRatio
  /// The relative humidity.
  public let relativeHumidity: RelativeHumidity
  /// The specific volume.
  public let specificVolume: SpecificVolumeOf<MoistAir>
  /// The vapor pressure.
  public let vaporPressure: VaporPressure
  /// The wet bulb temperature.
  public let wetBulb: WetBulb
  /// The units of measure.
  public let units: PsychrometricUnits

  public init(
    atmosphericPressure: TotalPressure,
    degreeOfSaturation: DegreeOfSaturation,
    density: DensityOf<MoistAir>,
    dewPoint: DewPoint,
    dryBulb: DryBulb,
    enthalpy: EnthalpyOf<MoistAir>,
    grainsOfMoisture: GrainsOfMoisture,
    humidityRatio: HumidityRatio,
    relativeHumidity: RelativeHumidity,
    specificVolume: SpecificVolumeOf<MoistAir>,
    vaporPressure: VaporPressure,
    wetBulb: WetBulb,
    units: PsychrometricUnits
  ) {
    self.atmosphericPressure = atmosphericPressure
    self.degreeOfSaturation = degreeOfSaturation
    self.density = density
    self.dewPoint = dewPoint
    self.dryBulb = dryBulb
    self.enthalpy = enthalpy
    self.grainsOfMoisture = grainsOfMoisture
    self.humidityRatio = humidityRatio
    self.relativeHumidity = relativeHumidity
    self.specificVolume = specificVolume
    self.vaporPressure = vaporPressure
    self.wetBulb = wetBulb
    self.units = units
  }
}

public extension PsychrometricProperties {
  static let zero = Self(
    atmosphericPressure: .zero,
    degreeOfSaturation: .zero,
    density: .zero,
    dewPoint: .zero,
    dryBulb: .zero,
    enthalpy: .zero,
    grainsOfMoisture: .zero,
    humidityRatio: .zero,
    relativeHumidity: .zero,
    specificVolume: .zero,
    vaporPressure: .zero,
    wetBulb: .zero,
    units: .imperial
  )
}
