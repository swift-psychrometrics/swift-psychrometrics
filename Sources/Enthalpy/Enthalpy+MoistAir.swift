import Core
import Foundation
import HumidityRatio

extension Enthalpy2 where T == MoistAir {
  
  private struct Constants {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricEnvironment.Units
    
    init(units: PsychrometricEnvironment.Units) {
      self.units = units
      self.c1 = units == .imperial ? 0.24 : 1.006
      self.c2 = units == .imperial ? 1061 : 2501
      self.c3 = units == .imperial ? 0.444 : 1.86
    }
    
    func run(dryBulb: Temperature, ratio: HumidityRatio) -> Double {
      let T = units == .imperial ? dryBulb.fahrenheit : dryBulb.celsius
      let value = c1 * T + ratio.rawValue * (c2 + c3 * T)
      return units == .imperial ? value : value * 1000
    }
  }
  
  /// Create a new ``Enthalpy`` for the given temperature and humidity ratio.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1 eq. 30
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the enthalpy for.
  ///   - humidityRatio: The humidity ratio to calculate the enthalpy for.
  ///   - units: The units to solve for, if not supplied then the ``Core.environment`` will be used.
  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    let units = units ?? environment.units
    let value = Constants(units: units).run(dryBulb: temperature, ratio: humidityRatio)
    self.init(value, units: .for(units))
  }
}
