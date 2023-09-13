import Dependencies
import PsychrometricClientLive
import SharedModels
import Tagged
import TestSupport
import XCTest

final class EnthalpyTests: PsychrometricTestCase {

  func test_enthalpy() async throws {
    @Dependency(\.psychrometricClient) var client

    let enthalpy = try await client.enthalpy.moistAir(
      .dryBulb(
        .fahrenheit(75),
        relativeHumidity: 50%
      ))
    XCTAssertEqual(round(enthalpy.rawValue.rawValue * 100) / 100, 28.11)

    //    let enthalpy2 = try await Temperature.fahrenheit(75)
    //      .enthalpy(at: 50%, pressure: .init(altitude: .seaLevel))
    //
    //    XCTAssertEqual(round(enthalpy2.rawValue.rawValue * 100) / 100, 28.11)
  }

  func test_enthalpy_at_altitude() async throws {
    @Dependency(\.psychrometricClient) var client

    //    let enthalpy = try await MoistAirEnthalpy(dryBulb: .fahrenheit(75), humidity: 50%, altitude: 1000, units: .imperial)
    let enthalpy = try await client.enthalpy.moistAir(
      .dryBulb(
        75,
        relativeHumidity: 50%,
        altitude: 1000,
        units: .imperial
      ))

    XCTAssertEqual(round(enthalpy.rawValue.rawValue * 100) / 100, 28.49)

    //    let enthalpy2 = try await Temperature.fahrenheit(75).enthalpy(at: 50%, altitude: 1000)
    //    XCTAssertEqual(round(enthalpy2.rawValue.rawValue * 100) / 100, 28.49)
  }

  func test_addition_and_subtraction() {
    var enthalpy: EnthalpyOf<MoistAir> = 28
    enthalpy += 1
    XCTAssertEqual(enthalpy.rawValue, 29)
    enthalpy -= 2
    XCTAssertEqual(enthalpy.rawValue, 27)
    //    enthalpy.rawValue -= 1
    //    XCTAssertEqual(enthalpy.rawValue, 26)
  }

  func test_equality() {
    let enthalpy: EnthalpyOf<MoistAir> = 28.11
    XCTAssertEqual(enthalpy, 28.11)
  }

  func test_comparable() {
    let enthalpy: EnthalpyOf<MoistAir> = 30
    XCTAssertTrue(enthalpy > 28)
  }

  func test_magnitude() {
    XCTAssertEqual(Enthalpy<DryAir>(10, units: .btuPerPound).magnitude, 10.magnitude)
  }

  func test_multiplication() {
    var enthalpy: EnthalpyOf<MoistAir> = 10 * 2
    XCTAssertEqual(enthalpy.rawValue, 20)
    enthalpy *= 2
    XCTAssertEqual(enthalpy.rawValue, 40)
  }

  func test_enthalpy_from_humidityRatio() async throws {
    @Dependency(\.psychrometricClient) var client

    let enthalpy = try await client.enthalpy.moistAir(
      .dryBulb(
        75,
        relativeHumidity: 50%
      ))

    let ratio = try await client.humidityRatio(.dryBulb(75, relativeHumidity: 50%))

    let enthalpy2 = try await client.enthalpy.moistAir(
      .dryBulb(
        75,
        humidityRatio: ratio,
        units: .imperial
      ))
    XCTAssertEqual(enthalpy.rawValue, enthalpy2.rawValue)
  }

  //  func test_temperature_from_enthalpy_and_ratio() async throws {
  //    @Dependency(\.psychrometricClient) var client;
  //
  //    let temperature: DryBulb = 75
  //    let humidity: RelativeHumidity = 50%
  ////    let ratio = try await HumidityRatio(dryBulb: temperature, humidity: humidity, altitude: .seaLevel)
  //    let ratio = try await client.humidityRatio(.dryBulb(
  //      temperature,
  //      relativeHumidity: humidity,
  //      altitude: .seaLevel
  //    ))
  ////    let enthalpy = try await EnthalpyOf<MoistAir>.init(dryBulb: temperature, ratio: ratio, units: .imperial)
  //
  //    let temperature2 = try await Temperature(enthalpy: enthalpy, ratio: ratio)
  //    XCTAssertEqual(
  //      round(temperature2.fahrenheit * 100) / 100,
  //      75
  //    )
  //    XCTAssertEqual(
  //      round(temperature2.fahrenheit * 100) / 100,
  //      temperature.fahrenheit
  //    )
  //  }

