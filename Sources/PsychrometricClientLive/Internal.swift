import Foundation
import PsychrometricClient
import PsychrometricEnvironment
import SharedModels

// MARK: - Degree Of Saturation
extension PsychrometricClient.DegreeOfSaturationRequest {

  func degreeOfSaturation(
    environment: PsychrometricEnvironment
  ) async throws -> DegreeOfSaturation {
    guard humidityRatio > 0 else {
      throw ValidationError(
        label: "Psychrometrics.degreeOfSaturation",
        summary: "Humidity ratio should be greater than 0."
      )
    }
    let saturatedHumidityRatio = try await PsychrometricClient.HumidityRatioRequest.dryBulb(
      dryBulb,
      totalPressure: totalPressure,
      units: units
    ).humidityRatio(environment: environment)

    return .init(
      humidityRatio.value / saturatedHumidityRatio.value
    )

  }
}

// MARK: - Density
extension PsychrometricClient.DensityClient.DryAirRequest {

  fileprivate struct Constants {
    let universalGasConstant: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: DryBulb, pressure: TotalPressure) async -> Double {
      let T = units.isImperial ? dryBulb.rankine : dryBulb.kelvin
      let pressure = units.isImperial ? pressure.psi : pressure.pascals

      guard units.isImperial else {
        return pressure / universalGasConstant / T
      }

      /// Convert pressure in pounds per square inch to pounds per cubic foot.
      return (pressure * 144) / universalGasConstant / T
    }
  }

  func density(environment: PsychrometricEnvironment) async -> DensityOf<DryAir> {
    let units = self.units ?? environment.units
    let density = await Constants(units: units).run(
      dryBulb: self.dryBulb,
      pressure: self.totalPressure
    )
    return .init(.init(density, units: .defaultFor(units: units)))
  }
}

extension PsychrometricClient.DensityClient.MoistAirRequest {

  func density(
    environment: PsychrometricEnvironment
  ) async throws -> DensityOf<MoistAir> {
    guard self.humidityRatio > 0 else {
      throw ValidationError(
        summary: "Humidity ratio should be greater than 0"
      )
    }

    let units = self.units ?? environment.units
    let density = (1 + self.humidityRatio.rawValue) / self.specificVolume.rawValue
    return .init(.init(density, units: .defaultFor(units: units)))

  }
}

func waterDensity(
  _ temperature: DryBulb,
  environment: PsychrometricEnvironment
) async -> DensityOf<Water> {

  let value =
    62.56
    + 3.413
    * (pow(10, -4) * temperature.fahrenheit)
    - 6.255
    * pow((pow(10, -5) * temperature.fahrenheit), 2)

  return .init(.init(value, units: .poundsPerCubicFoot))
}

// MARK: - Dew Point
extension PsychrometricClient.DewPointRequest {

  fileprivate struct ConstantsAboveFreezing {

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

  fileprivate struct ConstantsBelowFreezing {
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

  func dewPoint(environment: PsychrometricEnvironment) async -> DewPoint {
    let units = self.units ?? environment.units
    let triplePoint = PsychrometricEnvironment.triplePointOfWater(for: units)
    let value =
    temperature <= triplePoint
      ? ConstantsBelowFreezing(units: units).run(vaporPressure: vaporPressure)
      : ConstantsAboveFreezing(units: units).run(vaporPressure: vaporPressure)
    return .init(.init(value, units: .defaultFor(units: units)))
  }
}

// MARK: - Enthalpy
extension PsychrometricClient.EnthalpyClient.DryAirRequest {
  func enthalpy(
    environment: PsychrometricEnvironment
  ) async -> EnthalpyOf<DryAir> {
    let units = self.units ?? environment.units
    let specificHeat = units.isImperial ? 0.24 : 1006
    let temperature = units.isImperial ? temperature.fahrenheit : temperature.celsius
    return .init(
      .init(
        specificHeat * temperature,
        units: .defaultFor(units: units)
      ))
  }
}

extension PsychrometricClient.EnthalpyClient.MoistAirRequest {
  internal struct Constants {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 0.24 : 1.006
      self.c2 = units.isImperial ? 1061 : 2501
      self.c3 = units.isImperial ? 0.444 : 1.86
    }

    func run(dryBulb: DryBulb, ratio: HumidityRatio) async -> Double {
      let T = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let value = c1 * T + ratio.rawValue * (c2 + c3 * T)
      return units.isImperial ? value : value * 1000
    }

    func dryBulb(enthalpy: EnthalpyOf<MoistAir>, ratio: HumidityRatio) async -> DryBulb {
      let intermediateValue =
        units.isImperial
        ? enthalpy.rawValue.rawValue - c2 * ratio.rawValue
        : enthalpy.rawValue.rawValue / 1000 - c2 * ratio.rawValue
      let value = intermediateValue / (c1 + c3 * ratio.rawValue)
      return units.isImperial ? .fahrenheit(value) : .celsius(value)
    }
  }

  func enthalpy(environment: PsychrometricEnvironment) async -> EnthalpyOf<MoistAir> {
    let units = self.units ?? environment.units
    let value = await Constants(units: units).run(
      dryBulb: temperature,
      ratio: humidityRatio
    )
    return .init(.init(value, units: .defaultFor(units: units)))

  }
}

// MARK: - Grains of Moisture
extension PsychrometricClient.GrainsOfMoistureRequest {

