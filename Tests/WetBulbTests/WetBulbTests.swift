import XCTest
import PsychrometricCore
import CoreUnitTypes
import TestSupport

final class WetBulbTests: XCTestCase {
  
//  func test_wetBulb_for_fahrenheit() {
//    let temperature = Temperature.fahrenheit(75)
//    XCTAssertEqual(
//      round(temperature.wetBulb(at: 50%).rawValue.fahrenheit * 100) / 100,
//      62.51
//    )
//  }
  
  func test_equatable() {
    let wetBulb: WetBulb = 75
    XCTAssertEqual(wetBulb, 75.0)
  }
  
  func test_comparable() {
    XCTAssertTrue(WetBulb.init(75) > 64)
  }
  
  func test_additon_and_subtraction() {
    var wetBulb = WetBulb.init(exactly: 63)!
    XCTAssertEqual(wetBulb.rawValue, 63)
    wetBulb += 10
    XCTAssertEqual(wetBulb.rawValue, 73)
    wetBulb -= 3
    XCTAssertEqual(wetBulb.rawValue, 70)
  }
  
//  func test_magnitude() {
//    XCTAssertEqual(WetBulb.init(10).magnitude, Temperature(10).magnitude)
//  }
  
  func test_multiplication() {
    var wetBulb: WetBulb = 10 * 2
    XCTAssertEqual(wetBulb.rawValue, 20)
    wetBulb *= 3
    XCTAssertEqual(wetBulb.rawValue, 60)
  }
  
  // TODO: Fix tolerances.
  func test_humidityRatio_and_wetBulb_imperial() throws {
    // Above freezing.
    var ratio = HumidityRatio.init(dryBulb: 86, wetBulb: 77, pressure: 14.175, units: .imperial)
    XCTApproximatelyEqual(ratio.rawValue, 0.0187193288418892, tolerance: 0.0003)
    
    // This tolerance is high
    var wetBulb = try WetBulb.init(dryBulb: 77, ratio: ratio, pressure: 14.175, units: .imperial)
    XCTApproximatelyEqual(wetBulb.fahrenheit, 77, tolerance: 2.052)
    
    // Below freezing
    ratio = .init(dryBulb: 30.2, wetBulb: 23, pressure: 14.175, units: .imperial)
    XCTApproximatelyEqual(ratio.rawValue, 0.00114657481090184, tolerance: 0.0003)
    
    wetBulb = try .init(dryBulb: 30.2, ratio: ratio, pressure: 14.175, units: .imperial)
    XCTApproximatelyEqual(wetBulb.fahrenheit, 23, tolerance: 0.001)
    
  }
  
  // TODO: Tolerance is a bit high.
  func test_wetBulb_and_relativeHumidity_metric() {
    let wetBulb = WetBulb.init(
      dryBulb: .celsius(7),
      humidity: 61%,
      pressure: .pascals(100000),
      units: .metric
    )
    XCTApproximatelyEqual(wetBulb!.celsius, 3.92667433781955, tolerance: 0.22)
  }
  
  func test_humidityRatio_and_wetBulb_metric() {
    // Above freezing
    var humidityRatio = HumidityRatio.init(
      dryBulb: .celsius(30),
      wetBulb: .init(.celsius(25)),
      pressure: .pascals(95461),
      units: .metric
    )
    XCTApproximatelyEqual(humidityRatio.rawValue, 0.0192281274241096, tolerance: 0.0003)
    
    var wetBulb = try! WetBulb.init(
      dryBulb: .celsius(30),
      ratio: humidityRatio,
      pressure: .pascals(95461),
      units: .metric
    )
    XCTApproximatelyEqual(wetBulb.celsius, 25, tolerance: 0.001)
    
    // below freezing
    humidityRatio = .init(
      dryBulb: .celsius(-1),
      wetBulb: .init(.celsius(-5)),
      pressure: .pascals(95461),
      units: .metric
    )
    XCTApproximatelyEqual(humidityRatio, 0.00120399819933844, tolerance: 0.0003)
    
    wetBulb = try! .init(
      dryBulb: .celsius(-1),
      ratio: humidityRatio,
      pressure: .pascals(95461),
      units: .metric
    )
    XCTApproximatelyEqual(wetBulb.celsius, -5, tolerance: 0.001)
  }
  
//  func test_humidityRatio_from_wetBulb() {
//    let hr = HumidityRatio(dryBulb: 77, wetBulb: 66, pressure: 14.7, units: .imperial)
//    print(hr)
//    XCTFail()
//  }
//  
//  func test_dewPoint_from_wetBulb() {
//    let dp = DewPoint(dryBulb: 73.4, wetBulb: 58.6, pressure: 14.696, units: .imperial)
//    print(dp)
//    XCTFail()
//  }
  
//  func test_HumidityRatio_with_wetBulb() {
//    // above freezing
//    let ratio = HumidityRatio.init(dryBulb: 86, wetBulb: 77, pressure: 14.175)
//    XCTAssertEqual(ratio, 0.0187193288418892)
//    // below freezing
//    let below = HumidityRatio.init(dryBulb: 30.2, wetBulb: 23, pressure: 14.175)
//    XCTAssertEqual(below, 0.00114657481090184)
//  }
}
