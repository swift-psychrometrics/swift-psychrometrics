import XCTest
import Core
import WetBulb
import HumidityRatio

final class WetBulbTests: XCTestCase {
  
  func test_wetBulb_for_fahrenheit() {
    let temperature = Temperature.fahrenheit(75)
    XCTAssertEqual(
      round(temperature.wetBulb(at: 50%).rawValue.fahrenheit * 100) / 100,
      62.51
    )
  }
  
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
  
  func test_magnitude() {
    XCTAssertEqual(WetBulb.init(10).magnitude, Temperature(10).magnitude)
  }
  
  func test_multiplication() {
    var wetBulb: WetBulb = 10 * 2
    XCTAssertEqual(wetBulb.rawValue, 20)
    wetBulb *= 3
    XCTAssertEqual(wetBulb.rawValue, 60)
  }
  
//  func test_HumidityRatio_with_wetBulb() {
//    // above freezing
//    let ratio = HumidityRatio.init(dryBulb: 86, wetBulb: 77, pressure: 14.175)
//    XCTAssertEqual(ratio, 0.0187193288418892)
//    // below freezing
//    let below = HumidityRatio.init(dryBulb: 30.2, wetBulb: 23, pressure: 14.175)
//    XCTAssertEqual(below, 0.00114657481090184)
//  }
}