  private func saturationHumidity(
    saturationPressure: SaturationPressure,
    totalPressure: TotalPressure
  ) async -> Double {
    7000 * GrainsOfMoisture.moleWeightRatio
      * saturationPressure.psi
      / (totalPressure.psi - saturationPressure.psi)
  }

  func grainsOfMoisture(environment: PsychrometricEnvironment) async throws -> GrainsOfMoisture {
    let saturationPressure = try await PsychrometricClient.SaturationPressureRequest(
      temperature: temperature,
      units: environment.units
    ).saturationPressure(environment: environment)
    let saturationHumidity = await saturationHumidity(
      saturationPressure: saturationPressure,
      totalPressure: totalPressure
    )
    return .init(saturationHumidity * humidity.fraction)
  }

}

// MARK: - Humidity Ratio
extension PsychrometricClient.HumidityRatioRequest {

  private var moleWeightRatio: Double {
    HumidityRatio.moleWeightRatio
  }

  private struct EnthalpyConstants {
    let c1: Double
    let c2: Double
    let c3: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.c1 = units.isImperial ? 0.24 : 1.006
      self.c2 = units.isImperial ? 1061 : 2501
      self.c3 = units.isImperial ? 0.444 : 1.86
    }

    func run(enthalpy: EnthalpyOf<MoistAir>, dryBulb: DryBulb) async -> Double {
      let T = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let intermediateValue =
        units.isImperial
        ? enthalpy.rawValue.rawValue - c1 * T
        : enthalpy.rawValue.rawValue / 1000 - c1 * T

      return intermediateValue / (c2 + c3 * T)
    }
  }

  private struct ConstantsAboveFreezing {

    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double

    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.c1 = units.isImperial ? 1093 : 2501
      self.c2 = units.isImperial ? 0.556 : 2.326
      self.c3 = units.isImperial ? 0.24 : 1.006
      self.c4 = units.isImperial ? 0.444 : 1.86
      self.units = units
    }

