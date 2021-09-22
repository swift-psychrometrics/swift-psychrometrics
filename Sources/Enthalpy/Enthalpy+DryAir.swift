import Core
import Foundation


extension Enthalpy2 where T == DryAir {
  
  private struct Constants {
    let specificHeat: Double
    let units: PsychrometricEnvironment.Units
    
    init(units: PsychrometricEnvironment.Units) {
      self.units = units
      self.specificHeat = units == .imperial ? 0.24 : 1006
    }
    
    func run(_ dryBulb: Temperature) -> Double {
      let T = units == .imperial ? dryBulb.fahrenheit : dryBulb.celsius
      return specificHeat * T
    }
  }
  
  /// Create a new ``Enthalpy`` of ``DryAir`` for the given dry bulb temperature and unit of measure.
  ///
  /// **Reference**:  ASHRAE - Fundamentals (2017) ch. 1 eq 28
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature in °F [IP] or °C [SI].
  ///   - units: The unit of measure, if not supplied then we will resolve from the ``environment`` setting.
  public init(
    dryBulb temperature: Temperature,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    let units = units ?? environment.units
    let value = Constants(units: units).run(temperature)
    self.init(value, units: .for(units))
  }
}
