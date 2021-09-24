import Foundation

extension Pressure {

  public func dewPoint(
    dryBulb temperature: Temperature,
    units: PsychrometricEnvironment.Units? = nil
  ) -> DewPoint {
    dewPoint_from_vapor_pressure(temperature, self, units ?? environment.units)
  }
}

extension DewPoint {

  /// Create a new ``DewPoint`` from the given dry bulb temperature and vapor pressure.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - pressure: The partial pressure of water vapor in moist air.
  ///
  /// **Reference**: ASHRAE Handbook - Fundamentals (2017) ch. 1 eqn. 5 and 6
  ///
  /// - Note:
  ///  The dew point temperature is solved by inverting the equation giving water vapor pressure
  ///  at saturation from temperature rather than using the regressions provided
  ///  by ASHRAE (eqn. 37 and 38) which are much less accurate and have a
  ///  narrower range of validity.
  ///  The Newton-Raphson (NR) method is used on the logarithm of water vapour
  ///  pressure as a function of temperature, which is a very smooth function
  ///  Convergence is usually achieved in 3 to 5 iterations.
  ///  TDryBulb is not really needed here, just used for convenience.
  public init(
    dryBulb temperature: Temperature,
    vaporPressure pressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self = pressure.dewPoint(dryBulb: temperature, units: units)
  }
}

/// Helper that produces a dew-point from dry bulb temperature an vapor pressure.
private func dewPoint_from_vapor_pressure(
  _ dryBulb: Temperature,
  _ vaporPressure: Pressure,
  _ units: PsychrometricEnvironment.Units
) -> DewPoint {

  let bounds = environment.pressureBounds(for: units)
  let temperatureUnits: Temperature.Units = units.isImperial ? .fahrenheit : .celsius

  precondition(
    vaporPressure > .saturationPressure(at: bounds.low, units: units)
      && vaporPressure < .saturationPressure(at: bounds.high, units: units)
  )

  // First guesses
  var dewPoint = dryBulb
  let logVaporPressure = log(vaporPressure.rawValue)

  var index = 1

  while true {
    let dewPoint_iteration = dewPoint
    let logVaporPressure_iteration = log(
      Pressure.saturationPressure(at: dewPoint_iteration, units: units).rawValue
    )
    let derivative = Pressure.saturationPressureDerivative(at: dewPoint_iteration, units: units)

    // new estimate.
    let dewPointValue =
      dewPoint_iteration.rawValue
      - (logVaporPressure_iteration - logVaporPressure) / derivative.rawValue
    if dewPointValue > bounds.high.rawValue {
      dewPoint = bounds.high
    } else if dewPointValue < bounds.low.rawValue {
      dewPoint = bounds.low
    } else {
      dewPoint = .init(dewPointValue, units: temperatureUnits)
    }

    if fabs(dewPoint.rawValue - dewPoint_iteration.rawValue)
      <= environment.temperatureTolerance.rawValue
    {
      break
    } else if index > environment.maximumIterationCount {
      // Do something useful like throw an error.
      break
    }

    index += 1

  }

  guard dewPoint < dryBulb else {
    return .init(dryBulb)
  }

  return .init(dewPoint)
}
