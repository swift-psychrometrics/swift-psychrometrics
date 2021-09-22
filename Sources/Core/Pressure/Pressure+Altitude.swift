import Foundation

extension Pressure {

  private struct Constants {
    let c1: Double
    let c2: Double
    let c3 = 5.2559
    let units: PsychrometricEnvironment.Units

    init(units: PsychrometricEnvironment.Units) {
      self.units = units
      self.c1 = units == .imperial ? 14.696 : 101325
      self.c2 = units == .imperial ? 6.8754e-06 : 2.25577e-05
    }

    func run(altitude: Length) -> Double {
      let altitude = units == .imperial ? altitude.feet : altitude.meters
      return c1 * pow(1 - c2 * altitude, c3)
    }
  }

  /// Create a new ``Pressure`` for the given altitude.
  ///
  /// - Note:
  ///   The altitude will be converted to the appropriate unit of measure base on the units you are trying to solve for.
  ///
  /// - Parameters:
  ///   - altitude: The altitude to calculate the pressure.
  ///   - units: The unit of measure to solve the pressure for, if not supplied then will default to ``Core.environment`` units.
  public init(
    altitude: Length,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    let units = units ?? environment.units
    let value = Constants(units: units).run(altitude: altitude)
    self.init(value, units: .for(units))
  }
}