    func run(
      dryBulb: DryBulb,
      wetBulb: WetBulb,
      saturatedHumidityRatio: HumidityRatio
    ) -> Double {
      let dryBulb = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let wetBulb = units.isImperial ? wetBulb.fahrenheit : wetBulb.celsius
      return ((c1 - c2 * wetBulb) * saturatedHumidityRatio.rawValue - c3 * (dryBulb - wetBulb))
        / (c1 + c4 * dryBulb - wetBulb)
    }
  }

  private struct ConstantsBelowFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.c1 = units.isImperial ? 1220 : 2830
      self.c2 = units.isImperial ? 0.04 : 0.24
      self.c3 = units.isImperial ? 0.24 : 1.006
      self.c4 = units.isImperial ? 0.44 : 1.86
      self.c5 = units.isImperial ? 0.48 : 2.1
      self.units = units
    }

    func run(
      dryBulb: DryBulb,
      wetBulb: WetBulb,
      saturatedHumidityRatio: HumidityRatio
    ) -> Double {
      let dryBulb = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
      let wetBulb = units.isImperial ? wetBulb.fahrenheit : wetBulb.celsius
      let diff = dryBulb - wetBulb
      return ((c1 - c2 * wetBulb) * saturatedHumidityRatio.rawValue - c3 * diff)
        / (c1 + c4 * dryBulb - c5 * wetBulb)
    }
  }

  func humidityRatio(environment: PsychrometricEnvironment) async throws -> HumidityRatio {

    switch self {

    case let .enthalpy(enthalpy, dryBulb: dryBulb, units: units):
      let units = units ?? environment.units
      let value = await EnthalpyConstants(units: units).run(
        enthalpy: enthalpy,
        dryBulb: dryBulb
      )
      return .init(.init(value))

    case let .totalPressure(totalPressure, partialPressure: partialPressure, units: units):
      let units = units ?? environment.units
      let partialPressure = units.isImperial ? partialPressure.psi : partialPressure.pascals
      let totalPressure = units.isImperial ? totalPressure.psi : totalPressure.pascals

      return .init(
        .init(
          moleWeightRatio * partialPressure / (totalPressure - partialPressure)
        ))

    case let .specificHumidity(specificHumidity):
      guard specificHumidity.rawValue > 0.0 else {
        throw ValidationError(
          label: "Humidity Ratio",
          summary: "Specific humidity should be greater than 0"
        )
      }
      guard specificHumidity.rawValue < 1.0 else {
        throw ValidationError(
          label: "Humidity Ratio",
          summary: "Specific humidity should be less than 1.0"
        )
      }
      return .init(
        .init(
          specificHumidity.rawValue / (1 - specificHumidity.rawValue)
        ))

    case let .waterMass(waterMass, dryAirMass: dryAirMass):
      return .init(
        .init(
          moleWeightRatio * (waterMass / dryAirMass)
        ))

    case let .wetBulb(
      wetBulb, dryBulb: dryBulb, saturatedHumidityRatio: saturatedHumidityRatio, units: units):
      guard dryBulb.value > wetBulb.value else {
        throw ValidationError(
          label: "Humidity Ratio",
          summary: "Wet bulb temperature should be less than dry bulb temperature."
        )
      }

      let units = units ?? environment.units

      let triplePoint = PsychrometricEnvironment.triplePointOfWater(for: units)
      guard wetBulb.value > triplePoint.value else {
        return .init(
          .init(
            ConstantsAboveFreezing(units: units).run(
              dryBulb: dryBulb,
              wetBulb: wetBulb,
              saturatedHumidityRatio: saturatedHumidityRatio
            )
          ))
      }
      return .init(
        .init(
          ConstantsBelowFreezing(units: units).run(
            dryBulb: dryBulb,
            wetBulb: wetBulb,
            saturatedHumidityRatio: saturatedHumidityRatio
          )
        ))
    }
  }
}

// MARK: - Psychrometric Properties
extension PsychrometricClient.PsychrometricPropertiesRequest {

