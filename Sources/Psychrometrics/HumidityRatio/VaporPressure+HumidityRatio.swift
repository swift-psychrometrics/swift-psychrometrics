import Foundation

extension VaporPressure {

  /// Create a new vapor ``Pressure`` for the given humidity ratio and total pressure.
  ///
  /// - Parameters:
  ///   - humidityRatio: The humidity ratio
  ///   - totalPressure: The total pressure.
  ///   - units: The units of measure, if not supplied this will default to ``Core.environment`` units.
  public init(
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    precondition(humidityRatio > 0)
    let units = units ?? PsychrometricEnvironment.shared.units
    let totalPressure = units.isImperial ? totalPressure.psi : totalPressure.pascals
    let value = totalPressure * humidityRatio / (HumidityRatio.moleWeightRatio + humidityRatio)
    self.init(value, units: .defaultFor(units: units))
  }
}
