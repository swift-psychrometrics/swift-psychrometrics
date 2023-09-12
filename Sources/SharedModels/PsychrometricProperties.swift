import Foundation

public struct PsychrometricProperties: Codable, Equatable, Sendable {

  public let atmosphericPressure: TotalPressure
  public let degreeOfSaturation: DegreeOfSaturation
  public let density: DensityOf<MoistAir>
  public let dewPoint: DewPoint
  public let dryBulb: DryBulb
  public let enthalpy: EnthalpyOf<MoistAir>
  public let grainsOfMoisture: GrainsOfMoisture
  public let humidityRatio: HumidityRatio
  public let relativeHumidity: RelativeHumidity
  public let vaporPressure: VaporPressure
  public let specificVolume: SpecificVolumeOf<MoistAir>
  public let wetBulb: WetBulb
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

extension PsychrometricProperties {
  public static var zero = Self.init(
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