  func psychrometricProperties(
    environment: PsychrometricEnvironment
  ) async throws -> PsychrometricProperties {
    let units = self.units ?? environment.units

    let humidityRatio = try await PsychrometricClient.HumidityRatioRequest.wetBulb(
      wetBulb,
      dryBulb: dryBulb,
      totalPressure: totalPressure,
      units: units
    ).humidityRatio(environment: environment)

    let relativeHumidity = try await PsychrometricClient.RelativeHumidityRequest.dryBulb(
      dryBulb,
      humidityRatio: humidityRatio,
      totalPressure: totalPressure,
      units: units
    ).relativeHumdity(environment: environment)

    return try await .init(
      atmosphericPressure: totalPressure,
      degreeOfSaturation: PsychrometricClient.DegreeOfSaturationRequest.dryBulb(
        dryBulb,
        humidityRatio: humidityRatio,
        totalPressure: totalPressure,
        units: units
      ).degreeOfSaturation(environment: environment),
      density: PsychrometricClient.DensityClient.MoistAirRequest.dryBulb(
        dryBulb,
        humidityRatio: humidityRatio,
        totalPressure: totalPressure,
        units: units
      ).density(environment: environment),
      dewPoint: PsychrometricClient.DewPointRequest.dryBulb(
        dryBulb,
        humidityRatio: humidityRatio,
        totalPressure: totalPressure,
        units: units
      ).dewPoint(environment: environment),
      dryBulb: dryBulb,
      enthalpy: PsychrometricClient.EnthalpyClient.MoistAirRequest.dryBulb(
        dryBulb,
        humidityRatio: humidityRatio,
        units: units
      ).enthalpy(environment: environment),
      grainsOfMoisture: PsychrometricClient.GrainsOfMoistureRequest.dryBulb(
        dryBulb,
        relativeHumidity: relativeHumidity,
        totalPressure: totalPressure
      ).grainsOfMoisture(environment: environment),
      humidityRatio: humidityRatio,
      relativeHumidity: relativeHumidity,
      specificVolume: PsychrometricClient.SpecificVolumeClient.MoistAirRequest.dryBulb(
        dryBulb,
        humidityRatio: humidityRatio,
        totalPressure: totalPressure,
        units: units
      ).specificVolume(environment: environment),
      vaporPressure: PsychrometricClient.VaporPressureRequest.humidityRatio(
        humidityRatio,
        totalPressure: totalPressure,
        units: units
      ).vaporPressure(environment: environment),
      wetBulb: wetBulb,
      units: units
    )
  }
}

// MARK: - Relative Humidity
extension PsychrometricClient.RelativeHumidityRequest {

  func relativeHumdity(environment: PsychrometricEnvironment) async throws -> RelativeHumidity {

    switch self {
    case let .dewPoint(dewPoint, dryBulb: dryBulb):
      let humidity =
        100
        * (exp((17.625 * dewPoint.celsius) / (243.04 + dewPoint.celsius))
          / exp((17.625 * dryBulb.celsius) / (243.04 + dryBulb.celsius)))
      return .init(.init(humidity))

    case let .vaporPressure(vaporPressure, dryBulb: dryBulb, units: units):
      guard vaporPressure > 0 else {
        throw ValidationError(
          label: "Relative Humidity",
          summary: "Vapor pressure should be greater than 0."
        )
      }

      let units = units ?? environment.units
      let saturationPressure = try await PsychrometricClient.SaturationPressureRequest(
        temperature: dryBulb,
        units: units
      ).saturationPressure(environment: environment)
      let vaporPressure = units.isImperial ? vaporPressure.psi : vaporPressure.pascals
      let saturationPressureValue =
        units.isImperial ? saturationPressure.psi : saturationPressure.pascals
      let fraction = vaporPressure / saturationPressureValue
      return .init(.init(fraction * 100))
    }
  }
}

// MARK: - Saturation Pressure
extension PsychrometricClient.SaturationPressureRequest {

  private struct ConstantsBelowFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let c6: Double
    let c7: Double

