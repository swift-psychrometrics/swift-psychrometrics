import Dependencies
import Foundation
import PsychrometricEnvironment
import SharedModels

// TODO: Remove
extension DewPoint {

  /// Creates a new ``DewPoint`` for the given dry bulb temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - relativeHumidity: The relative humidity.
  public init(
    dryBulb temperature: Temperature,
    humidity relativeHumidity: RelativeHumidity,
    units: PsychrometricUnits? = nil
  ) async throws {
    try await self.init(
      dryBulb: temperature,
      vaporPressure: .init(dryBulb: temperature, humidity: relativeHumidity, units: units),
      units: units
    )
  }
}

extension Temperature {

  /// Calculate the ``DewPoint`` of our current value given the humidity.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity to use to calculate the dew-point.
  public func dewPoint(humidity: RelativeHumidity) async throws -> DewPoint {
    try await .init(dryBulb: self, humidity: humidity)
  }
}

extension DewPoint {

  fileprivate struct DewPointConstantsAboveFreezing {

    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let c6 = 0.1984
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 100.45 : 6.54
      self.c2 = units.isImperial ? 33.193 : 14.526
      self.c3 = units.isImperial ? 2.319 : 0.7389
      self.c4 = units.isImperial ? 0.17074 : 0.09486
      self.c5 = units.isImperial ? 1.2063 : 0.4569
    }

    func run(vaporPressure: VaporPressure) -> Double {
      let P = units.isImperial ? vaporPressure.psi : vaporPressure.pascals / 1000
      let logNatural = log(P)
      return c1
        + c2 * logNatural
        + c3 * pow(logNatural, 2)
        + c4 * pow(logNatural, 3)
        + c5 * pow(P, 0.1984)
    }
  }

  fileprivate struct DewPointConstantsBelowFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 90.12 : 6.09
      self.c2 = units.isImperial ? 26.142 : 12.608
      self.c3 = units.isImperial ? 0.8927 : 0.4959
    }

    func run(vaporPressure: VaporPressure) -> Double {
      let P = units.isImperial ? vaporPressure.psi : vaporPressure.pascals / 1000
      let logNatural = log(P)
      return c1
        + c2 * logNatural
        + c3 * pow(logNatural, 2)
    }
  }

  /// Create a new ``DewPoint`` from the given dry bulb temperature and vapor pressure.
  ///
  /// **Reference**: ASHRAE Handbook - Fundamentals (2017) ch. 1 eqn. 37 and 38
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - pressure: The partial pressure of water vapor in moist air.
  public init(
    dryBulb temperature: Temperature,
    vaporPressure pressure: VaporPressure,
    units: PsychrometricUnits? = nil
  ) async {
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units
    let triplePoint = PsychrometricEnvironment.triplePointOfWater(for: units)
    let value =
      temperature <= triplePoint
      ? DewPointConstantsBelowFreezing(units: units).run(vaporPressure: pressure)
      : DewPointConstantsAboveFreezing(units: units).run(vaporPressure: pressure)
    self.init(.init(value, units: .defaultFor(units: units)))
  }
}

// MARK: - Wet Bulb

extension DewPoint {

  public init(
    dryBulb temperature: Temperature,
    wetBulb: WetBulb,
    pressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    guard temperature > wetBulb.rawValue else {
      throw ValidationError(
        summary: "Wet bulb temperature should be less than dry bulb temperature."
      )
    }
    let humidityRatio = try await HumidityRatio(
      dryBulb: temperature,
      wetBulb: wetBulb,
      pressure: pressure,
      units: units
    )
    try await self.init(
      dryBulb: temperature,
      ratio: humidityRatio,
      pressure: pressure,
      units: units
    )
  }
}

// MARK: - Humidity Ratio

extension DewPoint {
  
  /// Create a new ``DewPoint`` for the given dry bulb temperature, humidity ratio, and atmospheric pressure.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature.
  ///   - humidityRatio: The humidity ratio.
  ///   - totalPressure: The atmospheric pressure.
  ///   - units: The units to solve for, if not supplied then ``Core.environment`` units will be used.
  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) async throws {
    guard humidityRatio > 0 else {
      throw ValidationError(summary: "Humidity ratio should be greater than 0.")
    }
    
    try await self.init(
      dryBulb: temperature,
      vaporPressure: .init(ratio: humidityRatio, pressure: totalPressure),
      units: units
    )
  }
}