  func test_dry_air_enthalpy_imperial() async throws {
    @Dependency(\.psychrometricClient) var client
    let enthalpy = try await client.enthalpy.dryAir(.dryBulb(77))
    XCTAssertEqual(round(enthalpy.rawValue.rawValue * 10e8) / 10e8, 18.48)
  }

  // TODO: Tolerance is a bit high.
  func test_dry_air_enthalpy_metric() async throws {
    @Dependency(\.psychrometricClient) var client
    let enthalpy = try await client.enthalpy.dryAir(.dryBulb(.celsius(25), units: .metric))
    XCTApproximatelyEqual(enthalpy.rawValue, 25148, tolerance: 2)
  }

  // The tolerance is decent but exponentially worse at higher temperatures.
  func test_saturated_enthalpy_imperial() async throws {
    @Dependency(\.psychrometricClient) var client

    let values: [(DryBulb, Double, Double)] = [
      (.fahrenheit(-58), -13.906, 0.1),
      (.fahrenheit(-4), -0.286, 0.1),
      (.fahrenheit(23), 8.186, 0.1),
      (.fahrenheit(41), 15.699, 0.1),
      (.fahrenheit(77), 40.576, 0.11),
      (.fahrenheit(122), 126.066, 0.52),
      (.fahrenheit(185), 999.749, 8.8),
    ]

    for (temp, expected, tolerance) in values {
      let saturatedEnthalpy = try await client.enthalpy.moistAir(
        .dryBulb(
          temp,
          totalPressure: 14.696
        ))
      XCTApproximatelyEqual(saturatedEnthalpy.rawValue.rawValue, expected, tolerance: tolerance)
    }
  }

  // TODO: Fix tolerances.
  func test_saturated_enthalpy_metric() async throws {
    @Dependency(\.psychrometricClient) var client

    let values: [(DryBulb, Double, Double)] = [
      (.celsius(-50), -50222, 19.778),
      (.celsius(-20), -18542, 14.791),
      (.celsius(-5), 1164, 24.82),
      (.celsius(5), 18639, 48.51),
      (.celsius(25), 76504, 197.34),
      (.celsius(50), 275353, 1121.5),
      (.celsius(85), 2_307_539, 20095.2),
    ]

    for (temp, expected, tolerance) in values {
      let saturatedEnthalpy = try await client.enthalpy.moistAir(
        .dryBulb(
          temp,
          totalPressure: .pascals(101325),
          units: .metric
        ))
      XCTApproximatelyEqual(saturatedEnthalpy.rawValue.rawValue, expected, tolerance: tolerance)
    }
  }

  //  func test_dryBulb_from_enthalpy_and_humidityRatio_metric() async throws {
  //    let temperature = try await Temperature.init(
  //      enthalpy: 81316,
  //      ratio: 0.02,
  //      units: .metric
  //    )
  //    XCTApproximatelyEqual(temperature.celsius, 30, tolerance: 0.001)
  //  }

  //  func test_dryBulb_from_enthalpy_and_volume_metric() {
  //    let temperature = Temperature.ini
  //  }

  func test_moistAir_enthalpy_metric() async throws {
    @Dependency(\.psychrometricClient) var client
    let enthalpy = try await client.enthalpy.moistAir(
      .dryBulb(
        .celsius(30),
        humidityRatio: 0.02,
        units: .metric
      ))
    XCTApproximatelyEqual(enthalpy, 81316, tolerance: 0.0003)
  }

  //  func test_relative_humidity_for_dewPoint_and_dryBulb_enthalpies() {
  //    let totalPressure = Pressure(altitude: .seaLevel)
  //    let saturationPressure = Pressure.saturationPressure(at: 75)
  //    let rh = (saturationPressure.psi / totalPressure.psi)
  //    print(rh)
  //    XCTFail()
  //  }
}
