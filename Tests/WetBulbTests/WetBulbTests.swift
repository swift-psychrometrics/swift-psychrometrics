import XCTest
import Temperature
import RelativeHumidity
import WetBulb

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
}