    private let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.c1 = units.isImperial ? -1.0214165e4 : -5.6745359e3
      self.c2 = units.isImperial ? -4.8932428 : 6.3925247
      self.c3 = units.isImperial ? -5.3765794e-3 : -9.677843E-03
      self.c4 = units.isImperial ? 1.9202377e-7 : 6.2215701E-07
      self.c5 = units.isImperial ? 3.5575832e-10 : 2.0747825E-09
      self.c6 = units.isImperial ? -9.0344688e-14 : -9.484024E-13
      self.c7 = units.isImperial ? 4.1635019 : 4.1635019
      self.units = units
    }

    fileprivate func exponent(dryBulb temperature: DryBulb) async -> Double {
      let T = units.isImperial ? temperature.rankine : temperature.kelvin
      return c1 / T
        + c2
        + c3 * T
        + c4 * pow(T, 2)
        + c5 * pow(T, 3)
        + c6 * pow(T, 4)
        + c7 * log(T)
    }

    fileprivate func derivative(dryBulb temperature: DryBulb) async -> Double {
      let T = units.isImperial ? temperature.rankine : temperature.kelvin
      return (c1 * -1)
        / pow(T, 2)
        + c3
        + 2 * c4 * T
        + 3 * c5 * pow(T, 2)
        - 4 * (c6 * -1) * pow(T, 3)
        + c7 / T
    }
  }

  private struct ConstantsAboveFreezing {
    let c1: Double
    let c2: Double
    let c3: Double
    let c4: Double
    let c5: Double
    let c6: Double

    private let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.c1 = units.isImperial ? -1.0440397e4 : -5.8002206e03
      self.c2 = units.isImperial ? -1.1294650e1 : 1.3914993
      self.c3 = units.isImperial ? -2.7022355e-2 : -4.8640239e-2
      self.c4 = units.isImperial ? 1.2890360e-5 : 4.1764768e-5
      self.c5 = units.isImperial ? -2.4780681e-9 : -1.4452093e-8
      self.c6 = units.isImperial ? 6.5459673 : 6.5459673
      self.units = units
    }

    fileprivate func exponent(dryBulb temperature: DryBulb) async -> Double {
      let T = units.isImperial ? temperature.rankine : temperature.kelvin
      return c1 / T
        + c2
        + c3 * T
        + c4 * pow(T, 2)
        + c5 * pow(T, 3)
        + c6 * log(T)
    }
  }

  func saturationPressure(
    environment: PsychrometricEnvironment
  ) async throws -> SaturationPressure {
    let units = self.units ?? environment.units
    let bounds = PsychrometricEnvironment.pressureBounds(for: units)
    let triplePoint = PsychrometricEnvironment.triplePointOfWater(for: units)

    guard temperature >= bounds.low && temperature <= bounds.high
    else {
      throw ValidationError(
        label: "Saturation Pressure",
        summary: "Temperature should be between \(bounds.low)-\(bounds.high)"
      )
    }

    let exponent =
      await temperature <= triplePoint
      ? ConstantsBelowFreezing(units: units).exponent(dryBulb: temperature)
      : ConstantsAboveFreezing(units: units).exponent(dryBulb: temperature)

    return .init(
      .init(
        exp(exponent),
        units: .defaultFor(units: units)
      ))
  }
}

// MARK: - Specific Heat
extension DryBulb {

  func waterSpecificHeat() async -> SpecificHeat {
    let specificHeat =
      1.012481 - 3.079704 * pow(10, -4) * fahrenheit
      + 1.752657 * pow(pow(10, -6) * fahrenheit, 2)
      - 2.078224 * pow(pow(10, -9) * fahrenheit, 3)

    return .fahrenheit(specificHeat)
  }
}

// MARK: - Specific Humidity
extension PsychrometricClient.SpecificHumidityRequest {

  func specificHumidity(environment: PsychrometricEnvironment) async -> SpecificHumidity {

    switch self {
    case let .humidityRatio(humidityRatio, units: units):
      return .init(
        humidityRatio.rawValue / (1 + humidityRatio.rawValue),
        units: .defaultFor(units: units ?? environment.units)
      )

    case let .waterMass(waterMass, dryAirMass: dryAirmass, units: units):
      return .init(
        waterMass / (waterMass + dryAirmass),
        units: .defaultFor(units: units ?? environment.units)
      )
    }
  }
}

// MARK: - Specific Volume
extension PsychrometricClient.SpecificVolumeClient.DryAirRequest {
  private struct Constants {
    let units: PsychrometricUnits
    let universalGasConstant: Double

    init(units: PsychrometricUnits) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: DryBulb, pressure: TotalPressure) async -> Double {
      let T = units.isImperial ? dryBulb.rankine : dryBulb.kelvin
      let P = units.isImperial ? pressure.psi : pressure.pascals
      guard units.isImperial else {
        return universalGasConstant * T / P
      }
      return universalGasConstant * T / (144 * P)
    }
  }

  func specificVolume(environment: PsychrometricEnvironment) async -> SpecificVolumeOf<DryAir> {
    let units = units ?? environment.units
    let value = await Constants(units: units).run(
      dryBulb: dryBulb,
      pressure: totalPressure
    )
    return .init(value, units: .defaultFor(units: units))
  }
}

extension PsychrometricClient.SpecificVolumeClient.MoistAirRequest {
  private struct Constants {
    let universalGasConstant: Double
    let c1: Double = 1.607858
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: DryBulb, ratio: HumidityRatio, pressure: TotalPressure) async -> Double {
      let T = units.isImperial ? dryBulb.rankine : dryBulb.kelvin
      let P = units.isImperial ? pressure.psi : pressure.pascals
      let intermediateValue = universalGasConstant * T * (1 + c1 * ratio.rawValue)
      return units.isImperial ? intermediateValue / (144 * P) : intermediateValue / P
    }

