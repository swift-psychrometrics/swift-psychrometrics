import XCTest
import Temperature
import RelativeHumidity
import WetBulb

final class WetBulbTests: XCTestCase {
  
  func test_wetBulb_for_fahrenheit() {
    let temperature = Temperature.fahrenheit(75)
    XCTAssertEqual(
      round(temperature.wetBulb(humidity: 50%).temperature.fahrenheit * 100) / 100,
      62.51
    )
  }
}
