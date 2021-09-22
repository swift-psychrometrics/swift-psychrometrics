import Core
import Foundation

extension Pressure {

  /// Create a new vapor ``Pressure`` for the given humidity ratio and total pressure.
  ///
  /// - Parameters:
  ///   - humidityRatio: The humidity ratio
  ///   - totalPressure: The total pressure.
  public init(
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure
  ) {
    let ratio = max(humidityRatio.rawValue, environment.minimumHumidityRatio)
    let totalPressure = environment.units == .imperial ? totalPressure.psi : totalPressure.pascals
    let value = totalPressure * ratio / (HumidityRatio.moleWeightRatio + ratio)
    self = environment.units == .imperial ? .psi(value) : .pascals(value)
  }
}
