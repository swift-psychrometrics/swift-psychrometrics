
public struct PsychrometricResponse: Codable, Equatable, Sendable {
  
  public let atmosphericPressure: Pressure
  public let degreeOfSaturation: Double
  public let density: DensityOf<MoistAir>
  public let dewPoint: DewPoint
  public let dryBulb: Temperature
  public let enthalpy: MoistAirEnthalpy
  public let humidityRatio: HumidityRatio
  public let relativeHumidity: RelativeHumidity
  public let vaporPressure: VaporPressure
  public let volume: SpecificVolumeOf<MoistAir>
  public let wetBulb: WetBulb
  public let units: PsychrometricUnits
  
  public init(
    atmosphericPressure: Pressure,
    degreeOfSaturation: Double,
    density: DensityOf<MoistAir>,
    dewPoint: DewPoint,
    dryBulb: Temperature,
    enthalpy: MoistAirEnthalpy,
    humidityRatio: HumidityRatio,
    relativeHumidity: RelativeHumidity,
    vaporPressure: VaporPressure,
    volume: SpecificVolumeOf<MoistAir>,
    wetBulb: WetBulb,
    units: PsychrometricUnits
  ) {
    self.atmosphericPressure = atmosphericPressure
    self.degreeOfSaturation = degreeOfSaturation
    self.density = density
    self.dewPoint = dewPoint
    self.dryBulb = dryBulb
    self.enthalpy = enthalpy
    self.humidityRatio = humidityRatio
    self.relativeHumidity = relativeHumidity
    self.vaporPressure = vaporPressure
    self.volume = volume
    self.wetBulb = wetBulb
    self.units = units
  }
}
