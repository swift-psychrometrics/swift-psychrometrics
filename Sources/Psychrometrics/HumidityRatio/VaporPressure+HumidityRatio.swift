import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

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
    units: PsychrometricUnits? = nil
  ) {
    precondition(humidityRatio > 0)
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let totalPressure = units.isImperial ? totalPressure.psi : totalPressure.pascals
    let value =
      totalPressure * humidityRatio.rawValue
      / (HumidityRatio.moleWeightRatio + humidityRatio.rawValue)
    self.init(.init(value, units: .defaultFor(units: units)))
  }
}