    // inverts the calculation to solve for dry-bulb
    func dryBulb(volume: SpecificVolumeOf<MoistAir>, ratio: HumidityRatio, pressure: TotalPressure)
      async -> DryBulb
    {
      let P = units.isImperial ? pressure.psi : pressure.pascals
      let c2 = units.isImperial ? 144.0 : 1.0
      let value = volume.rawValue * (c2 * P) / (universalGasConstant * (1 + c2 * ratio.rawValue))
      return units.isImperial ? .rankine(value) : .kelvin(value)
    }
  }

  func specificVolume(environment: PsychrometricEnvironment) async -> SpecificVolumeOf<MoistAir> {
    let units = units ?? environment.units
    let value = await Constants(units: units).run(
      dryBulb: dryBulb,
      ratio: humidityRatio,
      pressure: totalPressure
    )
    return .init(value, units: .defaultFor(units: units))
  }
}

// MARK: - Vapor Pressure
extension PsychrometricClient.VaporPressureRequest {

  func vaporPressure(environment: PsychrometricEnvironment) async throws -> VaporPressure {

    switch self {
    case let .humidityRatio(humidityRatio, totalPressure: totalPressure, units: units):
      guard humidityRatio > 0 else {
        throw ValidationError(
          label: "Vapor Pressure",
          summary: "Humidity ratio should be greater than 0."
        )
      }

      let units = units ?? environment.units
      let totalPressure = units.isImperial ? totalPressure.psi : totalPressure.pascals
      let value =
        totalPressure * humidityRatio.rawValue
        / (HumidityRatio.moleWeightRatio + humidityRatio.rawValue)
      return .init(.init(value, units: .defaultFor(units: units)))

    case let .relativeHumidity(relativeHumidity, dryBulb: dryBulb, units: units):
      let units = units ?? environment.units
      let saturationPressure = try await PsychrometricClient.SaturationPressureRequest(
        temperature: dryBulb,
        units: units
      ).saturationPressure(environment: environment)
      let value = saturationPressure.rawValue.rawValue * relativeHumidity.fraction
      return .init(.init(value, units: .defaultFor(units: units)))

    }
  }
}

extension PsychrometricClient.WetBulbRequest {

  func wetBulb(environment: PsychrometricEnvironment) async throws -> WetBulb {
    guard humidityRatio > 0 else {
      throw ValidationError(
        label: "Wet Bulb",
        summary: "Humidity ratio should be greater than 0."
      )
    }

    let units = units ?? environment.units

    let dewPoint = try await PsychrometricClient.DewPointRequest.dryBulb(
      dryBulb,
      humidityRatio: humidityRatio,
      totalPressure: totalPressure,
      units: units
    ).dewPoint(environment: environment)

    let temperatureUnits = units.isImperial ? Temperature<MoistAir>.Units.fahrenheit : .celsius

    // Initial guesses
    var wetBulbSup = units.isImperial ? dryBulb.fahrenheit : dryBulb.celsius
    var wetBulbInf = units.isImperial ? dewPoint.fahrenheit : dewPoint.celsius
    var wetBulb = (wetBulbInf + wetBulbSup) / 2

    var index = 1

    while (wetBulbSup - wetBulbInf) > environment.temperatureTolerance.value {

      let ratio = try await PsychrometricClient.HumidityRatioRequest.wetBulb(
        .init(.init(wetBulb, units: temperatureUnits)),
        dryBulb: dryBulb,
        totalPressure: totalPressure,
        units: units
      ).humidityRatio(environment: environment)

      if ratio > humidityRatio {
        wetBulbSup = wetBulb
      } else {
        wetBulbInf = wetBulb
      }

      // new guess of wet bulb
      wetBulb = (wetBulbSup + wetBulbInf) / 2

      if index >= environment.maximumIterationCount {
        throw MaxIterationError()
      }

      index += 1
    }

    return .init(.init(wetBulb, units: temperatureUnits))
  }
}

struct MaxIterationError: Error {}
