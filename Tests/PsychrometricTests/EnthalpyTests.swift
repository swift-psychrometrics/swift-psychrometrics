import XCTest
import Psychrometrics
import SharedModels
import TestSupport

final class EnthalpyTests: XCTestCase {
  
  func test_enthalpy() {
    let enthalpy = MoistAirEnthalpy(dryBulb: .fahrenheit(75), humidity: 50%, units: .imperial)
    XCTAssertEqual(round(enthalpy.rawValue.rawValue * 100) / 100, 28.11)
    
    let enthalpy2 = Temperature.fahrenheit(75)
      .enthalpy(at: 50%, pressure: .init(altitude: .seaLevel))
    
    XCTAssertEqual(round(enthalpy2.rawValue.rawValue * 100) / 100, 28.11)
  }
  
  func test_enthalpy_at_altitude() {
    let enthalpy = MoistAirEnthalpy(dryBulb: .fahrenheit(75), humidity: 50%, altitude: 1000, units: .imperial)
    XCTAssertEqual(round(enthalpy.rawValue.rawValue * 100) / 100, 28.49)
    
    let enthalpy2 = Temperature.fahrenheit(75).enthalpy(at: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy2.rawValue.rawValue * 100) / 100, 28.49)
  }
  
  func test_addition_and_subtraction() {
    var enthalpy: MoistAirEnthalpy = 28
    enthalpy += 1
    XCTAssertEqual(enthalpy.rawValue, 29)
    enthalpy -= 2
    XCTAssertEqual(enthalpy.rawValue, 27)
//    enthalpy.rawValue -= 1
//    XCTAssertEqual(enthalpy.rawValue, 26)
  }
  
  func test_equality() {
    XCTAssertEqual(MoistAirEnthalpy.init(28.11), 28.11)
  }
  
  func test_comparable() {
    XCTAssertTrue(MoistAirEnthalpy.init(exactly: 30)! > 28)
  }
  
  func test_magnitude() {
    XCTAssertEqual(MoistAirEnthalpy.init(10).magnitude, 10.magnitude)
  }
  
  func test_multiplication() {
    var enthalpy: MoistAirEnthalpy = 10 * 2
    XCTAssertEqual(enthalpy.rawValue, 20)
    enthalpy *= 2
    XCTAssertEqual(enthalpy.rawValue, 40)
  }
  
  func test_humidityRatio_from_enthalpy() {
    let enthalpy = MoistAirEnthalpy(dryBulb: 75, humidity: 50%, units: .imperial)
    let ratio = HumidityRatio(dryBulb: 75, humidity: 50%, altitude: .seaLevel)
//    XCTAssertEqual(
//      round(enthalpy.humidityRatio(at: 75) * 1000000) / 1000000,
//      round(ratio * 1000000) / 1000000
//    )
    
    // Test enthalpy given a dry bulb and humidity ratio.
    let enthalpy2 = MoistAirEnthalpy.init(dryBulb: 75, ratio: ratio, units: .imperial)
    XCTAssertEqual(enthalpy.rawValue, enthalpy2.rawValue)
  }
  
  func test_temperature_from_enthalpy_and_ratio() {
    let temperature: Temperature = 75
    let humidity: RelativeHumidity = 50%
    let ratio = HumidityRatio(dryBulb: temperature, humidity: humidity, altitude: .seaLevel)
    let enthalpy = MoistAirEnthalpy.init(dryBulb: temperature, ratio: ratio, units: .imperial)
    let temperature2 = Temperature(enthalpy: enthalpy, ratio: ratio)
    XCTAssertEqual(
      round(temperature2.fahrenheit * 100) / 100,
      75
    )
    XCTAssertEqual(
      round(temperature2.fahrenheit * 100) / 100,
      temperature.fahrenheit
    )
  }
  
  func test_dry_air_enthalpy_imperial() {
    let enthalpy = Temperature.fahrenheit(77).enthalpy(units: .imperial)
    XCTAssertEqual(round(enthalpy.rawValue.rawValue * 10e8) / 10e8, 18.48)
  }
  
  // TODO: Tolerance is a bit high.
  func test_dry_air_enthalpy_metric() {
    let enthalpy = Temperature.celsius(25).enthalpy(units: .metric)
    XCTApproximatelyEqual(enthalpy.rawValue, 25148, tolerance: 2)
  }
  
  // The tolerance is decent but exponentially worse at higher temperatures.
  func test_saturated_enthalpy_imperial() {
    let values: [(Temperature, Double, Double)] = [
      (.fahrenheit(-58), -13.906, 0.1),
      (.fahrenheit(-4), -0.286, 0.1),
      (.fahrenheit(23), 8.186, 0.1),
      (.fahrenheit(41), 15.699, 0.1),
      (.fahrenheit(77), 40.576, 0.11),
      (.fahrenheit(122), 126.066, 0.52),
      (.fahrenheit(185), 999.749, 8.8)
    ]
    
    for (temp, expected, tolerance) in values {
      let saturatedEnthalpy = MoistAirEnthalpy.init(dryBulb: temp, pressure: 14.696, units: .imperial)
      XCTApproximatelyEqual(saturatedEnthalpy.rawValue.rawValue, expected, tolerance: tolerance)
    }
  }
  
  // TODO: Fix tolerances.
  func test_saturated_enthalpy_metric() {
    let values: [(Temperature, Double, Double)] = [
      (.celsius(-50), -50222, 19.778),
      (.celsius(-20), -18542, 14.791),
      (.celsius(-5), 1164, 24.82),
      (.celsius(5), 18639, 48.51),
      (.celsius(25), 76504, 197.34),
      (.celsius(50), 275353, 1121.5),
      (.celsius(85), 2307539, 20095.2)
    ]
    
    for (temp, expected, tolerance) in values {
      let saturatedEnthalpy = MoistAirEnthalpy.init(
        dryBulb: temp,
        pressure: .pascals(101325),
        units: .metric
      )
      XCTApproximatelyEqual(saturatedEnthalpy.rawValue.rawValue, expected, tolerance: tolerance)
    }
  }
  
  func test_dryBulb_from_enthalpy_and_humidityRatio_metric() {
    let temperature = Temperature.init(
      enthalpy: 81316,
      ratio: 0.02,
      units: .metric
    )
    XCTApproximatelyEqual(temperature.celsius, 30, tolerance: 0.001)
  }
  
//  func test_dryBulb_from_enthalpy_and_volume_metric() {
//    let temperature = Temperature.ini
//  }
  
  func test_humidityRatio_from_dryBulb_and_enthalpy_metric() {
    let ratio = HumidityRatio.init(
      enthalpy: .init(.init(81316, units: .joulePerKilogram)),
      dryBulb: .celsius(30),
      units: .metric
    )
    XCTApproximatelyEqual(ratio.rawValue, 0.02, tolerance: 0.001)
  }
  
  func test_moistAir_enthalpy_metric() {
    let enthalpy = MoistAirEnthalpy.init(dryBulb: .celsius(30), ratio: 0.02, units: .metric)
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
