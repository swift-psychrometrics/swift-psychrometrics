import XCTest
import Core
import Enthalpy
import HumidityRatio
import TestSupport

final class EnthalpyTests: XCTestCase {
  
  func test_enthalpy() {
    let enthalpy = EnthalpyOf<MoistAir>(dryBulb: .fahrenheit(75), humidity: 50%, units: .imperial)
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.11)
    
    let enthalpy2 = Temperature.fahrenheit(75)
      .enthalpy(at: 50%, pressure: .init(altitude: .seaLevel))
    
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.11)
  }
  
  func test_enthalpy_at_altitude() {
    let enthalpy = EnthalpyOf<MoistAir>(dryBulb: .fahrenheit(75), humidity: 50%, altitude: 1000, units: .imperial)
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.49)
    
    let enthalpy2 = Temperature.fahrenheit(75).enthalpy(at: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.49)
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
    XCTAssertEqual(EnthalpyOf<MoistAir>.init(28.11), 28.11)
  }
  
  func test_comparable() {
    XCTAssertTrue(EnthalpyOf<MoistAir>.init(exactly: 30)! > 28)
  }
  
  func test_magnitude() {
    XCTAssertEqual(EnthalpyOf<MoistAir>.init(10).magnitude, 10.magnitude)
  }
  
  func test_multiplication() {
    var enthalpy: EnthalpyOf<MoistAir> = 10 * 2
    XCTAssertEqual(enthalpy.rawValue, 20)
    enthalpy *= 2
    XCTAssertEqual(enthalpy.rawValue, 40)
  }
  
  func test_humidityRatio_from_enthalpy() {
    let enthalpy = EnthalpyOf<MoistAir>(dryBulb: 75, humidity: 50%, units: .imperial)
    let ratio = HumidityRatio(for: 75, at: 50%, altitude: .seaLevel)
    XCTAssertEqual(
      round(enthalpy.humidityRatio(at: 75) * 1000000) / 1000000,
      round(ratio * 1000000) / 1000000
    )
    
    // Test enthalpy given a dry bulb and humidity ratio.
    let enthalpy2 = EnthalpyOf<MoistAir>.init(dryBulb: 75, ratio: ratio, units: .imperial)
    XCTAssertEqual(enthalpy.rawValue, enthalpy2.rawValue)
  }
  
  func test_temperature_from_enthalpy_and_ratio() {
    let temperature: Temperature = 75
    let humidity: RelativeHumidity = 50%
    let ratio = HumidityRatio(for: temperature, at: humidity, altitude: .seaLevel)
    let enthalpy = EnthalpyOf<MoistAir>.init(dryBulb: temperature, ratio: ratio, units: .imperial)
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
  
  func test_dry_air_enthalpy() {
    let enthalpy = Temperature.fahrenheit(77).enthalpy(units: .imperial)
    XCTAssertEqual(round(enthalpy.rawValue * 10e8) / 10e8, 18.48)
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
      let saturatedEnthalpy = EnthalpyOf<MoistAir>.init(dryBulb: temp, pressure: 14.696, units: .imperial)
      XCTApproximatelyEqual(saturatedEnthalpy.rawValue, expected, tolerance: tolerance)
    }
  }
  
  // TODO: Fix tolerances.
//  func test_saturated_enthalpy_metric() {
//    let values: [(Temperature, Double, Double)] = [
//      (.celsius(-50), -50222, 0.01),
//      (.celsius(-20), -18542, 0.01),
//      (.celsius(-5), 1164, 0.03),
//      (.celsius(5), 18639, 0.01),
//      (.celsius(25), 76504, 0.01),
//      (.celsius(50), 275353, 0.01),
//      (.celsius(85), 2307539, 0.01)
//    ]
//    
//    for (temp, expected, tolerance) in values {
//      let saturatedEnthalpy = EnthalpyOf<MoistAir>.init(
//        dryBulb: temp,
//        pressure: .pascals(101325),
//        units: .metric
//      )
//      XCTApproximatelyEqual(saturatedEnthalpy.rawValue, expected, tolerance: tolerance)
//    }
//  }
  
//  func test_relative_humidity_for_dewPoint_and_dryBulb_enthalpies() {
//    let totalPressure = Pressure(altitude: .seaLevel)
//    let saturationPressure = Pressure.saturationPressure(at: 75)
//    let rh = (saturationPressure.psi / totalPressure.psi)
//    print(rh)
//    XCTFail()
//  }
}
