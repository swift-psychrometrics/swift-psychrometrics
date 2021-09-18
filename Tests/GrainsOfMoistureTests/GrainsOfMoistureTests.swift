import XCTest
import GrainsOfMoisture
import Temperature
import RelativeHumidity

final class GrainsOfMoistureTests: XCTestCase {
  
  func test_grains() {
    let temperature = Temperature.fahrenheit(75)
    let grains = temperature.grains(humidity: 50%)
    XCTAssertEqual(round(grains.rawValue * 100) / 100, 65.9)
  }
}
