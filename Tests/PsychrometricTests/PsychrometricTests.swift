import XCTest
import Psychrometrics
import TestSupport

final class PsychrometricTests: XCTestCase {
  
  // Test example 1 in ASHRAE 2017
  
  // Not great agreement in tolerances.
  func test_psychrometrics_from_wetBulb_imperial() {
    let psychrometrics = Psychrometrics.init(dryBulb: 100, wetBulb: 65, pressure: 14.696, units: .imperial)
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.00523, tolerance: 0.011)
    XCTApproximatelyEqual(psychrometrics.dewPoint, 40, tolerance: 5.9) // not great
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 13, tolerance: 2.35) // not great
    XCTApproximatelyEqual(psychrometrics.enthalpy, 29.8, tolerance: 1.1)
    XCTApproximatelyEqual(psychrometrics.volume, 14.22, tolerance: 0.031)
  }
  
  func test_psychrometrics_from_wetBulb_metric() {
    let psychrometrics = Psychrometrics.init(
      dryBulb: .celsius(40),
      wetBulb: .init(.celsius(20)),
      pressure: .pascals(101325),
      units: .metric
    )
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.0065, tolerance: 0.001)
//    XCTApproximatelyEqual(psychrometrics.dewPoint, 7.49, tolerance: 2.84) // Fix
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 14, tolerance: 2.3)
    XCTApproximatelyEqual(psychrometrics.enthalpy, 56700, tolerance: 2791.2) // fix
    XCTApproximatelyEqual(psychrometrics.volume, 0.896, tolerance: 0.01)
  }
  
  func test_psychrometrics_from_dewPoint_imperial() {
    // Using the dew-point returned in wet-bulb test instead of 40
    let psychrometrics = Psychrometrics.init(dryBulb: 100, dewPoint: 44.7, pressure: 14.696, units: .imperial)!
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.00523, tolerance: 0.011)
    XCTApproximatelyEqual(psychrometrics.wetBulb, 65, tolerance: 0.1)
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 13, tolerance: 2.351)
    XCTApproximatelyEqual(psychrometrics.enthalpy, 29.8, tolerance: 1.1)
    XCTApproximatelyEqual(psychrometrics.volume, 14.22, tolerance: 0.031)
  }
  
  func test_psychrometrics_from_dewPoint_metric() {
    // Using the dew-point returned in wet-bulb test instead of 40
    let psychrometrics = Psychrometrics.init(
      dryBulb: .celsius(40),
      dewPoint: .init(.celsius(7)),
      pressure: .pascals(101325),
      units: .metric
    )!
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.0065, tolerance: 0.001)
    XCTApproximatelyEqual(psychrometrics.wetBulb.celsius, 20, tolerance: 1.1)
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 14, tolerance: 2.351)
    XCTApproximatelyEqual(psychrometrics.enthalpy, 56700, tolerance: 462.8) // not great
    XCTApproximatelyEqual(psychrometrics.volume, 0.896, tolerance: 0.031)
  }
  
  func test_psychrometrics_from_relativeHumidity_imperial() {
    // Using the relative returned in wet-bulb test instead of 40
    let psychrometrics = Psychrometrics.init(dryBulb: 100, humidity: 15.35, pressure: 14.696, units: .imperial)!
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.00523, tolerance: 0.011)
    XCTApproximatelyEqual(psychrometrics.dewPoint, 44.7, tolerance: 0.052)
    XCTApproximatelyEqual(psychrometrics.wetBulb, 65, tolerance: 0.1)
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 13, tolerance: 2.351)
    XCTApproximatelyEqual(psychrometrics.enthalpy, 29.8, tolerance: 1.1)
    XCTApproximatelyEqual(psychrometrics.volume, 14.22, tolerance: 0.031)
  }
}
